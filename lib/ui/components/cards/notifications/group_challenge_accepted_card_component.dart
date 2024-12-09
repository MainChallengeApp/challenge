import 'package:challenge/models/notification/group_challenge_accepted_notification_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/user/user_picture_min_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupChallengeAcceptedCardComponent extends StatefulWidget {
  final GroupChallengeAcceptedNotificationModel
      groupChallengeAcceptedNotification;

  const GroupChallengeAcceptedCardComponent({
    super.key,
    required this.groupChallengeAcceptedNotification,
  });

  @override
  State<GroupChallengeAcceptedCardComponent> createState() =>
      _GroupChallengeAcceptedCardComponentState();
}

class _GroupChallengeAcceptedCardComponentState
    extends State<GroupChallengeAcceptedCardComponent> {
  bool isLoadingAcceptButton = false;

  late final notificationsProvider =
      Provider.of<NotificationsProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return CardComponent(
      children: [
        SpaceColumnComponent(
            child: UserPictureMinComponent(
                userPictureUrl: widget
                    .groupChallengeAcceptedNotification.fromUser.pictureUrl)),
        SpaceColumnComponent(
            child: CustomContainerComponent(
                isHeightDynamic: true,
                child: Center(
                    child: Text(widget.groupChallengeAcceptedNotification.body,
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
    await notificationsProvider
        .deleteNotification(widget.groupChallengeAcceptedNotification.id);
    if (mounted) {
      setState(() {
        isLoadingAcceptButton = false;
      });
    }
  }
}
