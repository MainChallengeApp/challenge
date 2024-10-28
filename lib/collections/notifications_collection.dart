import 'package:challenge/collections/collection.dart';
import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/models/notification/notification_model.dart';

class NotificationsCollection extends Collection {
  static String collectionName = 'notifications';

  NotificationsCollection() : super(name: collectionName);

  Future<void> create(NotificationModel notification) async {
    await db.collection(name).add(notification.toDoc());
  }

  Future<void> update(NotificationModel notification) async {
    await db.collection(name).doc(notification.id).update(notification.toDoc());
  }

  Future<List<NotificationModel>> getByUserId(String userId) async {
    List<NotificationModel> notifications = [];
    try {
      final querySnapshot = await db
          .collection(name)
          .where(NotificationModel.userIdField, isEqualTo: userId)
          .get();
      notifications = querySnapshot.docs
          .map((doc) => NotificationModel.fromDoc(doc))
          .toList();
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
      String currentUser, String otherUser, NotificationTypeEnum? type) async {
    // First query
    var query1 = db
        .collection(name)
        .where(NotificationModel.userIdField, isEqualTo: otherUser)
        .where(NotificationModel.fromUserIdField, isEqualTo: currentUser);

    // Second query
    var query2 = db
        .collection(name)
        .where(NotificationModel.userIdField, isEqualTo: currentUser)
        .where(NotificationModel.fromUserIdField, isEqualTo: otherUser);

    // Add type filter if type is not null
    if (type != null) {
      query1 = query1.where(NotificationModel.typeField, isEqualTo: type.type);
      query2 = query2.where(NotificationModel.typeField, isEqualTo: type.type);
    }

    // Execute the queries
    var snapshot1 = await query1.get();
    var snapshot2 = await query2.get();

    // Combine the results
    var combinedSnapshots = [...snapshot1.docs, ...snapshot2.docs];

    // Delete the documents
    for (var doc in combinedSnapshots) {
      await doc.reference.delete();
    }
  }
}
