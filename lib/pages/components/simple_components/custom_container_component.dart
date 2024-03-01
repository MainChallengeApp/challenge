import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class CustomContainerComponent extends StatelessWidget {
  final double heightFactor;
  final Color backgroundColor;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final bool isQuadratic;

  const CustomContainerComponent(
      {super.key,
      required this.child,
      this.heightFactor = 1,
      this.backgroundColor = Colors.white,
      this.margin,
      this.isQuadratic = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isQuadratic ? 55 : double.infinity,
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
