import 'package:challenge/collections/notifications_collection.dart';
import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/enums/participant_status_enum.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/notification/connection_accepted_notification_model.dart';
import 'package:challenge/models/notification/group_challenge_accepted_notification_model.dart';
import 'package:challenge/models/notification/group_challenge_request_notification_model.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/models/notification/progress_added_notification_model.dart';
import 'package:challenge/models/notification/request_connection_notification_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/time_service.dart';
import 'package:flutter/material.dart';

class NotificationsProvider with ChangeNotifier {
  NotificationsCollection notificationsCollection = NotificationsCollection();

  AuthService authService = AuthService();

  List<NotificationModel> _userNotifications = [];
  List<NotificationModel> get userNotifications => _userNotifications;

  Future<void> sendConnectionRequestNotification(
      UserModel toUser, UserModel fromUser) async {
    final notification = RequestConnectionNotificationModel(
      user: toUser,
      fromUser: fromUser,
      createdAt: TimeService.now(),
    );
    await notificationsCollection.create(notification);
  }

  Future<void> sendConnectionAcceptedNotification(
      UserModel toUser, UserModel fromUser) async {
    final notification = ConnectionAcceptedNotificationModel(
      user: toUser,
      fromUser: fromUser,
      createdAt: TimeService.now(),
    );
    await notificationsCollection.create(notification);
  }

  Future<void> sendGroupChallengeRequestNotification(UserModel toUser,
      UserModel fromUser, GroupChallengeModel groupChallenge) async {
    final notification = GroupChallengeRequestNotificationModel(
      user: toUser,
      fromUser: fromUser,
      groupChallenge: groupChallenge,
      createdAt: TimeService.now(),
    );
    await notificationsCollection.create(notification);
  }

  Future<void> sendGroupChallengeRequestNotificationToAll(
      UserModel fromUser, GroupChallengeModel groupChallenge) async {
    DateTime now = TimeService.now();
    List<NotificationModel> notifications = groupChallenge.participants
        .where((participantEntry) => participantEntry.user.id != fromUser.id)
        .map((participantEntry) => GroupChallengeRequestNotificationModel(
              user: participantEntry.user,
              fromUser: fromUser,
              groupChallenge: groupChallenge,
              createdAt: now,
            ))
        .toList();
    await notificationsCollection.createAll(notifications);
  }

  Future<void> sendGroupChallengeAcceptedNotification(UserModel toUser,
      UserModel fromUser, GroupChallengeModel groupChallenge) async {
    final notification = GroupChallengeAcceptedNotificationModel(
      user: toUser,
      fromUser: fromUser,
      groupChallenge: groupChallenge,
      createdAt: TimeService.now(),
    );
    await notificationsCollection.create(notification);
  }

  Future<void> sendProgressAddedNotification(
      GroupChallengeModel groupChallenge, ParticipantModel participant) async {
    DateTime now = TimeService.now();
    List<UserModel> userForNotifications = groupChallenge.participants
        .where((participantEntry) =>
            participantEntry.user.id != participant.user.id &&
            participantEntry.status == ParticipantStatusEnum.accepted)
        .map((participantEntry) => participantEntry.user)
        .toList();
    final notifications = userForNotifications
        .map((user) => ProgressAddedNotificationModel(
              user: user,
              fromUser: participant.user,
              groupChallenge: groupChallenge,
              createdAt: now,
            ))
        .toList();

    await notificationsCollection.createAll(notifications);
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

  Future<void> deleteNotifications(
      {String? userId,
      String? fromUserId,
      NotificationTypeEnum? type,
      String? groupChallengeId}) async {
    await notificationsCollection.deleteNotifications(
        userId: userId,
        fromUserId: fromUserId,
        type: type,
        groupChallengeId: groupChallengeId);
    _userNotifications.removeWhere((notification) {
      if (userId != null && notification.user.id != userId) {
        return false;
      }
      if (fromUserId != null && notification.fromUser.id != fromUserId) {
        return false;
      }
      if (type != null && notification.type != type) {
        return false;
      }
      if (groupChallengeId != null &&
              (notification is GroupChallengeRequestNotificationModel &&
                  notification.groupChallenge.id != groupChallengeId) ||
          (notification is GroupChallengeAcceptedNotificationModel &&
              notification.groupChallenge.id != groupChallengeId)) {
        return false;
      }
      return true;
    });
    notifyListeners();
  }
}
