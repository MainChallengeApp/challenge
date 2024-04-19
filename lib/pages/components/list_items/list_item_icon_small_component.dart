import 'package:challenge/pages/components/list_items/list_item_container_component.dart';
import 'package:challenge/pages/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:flutter/material.dart';

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
          IconContainerInListItemComponent(
            icon: icon,
          ),
          Text(title)
        ],
      ),
    );
  }
}
