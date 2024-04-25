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
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final ActionPane? Function(Function)? endActionPane;
  final double? height;

  const ListItemContainerComponent(
      {super.key,
      required this.child,
      this.backgroundColor = Colors.white,
      this.onTap,
      this.padding,
      this.endActionPane,
      this.height,
      this.margin});

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
      endActionPane: widget.endActionPane?.call(closeSlideable),
      child: Builder(builder: (context) {
        context2 = context;
        return GestureDetector(
          onTap: () {
            widget.onTap?.call();
          },
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
                borderRadius: const BorderRadius.all(Radius.circular(
                    ListItemContainerComponent.standardBorderRadius))),
            child: widget.child,
          ),
        );
      }),
    );
  }

  closeSlideable() {
    Slidable.of(context2)?.close();
  }
}
