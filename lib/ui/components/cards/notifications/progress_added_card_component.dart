import 'package:challenge/models/notification/progress_added_notification_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/user/user_picture_min_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressAddedCardComponent extends StatefulWidget {
  final ProgressAddedNotificationModel progressAddedNotification;

  const ProgressAddedCardComponent({
    super.key,
    required this.progressAddedNotification,
  });

  @override
  State<ProgressAddedCardComponent> createState() =>
      _ProgressAddedCardComponentState();
}

class _ProgressAddedCardComponentState
    extends State<ProgressAddedCardComponent> {
  bool isLoadingAcceptButton = false;

  late final notificationsProvider =
      Provider.of<NotificationsProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return CardComponent(
      children: [
        SpaceColumnComponent(
            child: UserPictureMinComponent(
                userPictureUrl:
                    widget.progressAddedNotification.fromUser.pictureUrl)),
        SpaceColumnComponent(
            child: CustomContainerComponent(
                isHeightDynamic: true,
                child: Center(
                    child: Text(widget.progressAddedNotification.body,
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
        .deleteNotification(widget.progressAddedNotification.id);
    if (mounted) {
      setState(() {
        isLoadingAcceptButton = false;
      });
    }
  }
}
