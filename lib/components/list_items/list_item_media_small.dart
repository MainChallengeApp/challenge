import 'package:challenge/components/list_items/list_item_container.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/media.dart';

class ListItemMediaSmall extends StatelessWidget {
  const ListItemMediaSmall(
      {super.key, required this.onTap, required this.media});

  final dynamic Function() onTap;

  final Media media;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListItemContainer(
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(241, 245, 249, 1),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 12),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Image.asset(media.source,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child:
                                Icon(Icons.question_mark, color: themeColor3),
                          ))),
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
