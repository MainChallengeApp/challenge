// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flut/models/challenge.dart';
import 'package:flutter/material.dart';

class MyListItemMax extends StatefulWidget {
  MyListItemMax({super.key, this.icon, this.title = "Title", required this.challenge});
  
  final IconData? icon;
  final String title;

  Challenge challenge;

  @override
  State<MyListItemMax> createState() => _MyListItemMaxState();
}

class _MyListItemMaxState extends State<MyListItemMax> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 345,
        height: 120+8*64+2,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color.fromRGBO(226, 232, 240, 1)),
            borderRadius: BorderRadius.all(Radius.circular(16))),
        // margin: EdgeInsets.only(bottom:16),
        child: Row(
          children: [
            Center(child: Text(widget.challenge.title)),
          ],
        ),
      ),
    );
  }
}
