import 'package:flutter/material.dart';

class SpaceComponent extends StatelessWidget {
  final double height;

  const SpaceComponent({super.key, this.height = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
    );
  }
}
