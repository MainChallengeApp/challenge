import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListItemContainerComponent extends StatefulWidget {
  // edited line
  static const double standardPadding = 12;
  static const double standardBorderRadius = 24;
  static const double standardHeight = 64;
  static const double standardMargin = 20;

  final Widget child;
  final Color? backgroundColor;
  final Function? onTap;
  final Function(DragUpdateDetails)? onHorizontalDragUpdate;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final ActionPane? Function(Function)? endActionPane;
  final double? height;
  final double? borderRadius;
  final Color? onTapColor;
  final bool isHeightDynamic;

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
      this.onHorizontalDragUpdate,
      this.onTapColor,
      this.isHeightDynamic = false});

  @override
  State<ListItemContainerComponent> createState() =>
      _ListItemContainerComponentState();
}

class _ListItemContainerComponentState
    extends State<ListItemContainerComponent> {
  late BuildContext context2;

  bool isTapVisible = false;

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
          onHorizontalDragUpdate: widget.onHorizontalDragUpdate,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: widget.isHeightDynamic
                    ? null
                    : widget.height ??
                        ListItemContainerComponent.standardHeight,
                margin: widget.margin ??
                    const EdgeInsets.only(
                        left: ListItemContainerComponent.standardMargin,
                        right: ListItemContainerComponent.standardMargin),
                padding: widget.padding ??
                    const EdgeInsets.all(
                        ListItemContainerComponent.standardPadding),
                decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.themeColor5),
                    borderRadius: BorderRadius.all(Radius.circular(
                        widget.borderRadius ??
                            ListItemContainerComponent.standardBorderRadius))),
                child: widget.child,
              ),
              Visibility(
                visible: widget.onTap != null && isTapVisible,
                child: Container(
                  width: double.infinity,
                  height: widget.isHeightDynamic
                      ? null
                      : widget.height ??
                          ListItemContainerComponent.standardHeight,
                  margin: widget.margin ??
                      const EdgeInsets.only(left: 20, right: 20),
                  padding: widget.padding ??
                      const EdgeInsets.all(
                          ListItemContainerComponent.standardPadding),
                  decoration: BoxDecoration(
                      color: widget.onTapColor ??
                          Theme.of(context).colorScheme.primary.withAlpha(15),
                      border: Border.all(
                          width: 1,
                          color: Theme.of(context).colorScheme.themeColor5),
                      borderRadius: BorderRadius.all(Radius.circular(widget
                              .borderRadius ??
                          ListItemContainerComponent.standardBorderRadius))),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  closeSlidable() async {
    await Slidable.of(context2)?.close();
  }
}
