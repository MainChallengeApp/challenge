import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_image_child_component.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListItemUserComponent extends StatefulWidget {
  const ListItemUserComponent({
    super.key,
    required this.onTap,
    required this.user,
    this.isSearch = false,
    this.onTapConnect,
    this.isSelected = false,
  });

  final dynamic Function() onTap;
  final Function()? onTapConnect;
  final UserModel user;
  final bool isSearch;
  final bool isSelected;

  @override
  State<ListItemUserComponent> createState() => _ListItemUserComponentState();
}

class _ListItemUserComponentState extends State<ListItemUserComponent> {
  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);

  bool loadingAction = false;

  @override
  Widget build(BuildContext context) {
    return ListItemImageChildComponent(
        url: widget.user.pictureUrl,
        icon: IconEnum.user.icon,
        onTap: widget.onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.user.username,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SpaceComponent(
              width: 10,
            ),
            GestureDetector(
              onTap: onTapConnect,
              child: Visibility(
                visible: !listeningUsersProvider.user
                        .isBlocked(widget.user.id) &&
                    !listeningUsersProvider.user.connectionIds.contains(
                        widget.user.id) && // different from isConnectedWith()
                    widget.onTapConnect != null,
                child: ContainerInListItemComponent(
                  margin: const EdgeInsets.all(0),
                  child: Center(
                      child: loadingAction
                          ? const LoadingCircleComponent()
                          : Icon(
                              IconEnum.connect.icon,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: 20,
                            )),
                ),
              ),
            ),
            Visibility(
                visible: widget.isSelected,
                child: ContainerInListItemComponent(
                    margin: const EdgeInsets.only(
                        left: ContainerInContainerComponent.standardMargin),
                    child: Center(
                        child: Icon(
                      IconEnum.select.icon,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 20,
                    )))),
          ],
        ));
  }

  void onTapConnect() async {
    setState(() {
      loadingAction = true;
    });
    await usersProvider.connectToUser(widget.user.id);
    if (mounted) {
      setState(() {
        loadingAction = false;
      });
    }
  }
}
