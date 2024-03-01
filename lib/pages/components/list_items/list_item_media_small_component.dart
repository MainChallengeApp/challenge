import 'package:challenge/pages/components/list_items/list_item_container_component.dart';
import 'package:challenge/pages/components/media/video_thumbnail_component.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/media_model.dart';

class ListItemMediaSmallComponent extends StatelessWidget {
  const ListItemMediaSmallComponent(
      {super.key, required this.onTap, required this.media});

  final dynamic Function() onTap;

  final MediaModel media;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListItemContainerComponent(
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: themeColor4,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 12),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: media.type == 'image'
                      ? Image.asset(media.source,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                child: Icon(Icons.question_mark,
                                    color: themeColor3),
                              ))
                      : media.type == 'video'
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
      ),
    );
  }
}
