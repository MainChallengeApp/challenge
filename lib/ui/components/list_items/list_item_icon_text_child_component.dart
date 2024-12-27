import 'package:challenge/ui/components/list_items/list_item_icon_child_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

class ListItemIconTextChildComponent extends StatelessWidget {
  const ListItemIconTextChildComponent(
      {super.key,
      this.onTap,
      required this.icon,
      required this.child,
      required this.text,
      this.iconColor,
      this.margin,
      this.padding});

  final void Function()? onTap;

  final IconData icon;
  final Color? iconColor;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListItemIconChildComponent(
        icon: icon,
        onTap: onTap,
        margin: margin,
        padding: padding,
        iconColor: iconColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SpaceComponent(
              width: 10,
            ),
            child,
          ],
        ));
  }
}
