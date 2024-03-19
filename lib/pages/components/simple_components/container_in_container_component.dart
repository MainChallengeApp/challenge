import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class ContainerInContainerComponent extends StatelessWidget {
  final Widget child;

  const ContainerInContainerComponent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: themeColor4,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: child,
    );
  }
}
