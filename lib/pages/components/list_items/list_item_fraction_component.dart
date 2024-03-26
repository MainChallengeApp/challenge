import 'package:challenge/pages/components/list_items/list_item_container_component.dart';
import 'package:flutter/material.dart';

class ListItemFractionComponent extends StatefulWidget {
  const ListItemFractionComponent(
      {super.key,
      this.isFailed = false,
      required this.initialProgress,
      this.child});

  final Widget? child;
  final double initialProgress;
  final bool isFailed;

  @override
  State<ListItemFractionComponent> createState() =>
      _ListItemFractionComponentState();
}

class _ListItemFractionComponentState extends State<ListItemFractionComponent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListItemContainerComponent(
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
                    color: widget.isFailed ? Colors.red : Colors.green,
                    borderRadius: const BorderRadius.all(Radius.circular(24))),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white,
                      width: 10,
                      strokeAlign: BorderSide.strokeAlignOutside),
                  borderRadius: const BorderRadius.all(Radius.circular(24))),
            ),
            Container(
                padding: const EdgeInsets.all(10),
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white.withAlpha(170),
                    border: Border.all(
                        width: 1,
                        color: const Color.fromRGBO(226, 232, 240, 1)),
                    borderRadius: const BorderRadius.all(Radius.circular(24))),
                child: widget.child)
          ],
        ),
      ),
    );
  }
}
