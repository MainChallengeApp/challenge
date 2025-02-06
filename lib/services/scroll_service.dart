import 'package:flutter/material.dart';

class ScrollService {
  static fixOverScroll(
      PageController pageController, int Function() getListLength) {
    pageController.addListener(() {
      if (getListLength() == 1 &&
          (pageController.offset > 300 || pageController.offset < -300)) {
        pageController.animateTo(0,
            duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
      }
    });
  }
}
