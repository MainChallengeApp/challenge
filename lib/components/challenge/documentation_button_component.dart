import 'package:challenge/components/simple_components/tap_container_component.dart';
import 'package:flutter/material.dart';

class DocumentationButtonComponent extends StatelessWidget {
  final void Function() onTap;
  final IconData iconData;
  final bool isGrayedOut;

  const DocumentationButtonComponent(
      {super.key,
      required this.onTap,
      required this.iconData,
      this.isGrayedOut = false});

  @override
  Widget build(BuildContext context) {
    return TapContainerComponent(
      onTap: onTap,
      isQuadratic: true,
      margin: const EdgeInsets.only(left: 8, right: 8),
      backgroundColor: isGrayedOut ? Colors.grey[200]! : Colors.white,
      child: Center(
          child: Icon(
        iconData,
        color: isGrayedOut ? Colors.grey[600] : Colors.black,
      )),
    );
  }
}
