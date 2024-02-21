// ignore_for_file: must_be_immutable
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';

import 'package:challenge/globals.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';

class ListItemAcceptanceCriteriaBarComponent extends StatefulWidget {
  ListItemAcceptanceCriteriaBarComponent(
      {super.key,
      required this.acceptanceCriteria,
      this.isProgressBarLocked = false,
      this.isEvidence = false,
      this.initialProgress = 0,
      this.editAcceptanceCriteria,
      this.isFailed = false}) {
    editAcceptanceCriteria ??= AcceptanceCriteriaModel(
        id: 0,
        title: 'title',
        amount: 0,
        unit: 'unit',
        frequence: 'daily',
        tracking: 'camera',
        currentProgress: initialProgress,
        progress: []);
  }

  final AcceptanceCriteriaModel acceptanceCriteria;
  late AcceptanceCriteriaModel? editAcceptanceCriteria;
  final bool isProgressBarLocked;
  final bool isEvidence;
  final double initialProgress;
  final bool isFailed;

  @override
  State<ListItemAcceptanceCriteriaBarComponent> createState() =>
      _ListItemAcceptanceCriteriaBarComponentState();
}

class _ListItemAcceptanceCriteriaBarComponentState
    extends State<ListItemAcceptanceCriteriaBarComponent> {
  @override
  void initState() {
    super.initState();
    if (widget.initialProgress != 0) {
      widget.editAcceptanceCriteria!.currentProgress = widget.initialProgress;
    } else {
      widget.editAcceptanceCriteria!.currentProgress =
          widget.acceptanceCriteria.currentProgress;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 64,
        margin: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
            borderRadius: const BorderRadius.all(Radius.circular(24))),
        child: singleAcceptanceCriteria(),
      ),
    );
  }

  singleAcceptanceCriteria() {
    return Stack(
      children: [
        FractionallySizedBox(
          widthFactor: calcProgressRatio(),
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
        GestureDetector(
          // onHorizontalDragUpdate: (details) {
          //   if (!widget.isProgressBarLocked) {
          //     setState(() {
          //       int newProgress = 0;
          //       newProgress = (details.localPosition.dx / 350 * 100).round();
          //       if (newProgress > 100) {
          //         newProgress = 100;
          //       } else if (newProgress <= 0) {
          //         newProgress = 0;
          //       }
          //       widget.editAcceptanceCriteria!.progress =
          //           newProgress.toDouble();
          //     });
          //   }
          // },
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white.withAlpha(170),
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(24))),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: themeColor4,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Text(
                      widget.isEvidence
                          ? widget.acceptanceCriteria.amount == 0
                              ? '100%'
                              : '${(widget.initialProgress / widget.acceptanceCriteria.amount * 100).toInt()}%'
                          : '${(widget.editAcceptanceCriteria!.calcProgressRatio() * 100).toInt()}%',
                      style: const TextStyle(fontSize: 12, color: themeColor3),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 150, // Set your desired maximum width
                    ),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: themeColor4,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Text(
                        widget.isEvidence
                            ? '${DesignUtil.doubleAsInt(widget.initialProgress)}/${DesignUtil.doubleAsInt(widget.acceptanceCriteria.amount)} ${widget.acceptanceCriteria.unit}'
                            : '${DesignUtil.doubleAsInt(widget.editAcceptanceCriteria!.currentProgress)}/${DesignUtil.doubleAsInt(widget.acceptanceCriteria.amount)} ${widget.acceptanceCriteria.unit}',
                        style:
                            const TextStyle(fontSize: 12, color: themeColor3),
                        overflow: TextOverflow.ellipsis),
                  ),
                  Expanded(child: Container()),
                ],
              )),
        )
      ],
    );
  }

  double calcProgressRatio() {
    return widget.isEvidence
        ? widget.acceptanceCriteria.amount == 0
            ? 1
            : widget.initialProgress / widget.acceptanceCriteria.amount > 1
                ? 1
                : widget.initialProgress / widget.acceptanceCriteria.amount
        : widget.editAcceptanceCriteria!.calcProgressRatio() > 1
            ? 1
            : widget.editAcceptanceCriteria!.calcProgressRatio();
  }

  IconData getIconData() {
    if (widget.acceptanceCriteria.tracking == 'camera') {
      return Icons.camera_alt_outlined;
    } else if (widget.acceptanceCriteria.tracking == 'gps') {
      return Icons.gps_not_fixed;
    } else if (widget.acceptanceCriteria.tracking == 'notes') {
      return Icons.notes;
    } else if (widget.acceptanceCriteria.tracking == 'numbers') {
      return Icons.numbers;
    } else {
      return Icons.not_interested_rounded;
    }
  }
}
