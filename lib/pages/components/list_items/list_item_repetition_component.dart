import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/repetition_model.dart';
import 'package:challenge/pages/components/list_items/list_item_fraction_component.dart';
import 'package:challenge/pages/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';

class ListItemRepetitionComponent extends StatefulWidget {
  const ListItemRepetitionComponent(
      {super.key, required this.repetition, required this.acceptanceCriteria});

  final RepetitionModel repetition;
  final AcceptanceCriteriaModel acceptanceCriteria;

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
            '${widget.repetition.repetitionNumber}/${widget.acceptanceCriteria.frequency.amount} ${DesignUtil.dayDaysTimeOrTimes(widget.acceptanceCriteria.frequency)}');
  }

  ContainerInContainerTextComponent progress() {
    return ContainerInContainerTextComponent(
        text:
            '${DesignUtil.doubleAsInt(widget.repetition.getLastProgressPercentage())} ${widget.acceptanceCriteria.unit}');
  }
}
