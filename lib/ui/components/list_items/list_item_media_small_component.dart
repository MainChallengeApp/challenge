import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/media/image_media_model.dart';
import 'package:challenge/models/challenge/media/media_model.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_image_child_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListItemMediaSmallComponent extends StatefulWidget {
  const ListItemMediaSmallComponent(
      {super.key,
      required this.onTap,
      required this.media,
      this.onTapDeleteMedia,
      required this.isEditableByUser});

  final dynamic Function() onTap;
  final Function()? onTapDeleteMedia;
  final MediaModel media;
  final bool isEditableByUser;

  @override
  State<ListItemMediaSmallComponent> createState() =>
      _ListItemMediaSmallComponentState();
}

class _ListItemMediaSmallComponentState
    extends State<ListItemMediaSmallComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemImageChildComponent(
        endActionPane: widget.isEditableByUser ? endActionPane : null,
        onTap: widget.onTap,
        url: _getUrl(),
        icon: widget.media.icon,
        child: Text(
          widget.media.title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ));
  }

  String? _getUrl() {
    if (widget.media is ImageMediaModel) {
      return (widget.media as ImageMediaModel).source;
    } else {
      return null;
    }
  }

  ActionPane endActionPane(Function closeSlidable) {
    return ActionPane(
      extentRatio: 0.22,
      motion: const ScrollMotion(),
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              await closeSlidable();
              widget.onTapDeleteMedia?.call();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(
                      ListItemContainerComponent.standardBorderRadius))),
              child: Center(
                  child: Icon(
                IconEnum.delete.icon,
                color: Theme.of(context).colorScheme.red,
              )),
            ),
          ),
        ),
        const SpaceComponent(
          width: 20,
        )
      ],
    );
  }
}
