// ignore_for_file: must_be_immutable

import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class CategoryComponent extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final String imagePath;
  void Function()? onTap;

  CategoryComponent(
      {super.key,
      required this.text,
      this.backgroundColor = Colors.white,
      required this.imagePath,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // width: double.infinity,
        height: 96,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(width: 1, color: themeColor5),
            borderRadius: const BorderRadius.all(Radius.circular(24))),
        child: Stack(children: [
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: const BoxDecoration(
                    color: themeColor4,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                width: 70,
                height: 70,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Transform.scale(
                    scale: 0.8,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )),
          Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12))),
                child: Text(
                  text,
                  style: const TextStyle(
                      color: themeColor1,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
              )),
        ]),
      ),
    );
  }
}
