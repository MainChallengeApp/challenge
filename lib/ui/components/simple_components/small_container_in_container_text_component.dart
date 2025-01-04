import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/small_container_in_list_item_component.dart';
import 'package:flutter/material.dart';

class SmallContainerInContainerTextComponent extends StatelessWidget {
  final String text;
  final EdgeInsets? margin;

  const SmallContainerInContainerTextComponent(
      {super.key, required this.text, this.margin});

  @override
  Widget build(BuildContext context) {
    return ContainerInContainerComponent(
        margin: margin ??
            const EdgeInsets.only(
                left: CustomContainerComponent.standardPadding),
        padding: const EdgeInsets.symmetric(
            horizontal: ContainerInContainerComponent.standardPaddingSmall),
        height: SmallContainerInListItemComponent.height,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Theme.of(context).colorScheme.tertiary)),
          ],
        ));
  }
}
