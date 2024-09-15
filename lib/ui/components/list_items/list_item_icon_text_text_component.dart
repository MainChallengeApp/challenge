import 'package:challenge/globals.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_child_component.dart';
import 'package:flutter/material.dart';

class ListItemIconTextTextComponent extends StatelessWidget {
  const ListItemIconTextTextComponent(
      {super.key,
      this.onTap,
      required this.icon,
      required this.text,
      this.iconColor,
      this.margin,
      required this.text2});

  final void Function()? onTap;

  final IconData icon;
  final Color? iconColor;
  final EdgeInsetsGeometry? margin;
  final String text;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return ListItemIconTextChildComponent(
        icon: icon,
        text: text,
        onTap: onTap,
        margin: margin,
        child: Text(
          text2,
          style: const TextStyle(
            color: themeColor3,
          ),
          textAlign: TextAlign.end,
          overflow: TextOverflow.ellipsis,
        ));
  }
}
