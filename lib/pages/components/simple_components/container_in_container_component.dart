import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class ContainerInContainerComponent extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final Border? border;
  final EdgeInsets? padding;

  const ContainerInContainerComponent(
      {super.key,
      required this.child,
      this.color,
      this.margin,
      this.border,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(right: 10),
      padding: padding ?? const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: color ?? themeColor4,
          border: border,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: child,
    );
  }
}
