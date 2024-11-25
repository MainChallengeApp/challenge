import 'package:challenge/collections/collection.dart';
import 'package:challenge/collections/group_challenges_collection.dart';
import 'package:challenge/collections/users_collection.dart';
import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/exceptions/group_challenge_not_found_exception.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/notification/group_challenge_request_notification_model.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsCollection extends Collection {
  static String collectionName = 'notifications';

  final _groupChallengesCollection = GroupChallengesCollection();
  final _usersCollection = UsersCollection();

  NotificationsCollection() : super(name: collectionName);

  Future<void> create(NotificationModel notification) async {
    await db.collection(name).add(notification.toDoc());
  }

  Future<void> update(NotificationModel notification) async {
    await db.collection(name).doc(notification.id).update(notification.toDoc());
  }

  Future<List<NotificationModel>> getByUserId(String userId) async {
    try {
      final querySnapshot = await db
          .collection(name)
          .where(NotificationModel.userIdField, isEqualTo: userId)
          .get();

      List<NotificationModel> notifications =
          await Future.wait(querySnapshot.docs.map((doc) async {
        var user =
            await _usersCollection.getById(doc[NotificationModel.userIdField]);
        var fromUser = await _usersCollection
            .getById(doc[NotificationModel.fromUserIdField]);

        NotificationTypeEnum notificationType =
            NotificationTypeEnum.fromString(doc[NotificationModel.typeField]);

        if (notificationType == NotificationTypeEnum.groupChallengeRequest ||
            notificationType == NotificationTypeEnum.groupChallengeAccepted) {
          try {
            GroupChallengeModel groupChallenge =
                await _groupChallengesCollection.getById(doc[
                    GroupChallengeRequestNotificationModel
                        .groupChallengeIdField]);
            return NotificationModel.fromDoc(doc,
                user: user, fromUser: fromUser, groupChallenge: groupChallenge);
          } on GroupChallengeNotFoundException catch (_) {
            await deleteNotifications(
                userId: userId,
                groupChallengeId: doc[GroupChallengeRequestNotificationModel
                    .groupChallengeIdField]);
            return null;
          }
        }
        return NotificationModel.fromDoc(doc, user: user, fromUser: fromUser);
      })).then((list) => list.whereType<NotificationModel>().toList());

      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return notifications;
    } on Exception {
      rethrow;
    }
  }

  deleteById(String notificationId) async {
    await db.collection(name).doc(notificationId).delete();
  }

  Future<void> deleteNotifications(
      {String? userId,
      String? fromUserId,
      NotificationTypeEnum? type,
      String? groupChallengeId}) async {
    var collection = db.collection(name);

    Query? query;

    if (userId != null) {
      query =
          collection.where(NotificationModel.userIdField, isEqualTo: userId);
    }

    if (fromUserId != null) {
      query = (query ?? collection)
          .where(NotificationModel.fromUserIdField, isEqualTo: fromUserId);
    }

    // Add type filter if type is not null
    if (type != null) {
      query = (query ?? collection)
          .where(NotificationModel.typeField, isEqualTo: type.type);
    }

    if (groupChallengeId != null) {
      query = (query ?? collection).where(
          GroupChallengeRequestNotificationModel.groupChallengeIdField,
          isEqualTo: groupChallengeId);
    }

    // Execute the queries
    var snapshot = await (query ?? collection).get();

    // Delete the documents
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
