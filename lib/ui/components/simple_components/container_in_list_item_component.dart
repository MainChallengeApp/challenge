import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:flutter/material.dart';

class ContainerInListItemComponent extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;

  const ContainerInListItemComponent(
      {super.key, required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return ContainerInContainerComponent(
        height: ListItemIconTextComponent.iconContainerSize,
        width: ListItemIconTextComponent.iconContainerSize,
        borderRadius: const BorderRadius.all(
            Radius.circular(ListItemIconTextComponent.standardIconRadius)),
        padding: EdgeInsets.zero,
        margin: margin,
        child: child);
  }
}
