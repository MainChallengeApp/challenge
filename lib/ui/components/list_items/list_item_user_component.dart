import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/list_items/list_item_image_child_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListItemUserComponent extends StatefulWidget {
  const ListItemUserComponent({
    super.key,
    required this.onTap,
    required this.user,
    this.isSearch = false,
    required this.onTapConnect,
  });

  final dynamic Function() onTap;
  final Function() onTapConnect;
  final UserModel user;
  final bool isSearch;

  @override
  State<ListItemUserComponent> createState() => _ListItemUserComponentState();
}

class _ListItemUserComponentState extends State<ListItemUserComponent> {
  final mediaService = MediaService();

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
              ),
            ),
          ],
        ));
  }

  ActionPane? endActionPane(Function closeSlidable) {
    return ActionPane(
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
    return Expanded(
      child: TapContainerComponent(
        height: double.infinity,
        borderRadius: 24,
        onTap: () async {
          await closeSlidable();
          widget.onTapConnect.call();
        },
        child: Center(
            child: Icon(
          IconEnum.connect.icon,
          color: themeColor3,
        )),
      ),
    );
  }
}
