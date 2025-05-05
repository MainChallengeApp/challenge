import 'package:challenge/models/notification/connection_accepted_notification_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/user/user_picture_min_component.dart';
import 'package:flutter/material.dart';

class ConnectionAcceptedCardComponent extends StatefulWidget {
  final ConnectionAcceptedNotificationModel connectionAcceptedNotification;

  const ConnectionAcceptedCardComponent({
    super.key,
    required this.connectionAcceptedNotification,
  });

  @override
  State<ConnectionAcceptedCardComponent> createState() =>
      _ConnectionAcceptedCardComponentState();
}

class _ConnectionAcceptedCardComponentState
    extends State<ConnectionAcceptedCardComponent> {
  bool isLoadingAcceptButton = false;

  final _notificationsProvider = getIt<NotificationsProvider>();

  final UsersProvider _usersProvider = getIt<UsersProvider>();

  @override
  Widget build(BuildContext context) {
    return CardComponent(
      children: [
        SpaceColumnComponent(
            child: UserPictureMinComponent(
                userPictureUrl:
                    widget.connectionAcceptedNotification.fromUser.pictureUrl)),
        SpaceColumnComponent(
            child: CustomContainerComponent(
                isHeightDynamic: true,
                child: Center(
                    child: Text(widget.connectionAcceptedNotification.body,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium)))),
        const Expanded(child: SizedBox()),
        Row(
          children: [
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

  void onTapAccept() async {
    setState(() {
      isLoadingAcceptButton = true;
    });
    await _notificationsProvider
        .deleteNotification(widget.connectionAcceptedNotification.id);
    await _usersProvider.getConnections();
    if (mounted) {
      setState(() {
        isLoadingAcceptButton = false;
      });
    }
  }
}
