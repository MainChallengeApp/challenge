import 'dart:math';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/models/repetition_model.dart';
import 'package:challenge/pages/components/list_items/list_item_fraction_component.dart';
import 'package:challenge/pages/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/pages/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';

class ListItemRepetitionComponent extends StatefulWidget {
  const ListItemRepetitionComponent(
      {super.key,
      required this.repetition,
      this.onTap,
      required this.challenge});

  final RepetitionModel repetition;
  final ChallengeModel challenge;
  final void Function()? onTap;

  @override
  State<ListItemRepetitionComponent> createState() =>
      _ListItemRepetitionComponentState();
}

class _ListItemRepetitionComponentState
    extends State<ListItemRepetitionComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: ContainerInContainerTextComponent(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.only(
                  left: 35, right: 10, top: 10, bottom: 10),
              color: Colors.transparent,
              text: DesignUtil.getDateAndTimeFormated(
                  widget.repetition.startDate)),
        ),
        ListItemFractionComponent(
          initialProgress:
              min(1, widget.repetition.getLastProgressPercentage()),
          isFailed: widget.repetition.isFailed(widget.challenge),
          onTap: widget.onTap,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [repetitionIcon(), repetition(), progress()],
            ),
          ),
        ),
      ],
    );
  }

  repetition() {
    return ContainerInContainerTextComponent(
        text:
            '${widget.repetition.repetitionNumber}/${widget.challenge.frequency.amount ?? '∞'} ${widget.challenge.frequency.dayDaysTimeOrTimes()}');
  }

  progress() {
    return ContainerInContainerTextComponent(
        text:
            '${DesignUtil.doubleAsInt(widget.repetition.getLastProgressProgress())}/${DesignUtil.doubleAsInt(widget.challenge.acceptanceCriteria.amount)} ${widget.challenge.acceptanceCriteria.unit}');
  }

  repetitionIcon() {
    return const IconContainerInListItemComponent(
      icon: Icons.repeat_rounded,
    );
  }
}
