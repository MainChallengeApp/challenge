import 'package:challenge/globals.dart';
import 'package:challenge/pages/components/list_items/list_item_container_component.dart';
import 'package:flutter/material.dart';

class ListItemFractionComponent extends StatefulWidget {
  const ListItemFractionComponent(
      {super.key,
      this.isFailed = false,
      required this.initialProgress,
      this.child,
      this.onTap});

  final Widget? child;
  final double initialProgress;
  final bool isFailed;
  final void Function()? onTap;

  @override
  State<ListItemFractionComponent> createState() =>
      _ListItemFractionComponentState();
}

class _ListItemFractionComponentState extends State<ListItemFractionComponent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListItemContainerComponent(
        onTap: widget.onTap,
        padding: const EdgeInsets.all(0),
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
                    borderRadius: const BorderRadius.all(Radius.circular(23))),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white,
                      width: 10,
                      strokeAlign: BorderSide.strokeAlignOutside),
                  borderRadius: const BorderRadius.all(Radius.circular(23))),
            ),
            Container(
                padding: const EdgeInsets.all(10),
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: const Color.fromRGBO(226, 232, 240, 1)),
                    borderRadius: const BorderRadius.all(Radius.circular(
                        23))), // Somehow Radius.circular(24) is off??
                child: widget.child)
          ],
        ),
      ),
    );
  }
}
