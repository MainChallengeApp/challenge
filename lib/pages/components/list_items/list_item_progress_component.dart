import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/models/progress_model.dart';
import 'package:challenge/pages/components/list_items/list_item_fraction_component.dart';
import 'package:challenge/pages/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/pages/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';

class ListItemProgressComponent extends StatefulWidget {
  const ListItemProgressComponent(
      {super.key,
      required this.progress,
      required this.unit,
      required this.challenge,
      this.onTap,
      required this.isFailed});

  final ProgressModel progress;
  final String unit;
  final ChallengeModel challenge;
  final void Function()? onTap;
  final bool isFailed;

  @override
  State<ListItemProgressComponent> createState() =>
      _ListItemProgressComponentState();
}

class _ListItemProgressComponentState extends State<ListItemProgressComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemFractionComponent(
      onTap: widget.onTap,
      initialProgress: widget.progress.percentProgress <= 1
          ? widget.progress.percentProgress
          : 1,
      isFailed: widget.isFailed,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [progressIcon(), progress()],
        ),
      ),
    );
  }

  progress() {
    return ContainerInContainerTextComponent(
        text:
            '${DesignUtil.doubleAsInt(widget.progress.progress)}/${DesignUtil.doubleAsInt(widget.challenge.acceptanceCriteria.amount)} ${widget.unit}');
  }

  progressIcon() {
    return const IconContainerInListItemComponent(
      icon: Icons.north_rounded,
    );
  }
}
