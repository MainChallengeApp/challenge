import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/notification/connection_request_notification_model.dart';
import 'package:challenge/models/notification/group_challenge_request_notification_model.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/list_items/list_item_image_child_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/components/simple_components/small_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListItemNotificationComponent extends StatefulWidget {
  final NotificationModel notification;
  final void Function()? onTap;

  const ListItemNotificationComponent({
    super.key,
    this.onTap,
    required this.notification,
  });

  @override
  State<ListItemNotificationComponent> createState() =>
      _ListItemNotificationComponentState();
}

class _ListItemNotificationComponentState
    extends State<ListItemNotificationComponent> {
  final _notificationsProvider = getIt<NotificationsProvider>();
  final _usersProvider = getIt<UsersProvider>();
  final _groupChallengesProvider = getIt<GroupChallengesProvider>();

  @override
  Widget build(BuildContext context) {
    return ListItemImageChildComponent(
      slidableKey: ValueKey(widget.notification.id),
      url: widget.notification.fromUser.pictureUrl,
      icon: IconEnum.user.icon,
      onTap: widget.onTap,
      endActionPane: _endActionPane,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    widget.notification.title,
                    overflow: TextOverflow.ellipsis,
                    textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    widget.notification.body,
                    overflow: TextOverflow.ellipsis,
                    textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              ],
            ),
          ),
          ContainerInContainerTextComponent(
            text: widget.notification.timeAgo(),
            padding: const EdgeInsets.symmetric(
                horizontal: ContainerInContainerComponent.standardPaddingSmall),
            height: SmallContainerInListItemComponent.height,
            textStyle: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.tertiary),
          )
        ],
      ),
    );
  }

  ActionPane? _endActionPane(Function closeSlidable) {
    return ActionPane(
      extentRatio: 0.22,
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(
          onDismissed: () async {
            await _onTapDeleteNotification();
          },
          dismissThreshold: 0.8),
      children: [
        _deleteSlider(closeSlidable),
      ],
    );
  }

  _deleteSlider(Function closeSlidable) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(right: SpaceComponent.standardWidth),
        child: TapContainerComponent(
          height: double.infinity,
          borderRadius: 24,
          onTap: () async {
            await closeSlidable();
            await _onTapDeleteNotification();
          },
          child: Center(
              child: Icon(
            IconEnum.delete.icon,
            color: Theme.of(context).colorScheme.red,
          )),
        ),
      ),
    );
  }

  Future<void> _onTapDeleteNotification() async {
    await _notificationsProvider.deleteNotification(widget.notification.id);
    if (widget.notification is ConnectionRequestNotificationModel) {
      await _usersProvider.disconnectFromUser(widget.notification.fromUser
          .id); // apparently takes too long to delete the notification
      return;
    }

    if (widget.notification is GroupChallengeRequestNotificationModel) {
      await _groupChallengesProvider.deleteParticipant(
          (widget.notification as GroupChallengeRequestNotificationModel)
              .groupChallenge);
      return;
    }
  }
}
