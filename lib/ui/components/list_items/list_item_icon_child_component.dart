import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:flutter/material.dart';

class ListItemIconChildComponent extends StatelessWidget {
  final void Function()? onTap;
  final IconData icon;
  final Color? iconColor;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool? isEnabled;

  const ListItemIconChildComponent(
      {super.key,
      this.onTap,
      required this.icon,
      required this.child,
      this.iconColor,
      this.margin,
      this.padding,
      this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return ListItemContainerComponent(
      isEnabled: isEnabled,
      margin: margin,
      padding: padding,
      onTap: onTap,
      child: Row(
        children: [
          IconContainerInListItemComponent(
            icon: icon,
            iconColor: iconColor ?? Theme.of(context).colorScheme.tertiary,
          ),
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}
