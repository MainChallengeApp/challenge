import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListItemContainerComponent extends StatefulWidget {
  static const double standardPadding = 12;
  static const double standardBorderRadius = 24;
  static const double standardHeight = 64;

  final Widget child;
  final Color? backgroundColor;
  final Function? onTap;
  final Function(DragUpdateDetails)? onHorizontalDragUpdate;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final ActionPane? Function(Function)? endActionPane;
  final double? height;
  final double? borderRadius;

  const ListItemContainerComponent(
      {super.key,
      required this.child,
      this.backgroundColor = Colors.white,
      this.onTap,
      this.padding,
      this.endActionPane,
      this.height,
      this.margin,
      this.borderRadius,
      this.onHorizontalDragUpdate});

  @override
  State<ListItemContainerComponent> createState() =>
      _ListItemContainerComponentState();
}

class _ListItemContainerComponentState
    extends State<ListItemContainerComponent> {
  late BuildContext context2;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: widget.endActionPane?.call(closeSlidable),
      child: Builder(builder: (context) {
        context2 = context;
        return GestureDetector(
          onTap: () {
            widget.onTap?.call();
          },
          onHorizontalDragUpdate: widget.onHorizontalDragUpdate,
          child: Container(
            width: double.infinity,
            height: widget.height ?? ListItemContainerComponent.standardHeight,
            margin: widget.margin ?? const EdgeInsets.only(left: 20, right: 20),
            padding: widget.padding ??
                const EdgeInsets.all(
                    ListItemContainerComponent.standardPadding),
            decoration: BoxDecoration(
                color: widget.backgroundColor,
                border: Border.all(width: 1, color: themeColor5),
                borderRadius: BorderRadius.all(Radius.circular(
                    widget.borderRadius ??
                        ListItemContainerComponent.standardBorderRadius))),
            child: widget.child,
          ),
        );
      }),
    );
  }

  closeSlidable() {
    Slidable.of(context2)?.close();
  }
}
