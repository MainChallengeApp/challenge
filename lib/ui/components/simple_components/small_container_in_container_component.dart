import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/small_container_in_list_item_component.dart';
import 'package:flutter/material.dart';

class SmallContainerInContainerComponent extends StatelessWidget {
  final Widget child;

  const SmallContainerInContainerComponent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ContainerInContainerComponent(
        margin: const EdgeInsets.only(
            left: CustomContainerComponent.standardPadding),
        padding: const EdgeInsets.symmetric(
            horizontal: ContainerInContainerComponent.standardPaddingSmall),
        height: SmallContainerInListItemComponent.height,
        child: child);
  }
}
