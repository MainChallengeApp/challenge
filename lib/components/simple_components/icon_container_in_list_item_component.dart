import 'package:challenge/globals.dart';
import 'package:challenge/components/simple_components/container_in_container_component.dart';
import 'package:flutter/material.dart';

class IconContainerInListItemComponent extends StatelessWidget {
  static const double iconContainerSize = 40;

  final IconData icon;
  final double? size;

  const IconContainerInListItemComponent(
      {super.key, required this.icon, this.size});

  @override
  Widget build(BuildContext context) {
    return ContainerInContainerComponent(
        height: iconContainerSize,
        width: iconContainerSize,
        padding: EdgeInsets.zero,
        child: Center(
          child: Icon(
            icon,
            size: size,
            color: themeColor3,
          ),
        ));
  }
}
