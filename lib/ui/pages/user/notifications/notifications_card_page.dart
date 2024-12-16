import 'dart:math';

import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/exceptions/notification_type_is_not_supported_exception.dart';
import 'package:challenge/models/notification/connection_accepted_notification_model.dart';
import 'package:challenge/models/notification/connection_request_notification_model.dart';
import 'package:challenge/models/notification/group_challenge_accepted_notification_model.dart';
import 'package:challenge/models/notification/group_challenge_request_notification_model.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/models/notification/progress_added_notification_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/ui/components/cards/notifications/connection_accepted_card_component.dart';
import 'package:challenge/ui/components/cards/notifications/connection_request_card_component.dart';
import 'package:challenge/ui/components/cards/notifications/group_challenge_accepted_card_component.dart';
import 'package:challenge/ui/components/cards/notifications/group_challenge_request_card_component.dart';
import 'package:challenge/ui/components/cards/notifications/progress_added_card_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsCardPage extends StatefulWidget {
  final String initialNotificationId;

  const NotificationsCardPage({
    super.key,
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

  late PageController pageController = PageController(
      initialPage: max(
          notificationsProvider.userNotifications.indexWhere(
              (NotificationModel notification) =>
                  notification.id == widget.initialNotificationId),
          0));

  final String _title = 'Notifications';

  @override
  Widget build(BuildContext context) {
    if (listeningNotificationsProvider.userNotifications.isEmpty) {
      _navigatorPop(context);
      return Container();
    }

    return Scaffold(
      appBar: AppBarComponent(
        title: _title,
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: pageController,
        children: listeningNotificationsProvider.userNotifications
            .map((NotificationModel notification) {
          switch (notification.type) {
            case NotificationTypeEnum.connectionRequest:
              return ConnectionRequestCardComponent(
                  requestConnectionNotification:
                      notification as ConnectionRequestNotificationModel);
            case NotificationTypeEnum.connectionAccepted:
              return ConnectionAcceptedCardComponent(
                  connectionAcceptedNotification:
                      notification as ConnectionAcceptedNotificationModel);
            case NotificationTypeEnum.groupChallengeRequest:
              return GroupChallengeRequestCardComponent(
                  groupChallengeRequestNotification:
                      notification as GroupChallengeRequestNotificationModel);
            case NotificationTypeEnum.groupChallengeAccepted:
              return GroupChallengeAcceptedCardComponent(
                  groupChallengeAcceptedNotification:
                      notification as GroupChallengeAcceptedNotificationModel);
            case NotificationTypeEnum.progressAdded:
              return ProgressAddedCardComponent(
                  progressAddedNotification:
                      notification as ProgressAddedNotificationModel);
            default:
              throw NotificationTypeIsNotSupportedException(
                  notification.type.toString());
          }
        }).toList(),
      ),
      bottomNavigationBar: const BottomNavigationComponent(),
    );
  }

  void _navigatorPop(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
    });
  }
}
