// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flut/globals.dart';
import 'package:flutter/material.dart';

class MyTabBarButton extends StatefulWidget {
  MyTabBarButton({super.key, required this.icon, required this.page, required this.updateTabBar});
  final IconData icon;
  final String page;
  final VoidCallback updateTabBar;
  @override
  State<MyTabBarButton> createState() => _MyTabBarButtonState();
}

class _MyTabBarButtonState extends State<MyTabBarButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapButton,
      child: Container(
          width: 53,
          height: 53,
          decoration: BoxDecoration(
              color:
                  Color.fromRGBO(51, 65, 85, selectedPage == widget.page ? 1 : 0),
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Center(
              child: Icon(
            widget.icon,
            color: Colors.white,
          ))),
    );
  }

  void onTapButton() {
    selectedPage = widget.page;
    // path = [selectedPage];
    widget.updateTabBar();
  }
}
