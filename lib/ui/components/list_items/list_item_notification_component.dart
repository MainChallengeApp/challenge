import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:flutter/material.dart';

class ListItemNotificationComponent extends StatefulWidget {
  final NotificationModel notification;
  final void Function()? onTap;

  const ListItemNotificationComponent(
      {super.key, this.onTap, required this.notification});

  @override
  State<ListItemNotificationComponent> createState() =>
      _ListItemNotificationComponentState();
}

class _ListItemNotificationComponentState
    extends State<ListItemNotificationComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemIconTextComponent(
        icon: IconEnum.openResponses.icon,
        title: widget.notification.title,
        onTap: widget.onTap);
  }
}
