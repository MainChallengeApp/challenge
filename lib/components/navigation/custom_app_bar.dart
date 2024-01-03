import 'package:flutter/material.dart';

import 'package:challenge/globals.dart';

class CustomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String preTitle;
  final String? titleText;
  final Color textColor;
  final Color backgroundColor;
  final bool isFirstPage;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const CustomeAppBar(
      {super.key,
      required this.preTitle,
      this.titleText,
      this.textColor = Colors.black,
      this.backgroundColor = Colors.white,
      this.isFirstPage = false});

  @override
  Widget build(BuildContext context) {
    String titletext = titleText == null ? preTitle : '$preTitle/$titleText';

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
