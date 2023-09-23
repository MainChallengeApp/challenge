// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flut/components/my_list/my_list_item_max.dart';
import 'package:flut/globals.dart';
import 'package:flut/models/challenge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

class MyListMax extends StatefulWidget {
  MyListMax({super.key, required this.challenges});

  
  List<Challenge> challenges;

  @override
  State<MyListMax> createState() => _MyListMaxState();
}

class _MyListMaxState extends State<MyListMax> {

  Controller? controll;

  @override
  void initState() {
    super.initState();
    controll = Controller();
    controll?.jumpToPosition(2);
  }


  @override
  Widget build(BuildContext context) {
    // controll?.jumpToPosition(2);

    
    
    return TikTokStyleFullPageScroller(
      contentSize: (120+8*64+2),
      controller: gcontroller,
      builder: (p0, p1) {
        return MyListItemMax(challenge: widget.challenges[p1],);
      }
    );
  }
}