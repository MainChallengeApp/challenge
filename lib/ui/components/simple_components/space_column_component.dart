import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

class SpaceColumnComponent extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? heightMultiplier;
  final bool? isSpaceOnTop;

  const SpaceColumnComponent(
      {super.key,
      required this.child,
      this.height,
      this.heightMultiplier,
      this.isSpaceOnTop});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (isSpaceOnTop == true)
        SpaceComponent(
          height: height,
          heightMultiplier: heightMultiplier,
        ),
      child,
      SpaceComponent(
        height: height,
        heightMultiplier: heightMultiplier,
      )
    ]);
  }
}
