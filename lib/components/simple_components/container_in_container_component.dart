import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class ContainerInContainerComponent extends StatelessWidget {
  static const double standardPadding = 10;
  static const double standardRadius = 10;

  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final Border? border;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? height;
  final double? width;

  const ContainerInContainerComponent(
      {super.key,
      required this.child,
      this.color,
      this.margin,
      this.border,
      this.padding,
      this.borderRadius,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(right: 10),
      padding: padding ?? const EdgeInsets.all(10),
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color ?? themeColor4,
          border: border,
          borderRadius: borderRadius ??
              const BorderRadius.all(Radius.circular(standardRadius))),
      child: child,
    );
  }
}
