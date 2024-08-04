import 'package:challenge/components/list_items/list_item_icon_small_component.dart';
import 'package:challenge/components/simple_components/container_in_container_component.dart';
import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class IconContainerInListItemComponent extends StatelessWidget {
  final IconData icon;
  final double? size;

  const IconContainerInListItemComponent(
      {super.key, required this.icon, this.size});

  @override
  Widget build(BuildContext context) {
    return ContainerInContainerComponent(
        height: ListItemIconSmallComponent.iconContainerSize,
        width: ListItemIconSmallComponent.iconContainerSize,
        borderRadius: const BorderRadius.all(
            Radius.circular(ListItemIconSmallComponent.standardIconRadius)),
        padding: EdgeInsets.zero,
        child: Center(
          child: Icon(
            icon,
            size: size,
            color: themeColor3,
          ),
        ));
  }
}
