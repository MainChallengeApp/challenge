import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/small_container_in_list_item_component.dart';
import 'package:flutter/material.dart';

class SmallContainerInContainerComponent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;

  const SmallContainerInContainerComponent(
      {super.key, required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return ContainerInContainerComponent(
        margin: margin ??
            const EdgeInsets.only(
                left: CustomContainerComponent.standardPadding),
        padding: const EdgeInsets.symmetric(
            horizontal: ContainerInContainerComponent.standardPaddingSmall),
        height: SmallContainerInListItemComponent.height,
        child: child);
  }
}
