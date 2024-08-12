import 'package:challenge/ui/components/list_items/list_item_icon_child_component.dart';
import 'package:flutter/material.dart';

class ListItemIconTextComponent extends StatelessWidget {
  static const double iconContainerSize = 40;
  static const double standardIconRadius = 12;

  const ListItemIconTextComponent(
      {super.key, this.onTap, required this.icon, required this.title});

  final void Function()? onTap;

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListItemIconChildComponent(
        onTap: onTap,
        icon: icon,
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
        ));
  }
}
