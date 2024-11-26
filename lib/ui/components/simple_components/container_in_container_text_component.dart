import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:flutter/material.dart';

class ContainerInContainerTextComponent extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final EdgeInsetsGeometry? margin;
  final Border? border;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final double? height;

  const ContainerInContainerTextComponent(
      {super.key,
      required this.text,
      this.color,
      this.textColor,
      this.margin,
      this.border,
      this.padding,
      this.borderRadius,
      this.textStyle,
      this.height});

  @override
  Widget build(BuildContext context) {
    return ContainerInContainerComponent(
        margin: margin,
        padding: padding ??
            const EdgeInsets.symmetric(
                horizontal: ContainerInContainerComponent.standardPadding),
        height: height ?? double.infinity,
        color: color,
        border: border,
        borderRadius: borderRadius,
        child: Center(
          child: Text(text,
              style: textStyle?.copyWith(color: textColor) ??
                  Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: textColor),
              overflow: TextOverflow.ellipsis),
        ));
  }
}
