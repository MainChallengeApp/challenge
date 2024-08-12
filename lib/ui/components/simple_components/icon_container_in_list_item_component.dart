import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
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
        height: ListItemIconTextComponent.iconContainerSize,
        width: ListItemIconTextComponent.iconContainerSize,
        borderRadius: const BorderRadius.all(
            Radius.circular(ListItemIconTextComponent.standardIconRadius)),
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
