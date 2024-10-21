import 'package:challenge/ui/components/list_items/list_item_icon_child_component.dart';
import 'package:flutter/material.dart';

class ListItemIconTextComponent extends StatelessWidget {
  static const double iconContainerSize = 40;
  static const double standardIconRadius = 12;

  const ListItemIconTextComponent(
      {super.key,
      this.onTap,
      required this.icon,
      required this.title,
      this.textColor,
      this.iconColor,
      this.margin});

  final void Function()? onTap;

  final IconData icon;
  final String title;
  final Color? textColor;
  final Color? iconColor;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return ListItemIconChildComponent(
        margin: margin,
        onTap: onTap,
        icon: icon,
        iconColor: iconColor,
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: textColor),
        ));
  }
}
