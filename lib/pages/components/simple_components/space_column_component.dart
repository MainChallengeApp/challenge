import 'package:challenge/pages/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

class SpaceColumnComponent extends StatelessWidget {
  final Widget child;
  final double? height;
  const SpaceColumnComponent({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      child,
      SpaceComponent(
        height: height,
      )
    ]);
  }
}
