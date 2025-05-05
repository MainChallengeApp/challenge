import 'dart:async';
import 'dart:developer';

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

  StreamSubscription<QuerySnapshot>? _subscription;

  NotificationsCollection() : super(name: collectionName);

  Future<void> create(NotificationModel notification) async {
    await db.collection(name).add(notification.toDoc());
  }

  Future<void> createAll(List<NotificationModel> notifications) async {
    WriteBatch batch = db.batch();

    for (var notification in notifications) {
      batch.set(db.collection(name).doc(), notification.toDoc());
    }

    await batch.commit();
  }

  Future<void> update(NotificationModel notification) async {
    await db.collection(name).doc(notification.id).update(notification.toDoc());
  }

  // Todo: pagination
  Future<List<NotificationModel>> getByUserId(String userId) async {
    try {
      final querySnapshot = await db
          .collection(name)
          .where(NotificationModel.userIdField, isEqualTo: userId)
          .get();

      List<NotificationModel> notifications = await Future.wait(
              querySnapshot.docs.map((doc) async => await getNotification(doc)))
          .then((list) => list.whereType<NotificationModel>().toList());

      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return notifications;
    } on Exception {
      rethrow;
    }
  }

  Future<NotificationModel?> getNotification(
      DocumentSnapshot notificationDoc) async {
    var user = await _usersCollection
        .getById(notificationDoc[NotificationModel.userIdField]);
    var fromUser = await _usersCollection
        .getById(notificationDoc[NotificationModel.fromUserIdField]);

    if ((notificationDoc.data() as Map).containsKey(
        GroupChallengeRequestNotificationModel.groupChallengeIdField)) {
      try {
        GroupChallengeModel groupChallenge =
            await _groupChallengesCollection.getById(notificationDoc[
                GroupChallengeRequestNotificationModel.groupChallengeIdField]);
        return NotificationModel.fromDoc(notificationDoc,
            user: user, fromUser: fromUser, groupChallenge: groupChallenge);
      } on GroupChallengeNotFoundException catch (_) {
        await deleteNotifications(
            userId: notificationDoc[NotificationModel.userIdField],
            groupChallengeId: notificationDoc[
                GroupChallengeRequestNotificationModel.groupChallengeIdField]);
        return null;
      } catch (_) {
        return null;
      }
    }
    return NotificationModel.fromDoc(notificationDoc,
        user: user, fromUser: fromUser);
  }

  // Todo: not used right now (for pagination)
  Future<int> getNotificationsCount(String userId) async {
    try {
      final querySnapshot = await db
          .collection(name)
          .where(NotificationModel.userIdField, isEqualTo: userId)
          .count()
          .get();

      return querySnapshot.count ?? 0;
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

  void listenToUserNotifications(String userId, Function onAdd) {
    // Create a query
    Query query = db
        .collection(collectionName)
        .where(NotificationModel.userIdField, isEqualTo: userId)
        .orderBy(NotificationModel.createdAtField, descending: true)
        .limit(1);

    // Set up the listener
    _subscription = query.snapshots().listen(
      (QuerySnapshot snapshot) {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            onAdd(change.doc);
          }
        }
      },
      onError: (error) => log(
          'Listen failed: $error'), // [log] Listen failed: [cloud_firestore/failed-precondition] The query requires an index. You can create it here: https://console.firebase.google.com/v1/r/project/challenge-dev-sdgi/firestore/indexes?create_composite=Clhwcm9qZWN0cy9jaGFsbGVuZ2UtZGV2LXNkZ2kvZGF0YWJhc2VzLyhkZWZhdWx0KS9jb2xsZWN0aW9uR3JvdXBzL25vdGlmaWNhdGlvbnMvaW5kZXhlcy9fEAEaCgoGdXNlcklkEAEaDQoJY3JlYXRlZEF0EAIaDAoIX19uYW1lX18QAg
    );
  }

  void stopListening() {
    _subscription?.cancel();
  }
}
