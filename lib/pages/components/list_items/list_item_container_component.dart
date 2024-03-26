import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class ListItemContainerComponent extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Function? onTap;
  final EdgeInsetsGeometry? padding;

  const ListItemContainerComponent(
      {super.key,
      required this.child,
      this.backgroundColor = Colors.white,
      this.onTap,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        width: double.infinity,
        height: 64,
        margin: const EdgeInsets.only(left: 20, right: 20),
        padding: padding ?? const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(width: 1, color: themeColor5),
            borderRadius: const BorderRadius.all(Radius.circular(24))),
        child: child,
      ),
    );
  }
}
