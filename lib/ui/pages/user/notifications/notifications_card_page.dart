import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/exceptions/notification_type_is_not_supported_exception.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
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
  late final listeningUsersProvider = Provider.of<UsersProvider>(context);

  bool isLoadingAcceptButton = false;
  bool isLoadingDeclineButton = false;

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
              return connectionRequestCard(notification);
            case NotificationTypeEnum.connectionAccepted:
              return connectionAcceptedCard(notification);
            default:
              throw NotificationTypeIsNotSupportedException(
                  notification.type.toString());
          }
        }).toList(),
      ),
      bottomNavigationBar: const BottomNavigationComponent(),
    );
  }

  CardComponent connectionRequestCard(NotificationModel notification) {
    UserModel fromUser = listeningUsersProvider.notificationsUser.firstWhere(
        (notificationUser) => notificationUser.id == notification.fromUserId,
        orElse: UserModel.empty);
    return CardComponent(
      children: [
        Text('${fromUser.username} ${notification.body}'),
        const Expanded(child: SizedBox()),
        Row(
          children: [
            Expanded(
              child: CustomButtonComponent(
                text: 'Decline',
                isLoading: isLoadingAcceptButton,
                onTap: () async {
                  setState(() {
                    isLoadingDeclineButton = true;
                  });
                  await usersProvider.disconnectFromUser(fromUser.id);
                  await notificationsProvider
                      .deleteNotification(notification.id);
                  if (listeningNotificationsProvider
                      .userNotifications.isEmpty) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    return;
                  }
                },
              ),
            ),
            const SpaceComponent(),
            Expanded(
              child: CustomButtonComponent(
                text: 'Accept',
                isLoading: isLoadingAcceptButton,
                isPrimaryButton: true,
                onTap: () async {
                  setState(() {
                    isLoadingAcceptButton = true;
                  });
                  await usersProvider.connectToUser(fromUser.id);
                  await notificationsProvider
                      .deleteNotification(notification.id);
                  if (listeningNotificationsProvider
                      .userNotifications.isEmpty) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    return;
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  CardComponent connectionAcceptedCard(NotificationModel notification) {
    UserModel fromUser = listeningUsersProvider.notificationsUser.firstWhere(
        (notificationUser) => notificationUser.id == notification.fromUserId,
        orElse: UserModel.empty);

    return CardComponent(
      children: [
        Text('${fromUser.username} ${notification.body}'),
        const Expanded(child: SizedBox()),
        Row(
          children: [
            Expanded(
              child: CustomButtonComponent(
                text: 'Accept',
                isLoading: isLoadingAcceptButton,
                isPrimaryButton: true,
                onTap: () async {
                  setState(() {
                    isLoadingAcceptButton = true;
                  });
                  await notificationsProvider
                      .deleteNotification(notification.id);
                  if (listeningNotificationsProvider
                      .userNotifications.isEmpty) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    return;
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
