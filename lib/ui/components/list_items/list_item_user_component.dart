import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/list_items/list_item_image_child_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ListItemUserComponent extends StatefulWidget {
  const ListItemUserComponent({
    super.key,
    required this.onTap,
    required this.user,
    this.isSearch = false,
    this.onTapConnect,
  });

  final dynamic Function() onTap;
  final Function()? onTapConnect;
  final UserModel user;
  final bool isSearch;

  @override
  State<ListItemUserComponent> createState() => _ListItemUserComponentState();
}

class _ListItemUserComponentState extends State<ListItemUserComponent> {
  final mediaService = MediaService();

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);

  @override
  Widget build(BuildContext context) {
    return ListItemImageChildComponent(
        url: widget.user.pictureUrl,
        icon: IconEnum.user.icon,
        endActionPane: endActionPane,
        onTap: widget.onTap,
        child: Row(
          children: [
            Expanded(
              child: Text(
                '@${widget.user.username}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ));
  }

  ActionPane? endActionPane(Function closeSlidable) {
    return widget.onTapConnect == null
        ? null
        : ActionPane(
            extentRatio: 0.22,
            motion: const ScrollMotion(),
            // dismissible: DismissiblePane(
            //   onDismissed: () {
            //     log('delete');
            //   },
            // ),
            children: [
                connectSlider(closeSlidable),
                const SpaceComponent(
                  width: 20,
                )
              ]);
  }

  connectSlider(Function closeSlidable) {
    bool isConnected = listeningUsersProvider.user.isConnectedWith(widget.user);
    return Expanded(
      child: TapContainerComponent(
        height: double.infinity,
        borderRadius: 24,
        onTap: () async {
          await closeSlidable();
          if (isConnected) {
            usersProvider.disconnectFromUser(widget.user.id);
          } else {
            usersProvider.connectToUser(widget.user.id);
          }
          widget.onTapConnect?.call();
        },
        child: Center(
            child: Icon(
          isConnected ? IconEnum.disconnect.icon : IconEnum.connect.icon,
          color: Theme.of(context).colorScheme.tertiary,
        )),
      ),
    );
  }
}
