import * as admin from 'firebase-admin';
import { FieldValue } from 'firebase-admin/firestore';
import * as functions from 'firebase-functions';

if (!admin.apps.length) {
  admin.initializeApp();
}

type notificationTypeType =
  | 'groupChallengeRequest'
  | 'groupChallengeAccepted'
  | 'connectionAccepted'
  | 'connectionRequest'
  | 'progressAdded';

const db = admin.firestore();

export const pushNotificationDefinition = functions.firestore.onDocumentCreated(
  'notifications/{notificationId}',
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      console.log('No data associated with the event');
      return;
    }
    const notification = snapshot.data();

    try {
      const fromUserData = await getUserById(notification.fromUserId);
      const userData = await getUserById(notification.userId);

      if (!userData.allowNotifications) {
        console.log('User has notifications turned off');
        return;
      }

      if (!userData.fcmTokens) {
        console.log('User does not have an FCM token');
        return;
      }

      let groupChallengeData;

      const notificationType: notificationTypeType = notification.type;
      switch (notificationType) {
        case 'groupChallengeRequest':
          groupChallengeData = await getGroupChallengeById(notification.groupChallengeId);
          await sendNotification(
            userData.fcmTokens,
            `${fromUserData.username} - ${groupChallengeData.title}`,
            `${fromUserData.username} invites you to ${groupChallengeData.title}`,
            {
              notificationId: snapshot.id,
            }
          );
          break;

        case 'groupChallengeAccepted':
          groupChallengeData = await getGroupChallengeById(notification.groupChallengeId);
          await sendNotification(
            userData.fcmTokens,
            `${fromUserData.username} - ${groupChallengeData.title}`,
            `${fromUserData.username} accepted your challenge ${groupChallengeData.title}`,
            {
              notificationId: snapshot.id,
            }
          );
          break;

        case 'connectionAccepted':
          await sendNotification(
            userData.fcmTokens,
            `${fromUserData.username} - Connection Accepted`,
            `${fromUserData.username} and you are now connected`,
            {
              notificationId: snapshot.id,
            }
          );
          break;

        case 'connectionRequest':
          await sendNotification(
            userData.fcmTokens,
            `${fromUserData.username} - Connection Request`,
            `${fromUserData.username} wants to connect with you`,
            {
              notificationId: snapshot.id,
            }
          );
          break;

        case 'progressAdded':
          groupChallengeData = await getGroupChallengeById(notification.groupChallengeId);
          await sendNotification(
            userData.fcmTokens,
            `${fromUserData.username} - ${groupChallengeData.title}`,
            `${fromUserData.username} added progress to ${groupChallengeData.title}`,
            {
              notificationId: snapshot.id,
            }
          );
          break;

        default:
          console.log('Unknown notification type');
      }
    } catch (error) {
      console.error('Error fetching user document:', error);
    }

    return Promise.resolve();
  }
);

async function getUserById(userId: string) {
  const userDoc = await db.collection('users').doc(userId).get();

  if (!userDoc.exists) {
    throw new Error(`fromUserDoc with id = ${userId} does not exist`);
  }

  const userData = userDoc.data();

  if (!userData) {
    throw new Error(`User document is empty for id = ${userId}`);
  }

  return userData;
}

async function getGroupChallengeById(groupChallengeId: string) {
  const groupChallengeDoc = await db.collection('group_challenges').doc(groupChallengeId).get();

  if (!groupChallengeDoc.exists) {
    throw new Error(`groupChallengeDoc with id = ${groupChallengeId} does not exist`);
  }

  const groupChallengeData = groupChallengeDoc.data();

  if (!groupChallengeData) {
    throw new Error(`GroupChallenge document is empty for id = ${groupChallengeId}`);
  }

  return groupChallengeData;
}

async function sendNotification(
  tokens: string[],
  title: string,
  body: string,
  data:
    | {
        [key: string]: string;
      }
    | undefined
) {
  try {
    const response = await admin.messaging().sendEachForMulticast({
      tokens: tokens,
      notification: { title, body },
      data: data,
    });

    // Check for failures
    const failureCount = response.failureCount;
    if (failureCount > 0) {
      const failedTokens: string[] = [];
      response.responses.forEach((resp, idx) => {
        if (!resp.success) {
          failedTokens.push(tokens[idx]);
          console.log('Error sending message:', resp.error);

          // Check for invalid token
          if (
            resp.error?.code === 'messaging/invalid-registration-token' ||
            resp.error?.code === 'messaging/registration-token-not-registered' ||
            resp.error?.code === 'messaging/invalid-argument'
          ) {
            console.log('Invalid FCM token:', tokens[idx]);
            // Here you can add logic to remove the invalid token from your database
            removeInvalidToken(tokens[idx]);
          }
        }
      });
      console.log('List of tokens that caused failures:', failedTokens);
    }
  } catch (error) {
    console.error('Error sending notification:', error);
  }
}

async function removeInvalidToken(token: string) {
  try {
    const snapshot = await db.collection('users').where('fcmTokens', 'array-contains', token).get();

    const updatePromises = snapshot.docs.map((doc) =>
      doc.ref.update({
        fcmTokens: FieldValue.arrayRemove(token),
      })
    );

    await Promise.all(updatePromises);
    console.log(`Removed invalid token ${token} from ${updatePromises.length} user(s)`);
  } catch (error) {
    console.error('Error removing invalid token:', error);
  }
}
