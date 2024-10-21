import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/media_model.dart';
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
      this.onTapDeleteMedia});

  final dynamic Function() onTap;
  final Function()? onTapDeleteMedia;
  final MediaModel media;

  @override
  State<ListItemMediaSmallComponent> createState() =>
      _ListItemMediaSmallComponentState();
}

class _ListItemMediaSmallComponentState
    extends State<ListItemMediaSmallComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemImageChildComponent(
        endActionPane: endActionPane,
        onTap: widget.onTap,
        url: widget.media.source,
        child: Text(
          widget.media.title,
          overflow: TextOverflow.ellipsis,
        ));

    // ListItemContainerComponent(
    //   endActionPane: endActionPane,
    //   onTap: onTap,
    //   child: Row(
    //     children: [
    //       Container(
    //         decoration: const BoxDecoration(
    //             color: Theme.of(context).colorScheme.themeColor4,
    //             borderRadius: BorderRadius.all(Radius.circular(
    //                 ListItemIconTextComponent.standardIconRadius))),
    //         width: 40,
    //         height: 40,
    //         margin: const EdgeInsets.only(right: 12),
    //         child: ClipRRect(
    //             borderRadius: const BorderRadius.all(Radius.circular(
    //                 ListItemIconTextComponent.standardIconRadius)),
    //             child: media.isImage()
    //                 ? media.isLocal()
    //                     ? Image.asset(media.source,
    //                         fit: BoxFit.cover,
    //                         errorBuilder: (context, error, stackTrace) =>
    //                             const Center(
    //                               child: Icon(Icons.question_mark,
    //                                   color: Theme.of(context).colorScheme.tertiary),
    //                             ))
    //                     : Image.network(media.source,
    //                         fit: BoxFit.cover,
    //                         errorBuilder: (context, error, stackTrace) =>
    //                             const Center(
    //                               child: Icon(Icons.question_mark,
    //                                   color: Theme.of(context).colorScheme.tertiary),
    //                             ))
    //                 : null),
    //       ),
    //       Text(
    //         media.title,
    //         overflow: TextOverflow.ellipsis,
    //       )
    //     ],
    //   ),
    // );
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
