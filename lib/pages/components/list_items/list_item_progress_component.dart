import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/progress_model.dart';
import 'package:challenge/pages/components/list_items/list_item_fraction_component.dart';
import 'package:challenge/pages/components/simple_components/container_in_container_text_component.dart';
import 'package:flutter/material.dart';

class ListItemProgressComponent extends StatefulWidget {
  const ListItemProgressComponent(
      {super.key, required this.progress, required this.acceptanceCriteria});

  final ProgressModel progress;
  final AcceptanceCriteriaModel acceptanceCriteria;

  @override
  State<ListItemProgressComponent> createState() =>
      _ListItemProgressComponentState();
}

class _ListItemProgressComponentState extends State<ListItemProgressComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemFractionComponent(
      initialProgress: widget.progress.percentProgress,
      child: Row(
        children: [
          ContainerInContainerTextComponent(
              text:
                  '${widget.progress.progress} ${widget.acceptanceCriteria.unit}')
        ],
      ),
    );
  }
}
