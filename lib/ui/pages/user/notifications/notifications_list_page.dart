import 'dart:math';

import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_info_component.dart';
import 'package:challenge/ui/components/list_items/list_item_notification_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
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
  final String title = 'Notifications';

  late final notificationsProvider =
      Provider.of<NotificationsProvider>(context, listen: false);
  late final listeningNotificationsProvider =
      Provider.of<NotificationsProvider>(context);

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    notificationsProvider.getUserNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
      appBar: AppBarComponent(
        title: title,
      ),
      body: list(),
    );
  }

  list() {
    return RefreshIndicatorComponent(
      scrollController: scrollController,
      onRefresh: () async {
        await notificationsProvider.getUserNotifications();
      },
      child: ListView.builder(
        controller: scrollController,
        itemCount:
            max(listeningNotificationsProvider.userNotifications.length, 1),
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (listeningNotificationsProvider.userNotifications.isEmpty) {
            return const SpaceColumnComponent(
              child: ListItemInfoComponent(text: 'No Notifications'),
            );
          }
          NotificationModel notification =
              listeningNotificationsProvider.userNotifications[index];
          return SpaceColumnComponent(
            child: ListItemNotificationComponent(
              notification: notification,
              onTap: () => onTapNotification(notification.id),
            ),
          );
        },
      ),
    );
  }

  void onTapNotification(String notificationId) {
    Navigator.push(context,
        NoAnimationPageRouteComponent(builder: (BuildContext context) {
      return NotificationsCardPage(initialNotificationId: notificationId);
    }));
  }
}
