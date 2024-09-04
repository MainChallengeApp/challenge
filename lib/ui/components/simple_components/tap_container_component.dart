import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
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
  final Function()? onLongPress;
  final Function()? onLongPressUp;
  final Function()? onLongPressCancel;
  final Color? onTapColor;
  final double? borderWidth;
  final Color? borderColor;
  final bool isHeightDynamic;

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
      this.borderWidth,
      this.onTapColor,
      this.onLongPress,
      this.onLongPressUp,
      this.onLongPressCancel,
      this.borderColor,
      this.isHeightDynamic = false});

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
      onLongPress: widget.onLongPress,
      onLongPressUp: widget.onLongPressUp,
      onLongPressCancel: widget.onLongPressCancel,
      child: Stack(
        children: [
          CustomContainerComponent(
            isHeightDynamic: widget.isHeightDynamic,
            heightFactor: widget.heightFactor,
            height: widget.height,
            padding: widget.padding,
            margin: widget.margin,
            borderRadius: widget.borderRadius,
            backgroundColor: widget.backgroundColor,
            borderWidth: widget.borderWidth,
            borderColor: widget.borderColor,
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
              borderWidth: widget.borderWidth,
              borderColor: widget.borderColor,
              isQuadratic: widget.isQuadratic,
            ),
          ),
        ],
      ),
    );
  }
}
