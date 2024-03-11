import 'package:challenge/pages/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

class SpaceColumnComponent extends StatelessWidget {
  final Widget child;
  const SpaceColumnComponent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(children: [child, const SpaceComponent()]);
  }
}
