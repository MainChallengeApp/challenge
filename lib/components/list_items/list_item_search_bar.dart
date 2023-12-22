// ignore_for_file: must_be_immutable

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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 20, right: 20),
        height: 64,
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
            borderRadius: const BorderRadius.all(Radius.circular(24))),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(241, 245, 249, 1),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              margin: const EdgeInsets.all(12),
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
                        onChanged: widget.changeList ?? (value) {},
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Search',
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        textEditingController.clear();
                        widget.changeList?.call('');
                      },
                      child: Icon(
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
      ),
    );
  }
}
