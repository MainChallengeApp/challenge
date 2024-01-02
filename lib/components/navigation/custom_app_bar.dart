import 'package:flutter/material.dart';

import '../../globals.dart';

class CustomeAppBar extends AppBar {
  CustomeAppBar({super.key});

  // final String preTitle;
  // final String title;

  static AppBar build(
      {required preTitle,
      title,
      backgroundColor = Colors.white,
      textColor = Colors.black,
      isFirstPage = false}) {
    String titletext = title == null ? preTitle : '$preTitle/$title';

    ScrollController scrollController = ScrollController();

    Future.delayed(Duration.zero, () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });

    return AppBar(
      elevation: 0,
      leading: isFirstPage
          ? const Icon(
              Icons.chevron_left,
              color: Colors.transparent,
            )
          : null,
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(right: 24),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: scrollController,
            child: Text(
              titletext,
              textAlign: TextAlign.right,
              style: TextStyle(color: textColor, fontSize: appBarFontSize),
            ),
          ),
        ),
      ),
    );
  }
}
