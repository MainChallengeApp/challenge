import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/user/user_picture_min_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionAcceptedCard extends StatefulWidget {
  final NotificationModel notification;
  final UserModel fromUser;

  const ConnectionAcceptedCard({
    super.key,
    required this.notification,
    required this.fromUser,
  });

  @override
  State<ConnectionAcceptedCard> createState() => _ConnectionAcceptedCardState();
}

class _ConnectionAcceptedCardState extends State<ConnectionAcceptedCard> {
  bool isLoadingAcceptButton = false;

  late final notificationsProvider =
      Provider.of<NotificationsProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return CardComponent(
      children: [
        SpaceColumnComponent(
            child: UserPictureMinComponent(
                userPictureUrl: widget.fromUser.pictureUrl)),
        Text('${widget.fromUser.username} ${widget.notification.body}'),
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
    await notificationsProvider.deleteNotification(widget.notification.id);
    if (notificationsProvider.userNotifications.isEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      return;
    }
  }
}
