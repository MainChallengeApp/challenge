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
          .orderBy(NotificationModel.createDateField, descending: true)
          .get();
      notifications = querySnapshot.docs
          .map((doc) => NotificationModel.fromDoc(doc.data()))
          .toList();
      return notifications;
    } on Exception {
      rethrow;
    }
  }
}
