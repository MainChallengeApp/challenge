// ignore_for_file: must_be_immutable

import 'package:challenge/components/list_items/list_item_container.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';

class ListItemSearchbar extends StatefulWidget {
  ListItemSearchbar({super.key, this.changeList});

  Function(String)? changeList;

  @override
  State<ListItemSearchbar> createState() => _ListItemSearchbarState();
}

class _ListItemSearchbarState extends State<ListItemSearchbar> {
  TextEditingController textEditingController = TextEditingController();
  String searchText = '';
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
                      controller: textEditingController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                          widget.changeList?.call(value);
                        });
                      },
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Search',
                      ),
                    ),
                  ),
                  searchText == ''
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            textEditingController.clear();
                            widget.changeList?.call('');
                            searchText = '';
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
