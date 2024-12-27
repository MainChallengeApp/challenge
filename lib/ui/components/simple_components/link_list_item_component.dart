import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class LinkListItemComponent extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? heightMultiplier;
  const LinkListItemComponent(
      {super.key, required this.child, this.height, this.heightMultiplier});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        height:
            (heightMultiplier ?? 1) * (height ?? SpaceComponent.standardHeight),
        width: 3,
        color: Theme.of(context).colorScheme.themeColor5,
      ),
      child,
    ]);
  }
}
