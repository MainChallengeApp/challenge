import 'package:challenge/models/notification/connection_request_notification_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/user/user_picture_min_component.dart';
import 'package:flutter/material.dart';

class ConnectionRequestCardComponent extends StatefulWidget {
  final ConnectionRequestNotificationModel requestConnectionNotification;

  const ConnectionRequestCardComponent({
    super.key,
    required this.requestConnectionNotification,
  });

  @override
  State<ConnectionRequestCardComponent> createState() =>
      _ConnectionRequestCardComponentState();
}

class _ConnectionRequestCardComponentState
    extends State<ConnectionRequestCardComponent> {
  bool isLoadingAcceptButton = false;
  bool isLoadingDeclineButton = false;

  final usersProvider = getIt<UsersProvider>();
  final notificationsProvider = getIt<NotificationsProvider>();

  @override
  Widget build(BuildContext context) {
    return CardComponent(
      children: [
        SpaceColumnComponent(
            child: UserPictureMinComponent(
                userPictureUrl:
                    widget.requestConnectionNotification.fromUser.pictureUrl)),
        SpaceColumnComponent(
            child: CustomContainerComponent(
                child: Center(
          child: Text(
            widget.requestConnectionNotification.body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ))),
        const Expanded(child: SizedBox()),
        Row(
          children: [
            Expanded(
              child: CustomButtonComponent(
                text: 'Decline',
                isLoading: isLoadingDeclineButton,
                onTap: onTapDecline,
              ),
            ),
            const SpaceComponent(),
            Expanded(
              child: CustomButtonComponent(
                text: 'Accept',
                isLoading: isLoadingAcceptButton,
                isPrimaryButton: true,
                onTap: onTapAccept,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void onTapDecline() async {
    setState(() {
      isLoadingDeclineButton = true;
    });
    await usersProvider
        .disconnectFromUser(widget.requestConnectionNotification.fromUser.id);
    // await notificationsProvider.deleteNotification(widget.notification.id);

    if (mounted) {
      setState(() {
        isLoadingDeclineButton = false;
      });
    }
  }

  void onTapAccept() async {
    setState(() {
      isLoadingAcceptButton = true;
    });
    await usersProvider
        .connectToUser(widget.requestConnectionNotification.fromUser.id);
    // await notificationsProvider.deleteNotification(widget.notification.id);
    if (mounted) {
      setState(() {
        isLoadingAcceptButton = false;
      });
    }
  }
}
