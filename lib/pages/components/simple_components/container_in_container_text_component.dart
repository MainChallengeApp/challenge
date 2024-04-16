import 'package:challenge/globals.dart';
import 'package:challenge/pages/components/simple_components/container_in_container_component.dart';
import 'package:flutter/material.dart';

class ContainerInContainerTextComponent extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final EdgeInsetsGeometry? margin;
  final Border? border;
  final EdgeInsets? padding;

  const ContainerInContainerTextComponent(
      {super.key,
      required this.text,
      this.color,
      this.textColor,
      this.margin,
      this.border,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return ContainerInContainerComponent(
        margin: margin,
        padding: padding,
        color: color,
        border: border,
        child: Text(text,
            style: TextStyle(fontSize: 10, color: textColor ?? themeColor3),
            overflow: TextOverflow.ellipsis));
  }
}
