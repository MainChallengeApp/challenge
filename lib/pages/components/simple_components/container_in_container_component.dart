import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class ContainerInContainerComponent extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  const ContainerInContainerComponent(
      {super.key, required this.child, this.color, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: color ?? themeColor4,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: child,
    );
  }
}
