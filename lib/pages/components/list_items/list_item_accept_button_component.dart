// ignore_for_file: must_be_immutable

import 'package:challenge/pages/components/list_items/list_item_container_component.dart';
import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class ListItemButtonComponent extends StatelessWidget {
  const ListItemButtonComponent(
      {super.key,
      required this.onTapAccept,
      this.isMainButton = true,
      required this.text});

  final VoidCallback onTapAccept;
  final bool isMainButton;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapAccept,
      child: ListItemContainerComponent(
        backgroundColor: isMainButton ? themeColor2 : Colors.white,
        child: Center(
            child: Text(
          text,
          style: TextStyle(color: isMainButton ? Colors.white : Colors.black),
        )),
      ),
    );
  }
}
