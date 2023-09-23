// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flut/components/my_tab_bar/my_tab_bar_button.dart';
import 'package:flutter/material.dart';

class MyTabBar extends StatefulWidget {
  MyTabBar({super.key, required this.updateMain});
  final VoidCallback updateMain;
  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, bottom: 10, right: 10, top: 2),
      width: 345,
      height: 72,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: Color.fromRGBO(15, 23, 42, 1)),
      child: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          MyTabBarButton(icon: Icons.search, page: "Search", updateTabBar: updateTabBar),
          Container(
            width: 40,
          ),
          MyTabBarButton(icon: Icons.person, page: "Home", updateTabBar: updateTabBar),
          Container(
            width: 40,
          ),
          MyTabBarButton(icon: Icons.settings, page: "Settings", updateTabBar: updateTabBar),
        ]),
      ),
    );
  }

  void updateTabBar(){
    setState(() {
      widget.updateMain();
    });
  }
}
