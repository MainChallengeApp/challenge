import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_list_item_component.dart';
import 'package:flutter/material.dart';

class IconContainerInListItemComponent extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? iconColor;
  final EdgeInsets? margin;

  const IconContainerInListItemComponent(
      {super.key, required this.icon, this.size, this.iconColor, this.margin});

  @override
  Widget build(BuildContext context) {
    return ContainerInListItemComponent(
        margin: margin ??
            const EdgeInsets.only(
                right: ContainerInContainerComponent.standardMargin),
        child: Center(
          child: Icon(
            icon,
            size: size,
            color: iconColor ?? Theme.of(context).colorScheme.tertiary,
          ),
        ));
  }
}
