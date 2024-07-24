import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class CustomContainerComponent extends StatelessWidget {
  static const double standardHeight = 55;
  static const double standardPadding = 10;

  final double heightFactor;
  final Color backgroundColor;
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final bool isQuadratic;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? borderRadius;
  final double? borderWith;

  const CustomContainerComponent(
      {super.key,
      this.child,
      this.heightFactor = 1,
      this.backgroundColor = Colors.white,
      this.margin,
      this.isQuadratic = false,
      this.padding = const EdgeInsets.all(standardPadding),
      this.height,
      this.borderRadius,
      this.borderWith});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isQuadratic ? standardHeight : double.infinity,
      height: height ?? standardHeight * heightFactor,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(width: borderWith ?? 1, color: themeColor5),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 16))),
      child: child,
    );
  }
}
