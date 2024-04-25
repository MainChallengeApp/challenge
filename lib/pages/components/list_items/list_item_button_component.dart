// ignore_for_file: must_be_immutable
import 'package:challenge/pages/components/list_items/list_item_container_component.dart';
import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class ListItemButtonComponent extends StatelessWidget {
  const ListItemButtonComponent(
      {super.key,
      required this.onTap,
      this.isMainButton = true,
      required this.text,
      this.margin,
      this.padding});

  final VoidCallback onTap;
  final bool isMainButton;
  final String text;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListItemContainerComponent(
      backgroundColor: isMainButton ? themeColor2 : Colors.white,
      onTap: onTap,
      margin: margin,
      padding: padding,
      child: Center(
          child: Text(
        text,
        style: TextStyle(color: isMainButton ? Colors.white : Colors.black),
      )),
    );
  }
}
