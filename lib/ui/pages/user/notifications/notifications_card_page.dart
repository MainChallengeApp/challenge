import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/exceptions/notification_type_is_not_supported_exception.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/pages/user/notifications/cards/connection_accepted_card.dart';
import 'package:challenge/ui/pages/user/notifications/cards/connection_request_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsCardPage extends StatefulWidget {
  final String preTitle;
  final String initialNotificationId;

  const NotificationsCardPage({
    super.key,
    required this.preTitle,
    required this.initialNotificationId,
  });

  @override
  State<NotificationsCardPage> createState() => _NotificationsCardPageState();
}

class _NotificationsCardPageState extends State<NotificationsCardPage> {
  late final notificationsProvider =
      Provider.of<NotificationsProvider>(context, listen: false);
  late final listeningNotificationsProvider =
      Provider.of<NotificationsProvider>(context);

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

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
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        children: listeningNotificationsProvider.userNotifications
            .map((NotificationModel notification) {
          switch (notification.type) {
            case NotificationTypeEnum.connectionRequest:
              return ConnectionRequestCard(
                notification: notification,
                fromUser: usersProvider
                    .getNotificationUserById(notification.fromUserId),
              );
            case NotificationTypeEnum.connectionAccepted:
              return ConnectionAcceptedCard(
                  notification: notification,
                  fromUser: usersProvider
                      .getNotificationUserById(notification.fromUserId));
            default:
              throw NotificationTypeIsNotSupportedException(
                  notification.type.toString());
          }
        }).toList(),
      ),
      bottomNavigationBar: const BottomNavigationComponent(),
    );
  }
}
