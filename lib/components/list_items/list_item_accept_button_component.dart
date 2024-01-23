// ignore_for_file: must_be_immutable

import 'package:challenge/components/list_items/list_item_container_component.dart';
import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class ListItemAcceptButtonComponent extends StatelessWidget {
  ListItemAcceptButtonComponent(
      {super.key, required this.onTapAccept, this.isAcceptable = true});

  VoidCallback onTapAccept;
  bool isAcceptable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapAccept,
      child: ListItemContainerComponent(
        backgroundColor: isAcceptable ? themeColor2 : Colors.white,
        child: Center(
            child: Text(
          'Accept',
          style: TextStyle(color: isAcceptable ? Colors.white : Colors.black),
        )),
      ),
    );
  }
}
