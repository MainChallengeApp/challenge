import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/models/progress_model.dart';
import 'package:challenge/pages/components/list_items/list_item_fraction_component.dart';
import 'package:challenge/pages/components/simple_components/container_in_container_component.dart';
import 'package:challenge/pages/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/pages/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/pages/components/simple_components/space_component.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// import 'dart:math';

class ListItemProgressComponent extends StatefulWidget {
  const ListItemProgressComponent(
      {super.key,
      required this.progress,
      required this.unit,
      required this.challenge,
      this.onTap,
      required this.isFailed,
      this.isSlidable = false,
      this.onTapDeleteProgress,
      this.isEditable = false});

  final ProgressModel progress;
  final String unit;
  final ChallengeModel challenge;
  final void Function()? onTap;
  final bool isFailed;
  final bool isSlidable;
  final void Function()? onTapDeleteProgress;
  final bool isEditable;

  @override
  State<ListItemProgressComponent> createState() =>
      _ListItemProgressComponentState();
}

class _ListItemProgressComponentState extends State<ListItemProgressComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemFractionComponent(
      endActionPane: widget.isSlidable ? endActionPane : null,
      onTap: widget.onTap,
      onHorizontalDragUpdate: widget.isEditable
          ? (details) {
              setState(() {
                double newProgress = 0;
                // newProgress = widget.progress.progress +
                //     (((widget.challenge.acceptanceCriteria.amount +
                //                     3) * // +3 to make it easier to swipe with widget.challenge.acceptanceCriteria.amount = 1
                //                 details.delta.dx /
                //                 MediaQuery.of(context).size.width) +
                //             (details.delta.dx > 0
                //                 ? 0.4
                //                 : details.delta.dx < 0
                //                     ? -0.4
                //                     : 0))
                //         .round();

                newProgress = (widget.challenge.acceptanceCriteria.amount *
                        ((details.localPosition.dx - 50) /
                            MediaQuery.of(context).size.width) *
                        (0.5 +
                            ((details.localPosition.dx - 50) /
                                MediaQuery.of(context).size.width)))
                    .roundToDouble();

                if (newProgress > widget.challenge.acceptanceCriteria.amount) {
                  newProgress = widget.challenge.acceptanceCriteria.amount;
                } else if (newProgress <= 0) {
                  newProgress = 0;
                }
                widget.progress.progress = newProgress.toDouble();
                widget.progress.setProgress(widget.challenge.acceptanceCriteria,
                    widget.progress.progress);
              });
            }
          : null,
      initialProgress: widget.progress.percentProgress <= 1
          ? widget.progress.percentProgress
          : 1,
      isFailed: widget.isFailed,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [progressIcon(), progress(), mediaItemAmount()],
        ),
      ),
    );
  }

  progress() {
    return ContainerInContainerTextComponent(
        text:
            '${DesignUtil.doubleAsIntString(widget.progress.progress)}/${DesignUtil.doubleAsIntString(widget.challenge.acceptanceCriteria.amount)} ${widget.unit}');
  }

  progressIcon() {
    return const IconContainerInListItemComponent(
      icon: Icons.bolt_rounded,
    );
  }

  mediaItemAmount() {
    return ContainerInContainerComponent(
        child: Row(children: [
      Text(
        '${widget.progress.mediaIds.length} ',
        style: const TextStyle(fontSize: 10, color: themeColor3),
      ),
      const Icon(
        Icons.inventory_2_outlined,
        size: 10,
        color: themeColor3,
      ),
    ]));
  }

  ActionPane endActionPane(Function closeSlideable) {
    return ActionPane(
      extentRatio: 0.22,
      motion: const ScrollMotion(),
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              closeSlideable();
              widget.onTapDeleteProgress?.call();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(24))),
              child: Center(
                  child: Icon(
                IconEnum.delete.icon,
                color: red,
              )),
            ),
          ),
        ),
        const SpaceComponent(
          width: 20,
        )
      ],
    );
  }
}
