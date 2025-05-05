import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/list_items/list_item_image_child_component.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/small_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListItemUserComponent extends StatefulWidget {
  const ListItemUserComponent({
    super.key,
    required this.onTap,
    required this.user,
    this.isSearch = false,
    this.isSelected = false,
  });

  final dynamic Function() onTap;
  final UserModel user;
  final bool isSearch;
  final bool isSelected;

  @override
  State<ListItemUserComponent> createState() => _ListItemUserComponentState();
}

class _ListItemUserComponentState extends State<ListItemUserComponent> {
  final _usersProvider = getIt<UsersProvider>();
  late UsersProvider _listeningUsersProvider;

  bool _loadingAction = false;

  @override
  Widget build(BuildContext context) {
    _listeningUsersProvider = Provider.of<UsersProvider>(context);
    return ListItemImageChildComponent(
        url: widget.user.pictureUrl,
        icon: IconEnum.user.icon,
        onTap: widget.onTap,
        child: Row(
          children: [
            _userName(),
            _space(),
            _connectIcon(),
            _isSelectedIcon(),
          ],
        ));
  }

  SpaceComponent _space() {
    return const SpaceComponent(
        width: ContainerInContainerComponent.standardPaddingSmall);
  }

  Visibility _isSelectedIcon() {
    return Visibility(
        visible: widget.isSelected,
        child: ContainerInContainerComponent(
            height: SmallContainerInListItemComponent.height,
            width: SmallContainerInListItemComponent.height,
            padding: const EdgeInsets.all(0),
            child: Center(
                child: Icon(
              IconEnum.select.icon,
              color: Theme.of(context).colorScheme.tertiary,
              size: Theme.of(context).textTheme.titleLarge?.fontSize,
            ))));
  }

  GestureDetector _connectIcon() {
    return GestureDetector(
      onTap: _onTapConnect,
      child: Visibility(
        visible: !_listeningUsersProvider.user.isBlocked(widget.user.id) &&
            !_listeningUsersProvider.user.connectionIds
                .contains(widget.user.id), // different from isConnectedWith()
        child: ContainerInListItemComponent(
          margin: const EdgeInsets.all(0),
          child: Center(
              child: _loadingAction
                  ? const LoadingCircleComponent()
                  : Icon(
                      IconEnum.connect.icon,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: Theme.of(context).textTheme.titleLarge?.fontSize,
                    )),
        ),
      ),
    );
  }

  Expanded _userName() {
    return Expanded(
      child: Text(
        widget.user.username,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  void _onTapConnect() async {
    setState(() {
      _loadingAction = true;
    });
    await _usersProvider.connectToUser(widget.user.id);
    if (mounted) {
      setState(() {
        _loadingAction = false;
      });
    }
  }
}
