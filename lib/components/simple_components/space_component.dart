import 'package:flutter/material.dart';

class SpaceComponent extends StatelessWidget {
  static const double staticHeight = 16;
  static const double staticWidth = 16;

  final double? height;
  final double? width;
  final double? heightMultiplier;
  final double? widthMultiplier;
  const SpaceComponent(
      {super.key,
      this.height,
      this.width,
      this.heightMultiplier,
      this.widthMultiplier});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (heightMultiplier ?? 1) * (height ?? staticHeight),
      width: (widthMultiplier ?? 1) * (width ?? staticWidth),
    );
  }
}
