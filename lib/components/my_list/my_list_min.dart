// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable


import 'package:flut/components/my_list/my_list_item_min.dart';
import 'package:flut/globals.dart';
import 'package:flut/models/challenge.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class MyListMin extends StatefulWidget {
  MyListMin({super.key, required this.listTitle, required this.challenges});


  final String listTitle;
  List<Challenge> challenges;


  @override
  State<MyListMin> createState() => _MyListMinState();
}

class _MyListMinState extends State<MyListMin> {

  @override
  Widget build(BuildContext context) {
    return ScrollSnapList(
          clipBehavior: Clip.hardEdge,
          selectedItemAnchor: SelectedItemAnchor.START,
          onItemFocus: (p0) {},
          scrollDirection: Axis.vertical,
          itemSize: 64 + 16,
          itemCount: widget.challenges.length,
          endOfListTolerance: 0,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Center(child: MyListItemMin(title: widget.challenges[index].title, listTitle: widget.listTitle,)),
                SizedBox(
                  height: 16,
                )
              ],
            );
          });
  }
}
