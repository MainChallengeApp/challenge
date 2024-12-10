import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

if (!admin.apps.length) {
  admin.initializeApp();
}

type notificationTypeType =
  | "groupChallengeRequest"
  | "groupChallengeAccepted"
  | "connectionAccepted"
  | "connectionRequest"
  | "progressAdded";

const db = admin.firestore();

export const pushNotification = functions.firestore.onDocumentCreated(
  "notifications/{notificationId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      console.log("No data associated with the event");
      return;
    }
    const notification = snapshot.data();

    try {
      const fromUserData = await getUserById(notification.fromUserId);
      const userData = await getUserById(notification.userId);

      if (!userData.allowNotifications) {
        console.log("User has notifications turned off");
        return;
      }

      if (!userData.fcmTokens) {
        console.log("User does not have an FCM token");
        return;
      }

      let groupChallengeData;

      const notificationType: notificationTypeType = notification.type;
      switch (notificationType) {
      case "groupChallengeRequest":
        groupChallengeData = await getGroupChallengeById(
          notification.groupChallengeId
        );

        await admin.messaging().sendEachForMulticast({
          tokens: userData.fcmTokens,
          notification: {
            title: "Challenge Invitation",
            body: `${fromUserData.username} invites you to "${groupChallengeData.title}"`,
          },
          data: {
            notificationId: snapshot.id,
          },
        });
        break;

      case "groupChallengeAccepted":
        groupChallengeData = await getGroupChallengeById(
          notification.groupChallengeId
        );
        await admin.messaging().sendEachForMulticast({
          tokens: userData.fcmTokens,
          notification: {
            title: "Challenge Accepted",
            body: `${fromUserData.username} accepted "${groupChallengeData.title}"`,
          },
          data: {
            notificationId: snapshot.id,
          },
        });
        break;

      case "connectionAccepted":
        await admin.messaging().sendEachForMulticast({
          tokens: userData.fcmTokens,
          notification: {
            title: "Connection Accepted",
            body: `${fromUserData.username} and you are connected`,
          },
          data: {
            notificationId: snapshot.id,
          },
        });
        break;

      case "connectionRequest":
        await admin.messaging().sendEachForMulticast({
          tokens: userData.fcmTokens,
          notification: {
            title: "Connection Request",
            body: `${fromUserData.username} wants to connect with you`,
          },
          data: {
            notificationId: snapshot.id,
          },
        });
        break;

      case "progressAdded":
        groupChallengeData = await getGroupChallengeById(
          notification.groupChallengeId
        );

        await admin.messaging().sendEachForMulticast({
          tokens: userData.fcmTokens,
          notification: {
            title: "Progress Added",
            body: `${fromUserData.username} added progress to "${groupChallengeData.title}"`,
          },
          data: {
            notificationId: snapshot.id,
          },
        });
        break;

      default:
        console.log("Unknown notification type");
      }
    } catch (error) {
      console.error("Error fetching user document:", error);
    }

    return Promise.resolve();
  }
);

async function getUserById(userId: string) {
  const userDoc = await db.collection("users").doc(userId).get();

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
  const groupChallengeDoc = await db
    .collection("group_challenges")
    .doc(groupChallengeId)
    .get();

  if (!groupChallengeDoc.exists) {
    throw new Error(
      `groupChallengeDoc with id = ${groupChallengeId} does not exist`
    );
  }

  const groupChallengeData = groupChallengeDoc.data();

  if (!groupChallengeData) {
    throw new Error(
      `GroupChallenge document is empty for id = ${groupChallengeId}`
    );
  }

  return groupChallengeData;
}
