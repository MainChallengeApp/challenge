import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
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

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    notificationsProvider.getUserNotifications();
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
        itemCount: listeningNotificationsProvider.userNotifications.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
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
      return NotificationsCardPage(
          preTitle: '${widget.preTitle}/$title',
          initialNotificationId: notificationId);
    }));
  }
}
