import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/challenge/reminder_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/push_notification_service.dart';
import 'package:challenge/services/time_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz2;

class LocalPushNotificationService {
  static final LocalPushNotificationService _instance =
      LocalPushNotificationService._internal();
  factory LocalPushNotificationService() => _instance;
  LocalPushNotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final _groupChallengesProvider = getIt<GroupChallengesProvider>();
  static final _usersProvider = getIt<UsersProvider>();

  static final _pushNotificationService = PushNotificationService();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    final location = tz2.getLocation(timeZoneName);
    tz2.setLocalLocation(location);

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
            requestAlertPermission: false,
            requestSoundPermission: false,
            requestBadgePermission: false);

    const InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: iosInitializationSettings,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleRepeatingNotification({
    required int id,
    required String title,
    required String body,
    required Time time,
  }) async {
    if (!_usersProvider.user.allowNotifications) {
      return;
    }

    final notificationPermission =
        await _pushNotificationService.requestPermission();

    if (notificationPermission.authorizationStatus !=
        AuthorizationStatus.authorized) {
      return;
    }

    final now = TimeService.now();

    var scheduledDate = tz2.TZDateTime(tz2.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> setUpChallengeReminder(
      {required String challengeTitle, required ReminderModel reminder}) async {
    await scheduleRepeatingNotification(
      id: reminder.id,
      title: challengeTitle,
      body: 'Your daily challenge reminder!',
      time: Time(reminder.hours, reminder.minutes),
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> cancelNotificationById(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> activateAllChallengeNotifications() async {
    await cancelAllNotifications();
    for (var challenge in _groupChallengesProvider.groupChallenges) {
      ParticipantModel participant =
          challenge.getParticipant(_usersProvider.user.id);
      if (participant.reminder?.isActive ?? false) {
        await setUpChallengeReminder(
          challengeTitle: challenge.title,
          reminder: participant.reminder!,
        );
      }
    }
  }
}
