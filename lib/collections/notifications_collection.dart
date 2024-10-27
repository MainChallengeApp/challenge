import 'package:challenge/collections/collection.dart';
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

  Future<void> deleteNotificationsBetweenUsers(
      String currentUser, String otherUser) async {
    await db
        .collection(name)
        .where(NotificationModel.userIdField, isEqualTo: otherUser)
        .where(NotificationModel.fromUserIdField, isEqualTo: currentUser)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
