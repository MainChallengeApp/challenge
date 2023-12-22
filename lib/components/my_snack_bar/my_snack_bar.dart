import 'package:flutter/material.dart';

class MySnackBar {
  static showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 2000),
    ));
  }
}
