import 'package:challenge/globals.dart';
import 'package:challenge/pages/components/list_items/list_item_container_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListItemFractionComponent extends StatefulWidget {
  const ListItemFractionComponent(
      {super.key,
      this.isFailed = false,
      required this.initialProgress,
      this.child,
      this.onTap,
      this.margin,
      this.endActionPane,
      this.onHorizontalDragUpdate});

  final Widget? child;
  final double initialProgress;
  final bool isFailed;
  final void Function()? onTap;
  final void Function(DragUpdateDetails)? onHorizontalDragUpdate;
  final EdgeInsetsGeometry? margin;
  final ActionPane? Function(Function)? endActionPane;

  @override
  State<ListItemFractionComponent> createState() =>
      _ListItemFractionComponentState();
}

class _ListItemFractionComponentState extends State<ListItemFractionComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemContainerComponent(
      onTap: widget.onTap,
      onHorizontalDragUpdate: widget.onHorizontalDragUpdate,
      padding: const EdgeInsets.all(0),
      margin: widget.margin,
      endActionPane: widget.endActionPane,
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: widget.initialProgress,
            heightFactor: 1,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: widget.isFailed ? red : green,
                  borderRadius: const BorderRadius.all(Radius.circular(
                      ListItemContainerComponent.standardBorderRadius))),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white,
                    width: 10,
                    strokeAlign: BorderSide.strokeAlignOutside),
                borderRadius: const BorderRadius.all(Radius.circular(
                    ListItemContainerComponent.standardBorderRadius))),
          ),
          Container(
              padding: const EdgeInsets.all(
                  ListItemContainerComponent.standardPadding),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: const Color.fromRGBO(226, 232, 240, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(
                      ListItemContainerComponent.standardBorderRadius))),
              child: widget.child)
        ],
      ),
    );
  }
}
