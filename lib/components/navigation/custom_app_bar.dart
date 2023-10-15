import 'package:flutter/material.dart';

import '../../globals.dart';

class CustomeAppBar extends AppBar{
  CustomeAppBar({super.key});

  // final String preTitle;
  // final String title;

  static AppBar build({required preTitle, required title, backgroundColor = Colors.white, textColor = Colors.black}) {
    return AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        titleSpacing: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                '$preTitle/$title',
                style: TextStyle(
                    color: textColor, fontSize: appBarFontSize),
              ),
            ),
          ),
        ),
      );
  }
}