import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/media/video_thumbnail_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListItemMediaSmallComponent extends StatelessWidget {
  const ListItemMediaSmallComponent(
      {super.key,
      required this.onTap,
      required this.media,
      this.onTapDeleteMedia});

  final dynamic Function() onTap;
  final Function()? onTapDeleteMedia;
  final MediaModel media;

  @override
  Widget build(BuildContext context) {
    return ListItemContainerComponent(
      endActionPane: endActionPane,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: themeColor4,
                borderRadius: BorderRadius.all(Radius.circular(
                    ListItemIconTextComponent.standardIconRadius))),
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 12),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(
                    ListItemIconTextComponent.standardIconRadius)),
                child: media.type == MediaTypeEnum.image
                    ? Image.asset(media.source,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child:
                                  Icon(Icons.question_mark, color: themeColor3),
                            ))
                    : media.type == MediaTypeEnum.video
                        ? VideoThumbnailComponent(
                            filePath: media.source,
                          )
                        : null),
          ),
          Text(
            media.title,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          )
        ],
      ),
    );
  }

  ActionPane endActionPane(Function closeSlidable) {
    return ActionPane(
      extentRatio: 0.22,
      motion: const ScrollMotion(),
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              closeSlidable();
              onTapDeleteMedia?.call();
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
                color: red,
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
