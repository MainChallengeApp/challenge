// ignore_for_file: must_be_immutable

import 'package:challenge/models/challenge.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class ListItemAcceptanceCriteriaBar extends StatefulWidget {
  ListItemAcceptanceCriteriaBar({super.key, required this.acceptanceCriteria}) {
    editAcceptanceCriteria = AcceptanceCriteria(
        activity: Activity(
            title: acceptanceCriteria.activity.title,
            amount: acceptanceCriteria.activity.amount,
            unit: acceptanceCriteria.activity.unit),
        frequence: acceptanceCriteria.frequence,
        tracking: acceptanceCriteria.tracking,
        progress: acceptanceCriteria.progress);
  }

  final AcceptanceCriteria acceptanceCriteria;
  late AcceptanceCriteria editAcceptanceCriteria;

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
    widget.editAcceptanceCriteria.progress = widget.acceptanceCriteria.progress;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: onTap,
      child: Center(
        child: Container(
          width: double.infinity,
          height: 64,
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(24))),
          child: singleAcceptanceCriteria(),
        ),
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
                borderRadius: BorderRadius.all(Radius.circular(16))),
          ),
        ),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              widget.editAcceptanceCriteria.progress = 
                  (details.localPosition.dx / 350 * 100).round();
              if(widget.editAcceptanceCriteria.progress > 100){
                widget.editAcceptanceCriteria.progress = 100;
              } else if(widget.editAcceptanceCriteria.progress <= widget.acceptanceCriteria.progress ){
                widget.editAcceptanceCriteria.progress = widget.acceptanceCriteria.progress;
              } else if(widget.editAcceptanceCriteria.progress <= 0 ){
                widget.editAcceptanceCriteria.progress = 0;
              }
            });
          },
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white.withAlpha(170),
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
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
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(241, 245, 249, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Text(
                      '${widget.acceptanceCriteria.activity.title} ${widget.acceptanceCriteria.activity.amount} ${widget.acceptanceCriteria.activity.unit}',
                      style: const TextStyle(fontSize: 12, color: themeColor3),
                    ),
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
