import 'dart:math';

import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/list_items/list_item_fraction_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/small_container_in_list_item_component.dart';
import 'package:flutter/material.dart';

class ListItemRepetitionComponent extends StatefulWidget {
  const ListItemRepetitionComponent(
      {super.key,
      required this.repetition,
      this.onTap,
      required this.attempt,
      required this.groupChallenge});

  final RepetitionModel repetition;
  final AttemptModel attempt;
  final GroupChallengeModel groupChallenge;
  final void Function()? onTap;

  @override
  State<ListItemRepetitionComponent> createState() =>
      _ListItemRepetitionComponentState();
}

class _ListItemRepetitionComponentState
    extends State<ListItemRepetitionComponent> {
  @override
  Widget build(BuildContext context) {
    widget.repetition.evaluateRepetitionStatus();
    return ListItemFractionComponent(
      initialProgress: min(
          1,
          widget.repetition.getLastProgressPercentage(
              widget.groupChallenge, widget.attempt)),
      isFailed: widget.attempt.isFailed(widget.groupChallenge),
      onTap: widget.onTap,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [repetitionIcon(), repetition(), progress()],
        ),
      ),
    );
  }

  repetition() {
    return ContainerInContainerTextComponent(
        margin: const EdgeInsets.only(
            right: ContainerInContainerComponent.standardMargin),
        height: SmallContainerInListItemComponent.height,
        text:
            '${widget.repetition.repetitionNumber}/${widget.attempt.getFrequency(widget.groupChallenge).amount ?? 'max.'} ${widget.attempt.getFrequency(widget.groupChallenge).typeToString()}');
  }

  progress() {
    return ContainerInContainerTextComponent(
        margin: const EdgeInsets.only(
            right: ContainerInContainerComponent.standardMargin),
        height: SmallContainerInListItemComponent.height,
        text:
            '${UtilService.doubleAsIntString(widget.repetition.getLastProgressAbsolute())}/${UtilService.doubleAsIntString(widget.attempt.getAcceptanceCriteria(widget.groupChallenge).amount)} ${widget.attempt.getAcceptanceCriteria(widget.groupChallenge).unit}');
  }

  repetitionIcon() {
    return IconContainerInListItemComponent(
      icon: IconEnum.repetition.icon,
    );
  }
}
