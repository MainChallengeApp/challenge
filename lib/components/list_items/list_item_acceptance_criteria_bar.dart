// ignore_for_file: must_be_immutable
import 'package:challenge/models/activity.dart';
import 'package:flutter/material.dart';

import 'package:challenge/globals.dart';
import 'package:challenge/models/acceptance_criteria.dart';

class ListItemAcceptanceCriteriaBar extends StatefulWidget {
  ListItemAcceptanceCriteriaBar(
      {super.key,
      required this.acceptanceCriteria,
      this.isProgressBarLocked = false,
      this.isEvidence = false,
      this.initialProgress = 0,
      this.editAcceptanceCriteria}) {
    editAcceptanceCriteria ??= AcceptanceCriteria(
        id: 0,
        activity: Activity(title: 'title', amount: 0, unit: 'unit'),
        frequence: 'daily',
        tracking: 'camera',
        progress: initialProgress,
        evidences: []);
  }

  final AcceptanceCriteria acceptanceCriteria;
  late AcceptanceCriteria? editAcceptanceCriteria;
  final bool isProgressBarLocked;
  final bool isEvidence;
  final double initialProgress;

  @override
  State<ListItemAcceptanceCriteriaBar> createState() =>
      _ListItemAcceptanceCriteriaBarState();
}

class _ListItemAcceptanceCriteriaBarState
    extends State<ListItemAcceptanceCriteriaBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initialProgress != 0) {
      widget.editAcceptanceCriteria!.progress = widget.initialProgress;
    } else {
      widget.editAcceptanceCriteria!.progress =
          widget.acceptanceCriteria.progress;
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
            decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(24))),
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
                        color: Color.fromRGBO(241, 245, 249, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Text(
                      widget.isEvidence
                          ? widget.acceptanceCriteria.activity.amount == 0
                              ? '100%'
                              : '${(widget.initialProgress / widget.acceptanceCriteria.activity.amount * 100).toInt()}%'
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
                        color: Color.fromRGBO(241, 245, 249, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Text(
                        widget.isEvidence
                            ? '${doubleAsInt(widget.initialProgress)}/${doubleAsInt(widget.acceptanceCriteria.activity.amount)} ${widget.acceptanceCriteria.activity.unit}'
                            : '${doubleAsInt(widget.editAcceptanceCriteria!.progress)}/${doubleAsInt(widget.acceptanceCriteria.activity.amount)} ${widget.acceptanceCriteria.activity.unit}',
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
        ? widget.acceptanceCriteria.activity.amount == 0
            ? 1
            : widget.initialProgress /
                        widget.acceptanceCriteria.activity.amount >
                    1
                ? 1
                : widget.initialProgress /
                    widget.acceptanceCriteria.activity.amount
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

  String doubleAsInt(double number) {
    if (number.toString().endsWith('.0')) {
      return number.toString().split('.')[0];
    }
    return number.toString();
  }
}
