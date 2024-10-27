import 'dart:math';

import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_notification_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/user/notifications/notifications_card_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsListPage extends StatefulWidget {
  final String preTitle;

  const NotificationsListPage({super.key, required this.preTitle});

  @override
  State<NotificationsListPage> createState() => _NotificationsListPageState();
}

class _NotificationsListPageState extends State<NotificationsListPage> {
  final String title = 'Notifications';

  late final notificationsProvider =
      Provider.of<NotificationsProvider>(context, listen: false);
  late final listeningNotificationsProvider =
      Provider.of<NotificationsProvider>(context);

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    notificationsProvider.getUserNotifications().then((_) {
      usersProvider.getNotificationsUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        preTitle: widget.preTitle,
        titleText: title,
      ),
      body: list(),
      bottomNavigationBar: const BottomNavigationComponent(),
    );
  }

  list() {
    notificationsProvider.sortUserNotifications();
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
            return SpaceColumnComponent(
              child: ListItemIconTextComponent(
                  icon: IconEnum.info.icon, title: 'No Notifications'),
            );
          }
          NotificationModel notification =
              listeningNotificationsProvider.userNotifications[index];
          return SpaceColumnComponent(
            child: ListItemNotificationComponent(
              notification: notification,
              fromUser: listeningUsersProvider
                  .getNotificationUserById(notification.fromUserId),
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
      return NotificationsCardPage(
          preTitle: '${widget.preTitle}/$title',
          initialNotificationId: notificationId);
    }));
  }
}
