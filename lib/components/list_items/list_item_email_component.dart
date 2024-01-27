// ignore_for_file: must_be_immutable

import 'package:challenge/components/list_items/list_item_container_component.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';

class ListItemEmailComponent extends StatefulWidget {
  ListItemEmailComponent(
      {super.key,
      this.onChangeTextField,
      required this.textEditingController,
      this.errorText});

  Function(String)? onChangeTextField;
  final TextEditingController textEditingController;
  String? errorText;

  @override
  State<ListItemEmailComponent> createState() => _ListItemEmailComponentState();
}

class _ListItemEmailComponentState extends State<ListItemEmailComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemContainerComponent(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                color: themeColor4,
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
                onChanged: widget.onChangeTextField ?? (value) {},
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
