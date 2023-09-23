// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flut/globals.dart';
import 'package:flut/providers/my_list_provider.dart';
import 'package:flut/providers/my_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyListItemMin extends StatefulWidget {


  MyListItemMin({super.key, this.icon, required this.title, required this.listTitle});

  final IconData? icon;
  final String title;
  

  final String listTitle;

  @override
  State<MyListItemMin> createState() => _MyListItemMinState();
}

class _MyListItemMinState extends State<MyListItemMin> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            context.read<MyListProvider>().changeListView(widget.listTitle);
            context.read<MyPathProvider>().addPath(widget.listTitle, widget.title);
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const MyListMax()));
          });
        },
        child: Container(
          width: 345,
          height: 64,
          decoration: BoxDecoration(
              border:
                  Border.all(width: 1, color: Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: BorderRadius.all(Radius.circular(16))),
          // margin: EdgeInsets.only(bottom:16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(241, 245, 249, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                margin: EdgeInsets.all(12),
                child: Center(
                    child: Icon(
                  widget.icon ?? widget.icon,
                  color: Color.fromRGBO(100, 116, 139, 1),
                )),
              ),
              Text(widget.title)
            ],
          ),
        ),
      ),
    );
  }
}
