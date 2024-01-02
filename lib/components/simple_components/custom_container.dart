import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final double heightFactor;
  final Color backgroundColor;
  final Widget child;
  final EdgeInsetsGeometry? margin;

  const CustomContainer(
      {super.key,
      required this.child,
      this.heightFactor = 1,
      this.backgroundColor = Colors.white,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      height: 55 * heightFactor,
      padding: const EdgeInsets.all(10),
      margin: margin,
      decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(width: 1, color: themeColor5),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: child,
    );
  }
}
