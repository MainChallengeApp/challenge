// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../models/acceptance_criteria.dart';
import '../../models/activity.dart';
import '../../models/evidence.dart';

class ListItemAcceptanceCriteriaBar extends StatefulWidget {
  ListItemAcceptanceCriteriaBar(
      {super.key,
      required this.acceptanceCriteria,
      this.isProgressBarLocked = false,
      this.initialProgress = 0}) {
    editAcceptanceCriteria = AcceptanceCriteria(
        id: acceptanceCriteria.id,
        activity: Activity(
            title: acceptanceCriteria.activity.title,
            amount: acceptanceCriteria.activity.amount,
            unit: acceptanceCriteria.activity.unit),
        frequence: acceptanceCriteria.frequence,
        tracking: acceptanceCriteria.tracking,
        progress: initialProgress,
        evidences: acceptanceCriteria.evidences
            .map((e) => Evidence(progress: e.progress, mediaIds: e.mediaIds))
            .toList());
  }

  final AcceptanceCriteria acceptanceCriteria;
  late AcceptanceCriteria editAcceptanceCriteria;
  final bool isProgressBarLocked;
  final int initialProgress;

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
      widget.editAcceptanceCriteria.progress = widget.initialProgress;
    } else {
      widget.editAcceptanceCriteria.progress =
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
          widthFactor: widget.editAcceptanceCriteria.progress / 100,
          heightFactor: 1,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(24))),
          ),
        ),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (!widget.isProgressBarLocked) {
              setState(() {
                int newProgress = 0;
                newProgress = (details.localPosition.dx / 350 * 100).round();
                if (newProgress > 100) {
                  newProgress = 100;
                } else if (newProgress <= 0) {
                  newProgress = 0;
                }
                widget.editAcceptanceCriteria.progress = newProgress;
                widget.acceptanceCriteria.progress = newProgress;
              });
            }
          },
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white.withAlpha(170),
                  borderRadius: const BorderRadius.all(Radius.circular(24))),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10),
                    width: 59,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(241, 245, 249, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Text(
                      '${widget.editAcceptanceCriteria.progress}%',
                      style: const TextStyle(fontSize: 12, color: themeColor3),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 100, // Set your desired maximum width
                    ),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(241, 245, 249, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Text(
                        '${widget.acceptanceCriteria.activity.title} ${widget.acceptanceCriteria.activity.amount} ${widget.acceptanceCriteria.activity.unit}',
                        style:
                            const TextStyle(fontSize: 12, color: themeColor3),
                        overflow: TextOverflow.ellipsis),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(241, 245, 249, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Text(
                      widget.acceptanceCriteria.frequence,
                      style: const TextStyle(fontSize: 12, color: themeColor3),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(241, 245, 249, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Icon(getIconData(), color: themeColor3, size: 14),
                  ),
                ],
              )),
        )
      ],
    );
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
      return Icons.not_accessible;
    }
  }
}
