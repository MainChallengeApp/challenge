import 'package:flutter/material.dart';

class SpaceComponent extends StatelessWidget {
  final double height;
  final double width;

  const SpaceComponent({super.key, this.height = 16, this.width = 16});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
