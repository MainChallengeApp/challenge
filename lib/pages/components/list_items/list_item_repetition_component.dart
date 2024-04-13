import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/models/repetition_model.dart';
import 'package:challenge/pages/components/list_items/list_item_fraction_component.dart';
import 'package:challenge/pages/components/simple_components/container_in_container_text_component.dart';
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
    return ListItemFractionComponent(
      initialProgress: widget.repetition.getLastProgressPercentage(),
      onTap: widget.onTap,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [repetition(), progress()],
        ),
      ),
    );
  }

  ContainerInContainerTextComponent repetition() {
    return ContainerInContainerTextComponent(
        text:
            '${widget.repetition.repetitionNumber}/${widget.challenge.frequency.amount} ${widget.challenge.frequency.dayDaysTimeOrTimes()}');
  }

  ContainerInContainerTextComponent progress() {
    return ContainerInContainerTextComponent(
        text:
            '${DesignUtil.doubleAsInt(widget.repetition.getLastProgressPercentage())} ${widget.challenge.acceptanceCriteria.unit}');
  }
}
