import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/ui/components/list_items/list_item_image_child_component.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return ListItemImageChildComponent(
      url: widget.notification.fromUser.pictureUrl,
      icon: IconEnum.user.icon,
      onTap: widget.onTap,
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
    );
  }
}
