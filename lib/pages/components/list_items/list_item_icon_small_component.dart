import 'package:challenge/pages/components/list_items/list_item_container_component.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';

class ListItemIconSmallComponent extends StatelessWidget {
  static const double iconContainerSize = 40;

  const ListItemIconSmallComponent(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.title});

  final void Function() onTap;

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListItemContainerComponent(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: iconContainerSize,
            height: iconContainerSize,
            decoration: const BoxDecoration(
                color: themeColor4,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            margin: const EdgeInsets.only(right: 12),
            child: Center(
                child: Icon(
              icon,
              color: themeColor3,
            )),
          ),
          Text(title)
        ],
      ),
    );
  }
}
