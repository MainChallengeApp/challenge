import 'dart:math';

import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_info_component.dart';
import 'package:challenge/ui/components/list_items/list_item_notification_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/user/notifications/notifications_card_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsListPage extends StatefulWidget {
  const NotificationsListPage({super.key});

  @override
  State<NotificationsListPage> createState() => _NotificationsListPageState();
}

class _NotificationsListPageState extends State<NotificationsListPage> {
  final _notificationsProvider = getIt<NotificationsProvider>();
  late NotificationsProvider _listeningNotificationsProvider;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _notificationsProvider.getUserNotifications();
  }

  @override
  Widget build(BuildContext context) {
    _listeningNotificationsProvider =
        Provider.of<NotificationsProvider>(context);
    return ScaffoldComponent(
      appBar: const AppBarComponent(
        title: 'Notifications',
      ),
      body: _list(),
    );
  }

  _list() {
    return RefreshIndicatorComponent(
      scrollController: _scrollController,
      onRefresh: () async {
        await _notificationsProvider.getUserNotifications();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount:
            max(_listeningNotificationsProvider.userNotifications.length, 1),
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (_listeningNotificationsProvider.userNotifications.isEmpty) {
            return const SpaceColumnComponent(
              child: ListItemInfoComponent(text: 'No Notifications'),
            );
          }
          NotificationModel notification =
              _listeningNotificationsProvider.userNotifications[index];
          return SpaceColumnComponent(
            child: ListItemNotificationComponent(
              notification: notification,
              onTap: () => _onTapNotification(notification.id),
            ),
          );
        },
      ),
    );
  }

  void _onTapNotification(String notificationId) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return NotificationsCardPage(initialNotificationId: notificationId);
    }));
  }
}
