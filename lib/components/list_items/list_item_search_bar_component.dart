// ignore_for_file: must_be_immutable

import 'package:challenge/components/list_items/list_item_container_component.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';

class ListItemSearchbarComponent extends StatefulWidget {
  ListItemSearchbarComponent(
      {super.key,
      this.changeList,
      this.searchBarText = "",
      required this.textEditingController,
      this.isEnabled = true,
      this.autoFocus = false});

  Function(String)? changeList;
  String searchBarText;
  TextEditingController textEditingController;
  final bool isEnabled;
  final bool autoFocus;

  @override
  State<ListItemSearchbarComponent> createState() =>
      _ListItemSearchbarComponentState();
}

class _ListItemSearchbarComponentState
    extends State<ListItemSearchbarComponent> {
  @override
  Widget build(BuildContext context) {
    widget.textEditingController.selection = TextSelection.collapsed(
        offset: widget.textEditingController.text.length);
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
              Icons.search_rounded,
              color: themeColor3,
            )),
          ),
          SizedBox(
            width: 270,
            height: 40,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        autofocus: widget.autoFocus,
                        controller: widget.textEditingController,
                        enabled: widget.isEnabled,
                        onChanged: (value) {
                          setState(() {
                            widget.searchBarText = value;
                            widget.changeList?.call(value);
                          });
                        },
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: themeColor3,
                          ),
                        )),
                  ),
                  widget.textEditingController.text == ''
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            widget.textEditingController.clear();
                            widget.changeList?.call('');
                            widget.searchBarText = '';
                          },
                          child: const Icon(
                            Icons.highlight_remove_rounded,
                            color: themeColor3,
                          ),
                        )
                ],
              ),
            ),
          )
          // Text(title)
        ],
      ),
    );
  }
}
