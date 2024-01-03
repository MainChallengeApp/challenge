// ignore_for_file: must_be_immutable

import 'package:challenge/components/list_items/list_item_container.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';

class ListItemEmail extends StatefulWidget {
  ListItemEmail(
      {super.key,
      this.changeList,
      required this.textEditingController,
      this.errorText});

  Function(String)? changeList;
  final TextEditingController textEditingController;
  String? errorText;

  @override
  State<ListItemEmail> createState() => _ListItemEmailState();
}

class _ListItemEmailState extends State<ListItemEmail> {
  var controller;

  @override
  Widget build(BuildContext context) {
    return ListItemContainer(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                color: Color.fromRGBO(241, 245, 249, 1),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            margin: const EdgeInsets.only(right: 12),
            child: const Center(
                child: Icon(
              Icons.person_outline,
              color: themeColor3,
            )),
          ),
          SizedBox(
            width: 270,
            height: 40,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: widget.textEditingController,
                onChanged: widget.changeList ?? (value) {},
                decoration: InputDecoration(
                    hintText: 'Username', errorText: widget.errorText),
              ),
            ),
          )
          // Text(title)
        ],
      ),
    );
  }
}
