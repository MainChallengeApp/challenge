import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/user/user_picture_min_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionRequestCard extends StatefulWidget {
  final NotificationModel notification;
  final UserModel fromUser;

  const ConnectionRequestCard({
    super.key,
    required this.notification,
    required this.fromUser,
  });

  @override
  State<ConnectionRequestCard> createState() => _ConnectionRequestCardState();
}

class _ConnectionRequestCardState extends State<ConnectionRequestCard> {
  bool isLoadingAcceptButton = false;
  bool isLoadingDeclineButton = false;

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final notificationsProvider =
      Provider.of<NotificationsProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return CardComponent(
      children: [
        SpaceColumnComponent(
            child: UserPictureMinComponent(
                userPictureUrl: widget.fromUser.pictureUrl)),
        SpaceColumnComponent(
            child: CustomContainerComponent(
                child: Center(
          child: Text(
            '${widget.fromUser.username} ${widget.notification.body}',
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
    await usersProvider.disconnectFromUser(widget.fromUser.id);
    await notificationsProvider.deleteNotification(widget.notification.id);
    setState(() {
      isLoadingDeclineButton = false;
    });
    if (notificationsProvider.userNotifications.isEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      return;
    }
  }

  void onTapAccept() async {
    setState(() {
      isLoadingAcceptButton = true;
    });
    await usersProvider.connectToUser(widget.fromUser.id);
    await notificationsProvider.deleteNotification(widget.notification.id);
    setState(() {
      isLoadingAcceptButton = false;
    });
    if (notificationsProvider.userNotifications.isEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      return;
    }
  }
}
