import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_notification_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  final String preTitle;

  const NotificationsPage({super.key, required this.preTitle});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
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
              onTap: () => print('Notification tapped'),
            ),
          );
        },
      ),
    );
  }
}
