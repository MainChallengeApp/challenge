import 'package:challenge/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';

class TapContainerComponent extends StatefulWidget {
  static const double standardHeight = 55;
  static const double standardPadding = 10;

  final double heightFactor;
  final Color backgroundColor;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final bool isQuadratic;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? borderRadius;
  final Function()? onTap;
  final Color? onTapColor;
  final double? borderWith;

  const TapContainerComponent(
      {super.key,
      required this.child,
      this.heightFactor = 1,
      this.backgroundColor = Colors.white,
      this.margin,
      this.isQuadratic = false,
      this.padding = const EdgeInsets.all(standardPadding),
      this.height,
      this.borderRadius,
      this.onTap,
      this.borderWith,
      this.onTapColor});

  @override
  State<TapContainerComponent> createState() => _TapContainerComponentState();
}

class _TapContainerComponentState extends State<TapContainerComponent> {
  var isTapVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (details) {
        setState(() {
          isTapVisible = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          isTapVisible = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isTapVisible = false;
        });
      },
      child: Stack(
        children: [
          CustomContainerComponent(
            heightFactor: widget.heightFactor,
            height: widget.height,
            padding: widget.padding,
            margin: widget.margin,
            borderRadius: widget.borderRadius,
            backgroundColor: widget.backgroundColor,
            borderWith: widget.borderWith,
            isQuadratic: widget.isQuadratic,
            child: widget.child,
          ),
          Visibility(
            visible: widget.onTap != null && isTapVisible,
            child: CustomContainerComponent(
              heightFactor: widget.heightFactor,
              height: widget.height,
              padding: widget.padding,
              margin: widget.margin,
              borderRadius: widget.borderRadius,
              backgroundColor: widget.onTapColor ?? Colors.black.withAlpha(10),
              borderWith: widget.borderWith,
              isQuadratic: widget.isQuadratic,
            ),
          ),
        ],
      ),
    );
  }
}
