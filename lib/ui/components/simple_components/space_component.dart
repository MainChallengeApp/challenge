import 'package:flutter/material.dart';

class SpaceComponent extends StatelessWidget {
  static const double staticHeight = 16;
  static const double staticWidth = 16;

  final double? height;
  final double? width;
  final double? heightMultiplier;
  final double? widthMultiplier;
  final bool? isVisible;

  const SpaceComponent(
      {super.key,
      this.height,
      this.width,
      this.heightMultiplier,
      this.widthMultiplier,
      this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible ?? true,
      child: SizedBox(
        height: (heightMultiplier ?? 1) * (height ?? staticHeight),
        width: (widthMultiplier ?? 1) * (width ?? staticWidth),
      ),
    );
  }
}
