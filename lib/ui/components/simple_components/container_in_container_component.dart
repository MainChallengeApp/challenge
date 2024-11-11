import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class ContainerInContainerComponent extends StatelessWidget {
  static const double standardRadius = 10;
  static const double standardPadding = 10;
  static const double standardMargin = 10;

  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final Border? border;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? height;
  final double? width;

  const ContainerInContainerComponent(
      {super.key,
      required this.child,
      this.color,
      this.margin,
      this.border,
      this.padding,
      this.borderRadius,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(standardPadding),
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.themeColor4,
          border: border,
          borderRadius: borderRadius ??
              const BorderRadius.all(Radius.circular(standardRadius))),
      child: child,
    );
  }
}
