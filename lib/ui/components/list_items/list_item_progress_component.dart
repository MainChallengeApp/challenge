import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/progress_model.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_fraction_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListItemProgressComponent extends StatefulWidget {
  const ListItemProgressComponent(
      {super.key,
      required this.progress,
      required this.unit,
      required this.attempt,
      this.onTap,
      required this.isFailed,
      this.isSlidable = false,
      this.onTapDeleteProgress,
      this.isEditable = false,
      this.margin,
      required this.groupChallenge});

  final ProgressModel progress;
  final String unit;
  final AttemptModel attempt;
  final GroupChallengeModel groupChallenge;
  final void Function()? onTap;
  final bool isFailed;
  final bool isSlidable;
  final void Function()? onTapDeleteProgress;
  final bool isEditable;
  final EdgeInsetsGeometry? margin;

  @override
  State<ListItemProgressComponent> createState() =>
      _ListItemProgressComponentState();
}

class _ListItemProgressComponentState extends State<ListItemProgressComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemFractionComponent(
      margin: widget.margin,
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

                newProgress = (widget.attempt
                            .getAcceptanceCriteria(widget.groupChallenge)
                            .amount *
                        ((details.localPosition.dx - 50) /
                            MediaQuery.of(context).size.width) *
                        (0.5 +
                            ((details.localPosition.dx - 50) /
                                MediaQuery.of(context).size.width)))
                    .roundToDouble();

                if (newProgress >
                    widget.attempt
                        .getAcceptanceCriteria(widget.groupChallenge)
                        .amount) {
                  newProgress = widget.attempt
                      .getAcceptanceCriteria(widget.groupChallenge)
                      .amount;
                } else if (newProgress <= 0) {
                  newProgress = 0;
                }
                widget.progress.progress = newProgress.toDouble();
              });
            }
          : null,
      initialProgress: widget.progress
                  .getPercentProgress(widget.groupChallenge, widget.attempt) <=
              1
          ? widget.progress
              .getPercentProgress(widget.groupChallenge, widget.attempt)
          : 1,
      isFailed: widget.attempt.isFailed(),
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
            '${UtilService.doubleAsIntString(widget.progress.progress)}/${UtilService.doubleAsIntString(widget.attempt.getAcceptanceCriteria(widget.groupChallenge).amount)} ${widget.unit}');
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
        style: Theme.of(context).textTheme.bodySmall,
      ),
      Icon(
        Icons.inventory_2_outlined,
        size: Theme.of(context).textTheme.bodySmall?.fontSize,
        color: Theme.of(context).colorScheme.tertiary,
      ),
    ]));
  }

  ActionPane endActionPane(Function closeSlidable) {
    return ActionPane(
      extentRatio: 0.22,
      motion: const ScrollMotion(),
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              await closeSlidable();
              widget.onTapDeleteProgress?.call();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(
                      ListItemContainerComponent.standardBorderRadius))),
              child: Center(
                  child: Icon(
                IconEnum.delete.icon,
                color: Theme.of(context).colorScheme.red,
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
