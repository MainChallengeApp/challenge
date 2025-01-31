import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';

class SmallContainerInListItemComponent extends StatelessWidget {
  static double height = CustomContainerComponent.standardHeight * 0.55 - 1;

  final Widget child;
  final EdgeInsets? margin;

  const SmallContainerInListItemComponent(
      {super.key, required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return ContainerInContainerComponent(
        height: height,
        borderRadius: const BorderRadius.all(
            Radius.circular(ListItemIconTextComponent.standardIconRadius)),
        padding: EdgeInsets.zero,
        margin: margin ?? EdgeInsets.zero,
        child: Center(child: child));
  }
}
