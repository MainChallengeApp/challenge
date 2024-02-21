import 'package:flutter/material.dart';

class SpaceComponent extends StatelessWidget {
  final double height;
  final double width;
  static const double staticHeight = 16;
  static const double staticWidth = 16;

  const SpaceComponent(
      {super.key, this.height = staticHeight, this.width = staticWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
