import 'dart:async';

import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/pages/user/notifications/notifications_card_page.dart';
import 'package:challenge/ui/pages/user/notifications/notifications_list_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  StreamSubscription<RemoteMessage>? _messageOpenedAppSubscription;
  final _tabProvider = getIt<TabProvider>();
  final _notificationsProvider = getIt<NotificationsProvider>();

  Future<String?> getToken() async {
    return _fcm.getToken();
  }

  Future<NotificationSettings> requestPermission() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return settings;
  }

  Future<void> initialize() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _messageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);
  }

  void _handleMessageTap(RemoteMessage message) async {
    await _notificationsProvider.getUserNotifications();
    _tabProvider.selectTab(TabItemEnum.user);
    var userNavigation =
        _tabProvider.navigatorKeys[TabItemEnum.user]!.currentState!;
    userNavigation.push(NoAnimationPageRouteComponent(
      builder: (context) {
        return const NotificationsListPage();
      },
    ));
    userNavigation.push(NoAnimationPageRouteComponent(
      builder: (context) {
        return NotificationsCardPage(
          initialNotificationId: message.data['notificationId'],
        );
      },
    ));
  }

  void dispose() {
    _messageOpenedAppSubscription?.cancel();
  }
}
