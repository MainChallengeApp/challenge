import 'package:challenge/collections/notifications_collection.dart';
import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/time_service.dart';
import 'package:flutter/material.dart';

class NotificationsProvider with ChangeNotifier {
  NotificationsCollection notificationsCollection = NotificationsCollection();

  AuthService authService = AuthService();

  List<NotificationModel> _userNotifications = [];
  List<NotificationModel> get userNotifications => _userNotifications;

  Future<void> createNotification(
      String toUserId, String fromUserId, NotificationTypeEnum type) async {
    final notification = NotificationModel(
      userId: toUserId,
      fromUserId: fromUserId,
      type: type,
      createdAt: TimeService.now(),
    );
    await notificationsCollection.create(notification);
  }

  Future<List<NotificationModel>> getUserNotifications() async {
    _userNotifications = await notificationsCollection
        .getByUserId(authService.getCurrentUserId());
    notifyListeners();
    return _userNotifications;
  }

  Future<void> deleteNotification(String notificationId) async {
    await notificationsCollection.deleteById(notificationId);
    _userNotifications.removeWhere((element) => element.id == notificationId);
    notifyListeners();
  }

  void sortUserNotifications() {
    _userNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void resetLocalList() {
    _userNotifications = [];
  }

  Future<void> deleteNotificationsBetweenUsers(
      {required String currentUser,
      required String otherUser,
      NotificationTypeEnum? type}) async {
    await notificationsCollection.deleteNotifications(
        currentUser, otherUser, type);
    _userNotifications.removeWhere((notification) =>
        ((notification.userId == currentUser &&
                notification.fromUserId == otherUser) ||
            (notification.userId == otherUser &&
                notification.fromUserId == currentUser)) &&
        (type == null || notification.type == type));
    notifyListeners();
  }
}
