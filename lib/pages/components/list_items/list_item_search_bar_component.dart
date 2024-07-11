// ignore_for_file: must_be_immutable

import 'package:challenge/pages/components/list_items/list_item_container_component.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';

class ListItemSearchbarComponent extends StatefulWidget {
  final String hintText;
  Function(String)? changeList;
  String searchBarText;
  TextEditingController textEditingController;
  final bool isEnabled;
  final bool autoFocus;
  final Function? onTap;
  ListItemSearchbarComponent(
      {super.key,
      this.changeList,
      this.searchBarText = "",
      required this.textEditingController,
      this.isEnabled = true,
      this.autoFocus = false,
      this.hintText = 'Search',
      this.onTap});

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
      onTap: widget.onTap,
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
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    fontSize: basicFontSize,
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
          // Text(title)
        ],
      ),
    );
  }
}
