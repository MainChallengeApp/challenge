// ignore_for_file: must_be_immutable

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
                Icons.email,
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
                      hintText: 'Email', errorText: widget.errorText),
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
