import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<String?> getToken() async {
    String? token = await _fcm.getToken();
    log('FCM Token: $token');
    return token;
  }

  void initNotifications() async {
    // Request permission (required for iOS)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');

      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      log('APNS Token: $apnsToken');

      // Get the token
      await getToken();

      // TODO: Send this token to your server

      // Handle token refresh
      _fcm.onTokenRefresh.listen((newToken) {
        // TODO: Send this new token to your server
      });

      // Handle incoming messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log('Got a message whilst in the foreground!');
        log('Message data: ${message.data}');

        if (message.notification != null) {
          log('Message also contained a notification: ${message.notification}');
        }
      });
    } else {
      log('User declined or has not accepted permission');
    }
  }
}
