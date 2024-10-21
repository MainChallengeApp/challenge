import 'package:challenge/collections/notifications_collection.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:flutter/material.dart';

class NotificationsProvider with ChangeNotifier {
  NotificationsCollection notificationsCollection = NotificationsCollection();

  AuthService authService = AuthService();

  List<NotificationModel> _userNotifications = [];
  List<NotificationModel> get userNotifications => _userNotifications;

  Future<void> createNotification(NotificationModel notification) async {
    notification.createDate = DateTime.now();
    await notificationsCollection.create(notification);
  }

  Future<List<NotificationModel>> getUserNotifications() async {
    _userNotifications = await notificationsCollection
        .getByUserId(authService.getCurrentUserId());
    notifyListeners();
    return _userNotifications;
  }

  void sortUserNotifications() {
    _userNotifications.sort((a, b) => b.createDate.compareTo(a.createDate));
  }
}
