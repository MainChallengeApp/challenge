import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_child_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late final listeningUsersProvider = Provider.of<UsersProvider>(context);
  UserModel fromUser = UserModel.empty();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listeningUsersProvider
        .getUserById(widget.notification.fromUserId)
        .then((value) {
      setState(() {
        fromUser = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListItemIconChildComponent(
      icon: IconEnum.openResponses.icon,
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: Text(
              fromUser.username,
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
