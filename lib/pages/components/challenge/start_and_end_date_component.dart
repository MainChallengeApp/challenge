import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartAndEndDateComponent extends StatefulWidget {
  final ChallengeModel editChallenge;
  final bool isLocked;

  const StartAndEndDateComponent(
      {super.key, required this.editChallenge, this.isLocked = false});

  @override
  State<StartAndEndDateComponent> createState() =>
      _StartAndEndDateComponentState();
}

class _StartAndEndDateComponentState extends State<StartAndEndDateComponent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onTapStartOrEndDate('start'),
            child: standardContainer(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Start',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  (widget.editChallenge.startDate != null
                      ? _dateFormat(widget.editChallenge.startDate!)
                      : '-'),
                  style: const TextStyle(color: themeColor3),
                )
              ],
            )),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => onTapStartOrEndDate('end'),
            child: standardContainer(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'End',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  (widget.editChallenge.endDate != null
                      ? _dateFormat(widget.editChallenge.endDate!)
                      : '-'),
                  style: const TextStyle(color: themeColor3),
                )
              ],
            )),
          ),
        ),
      ],
    );
  }

  standardContainer({required Widget child, double heightFactor = 1}) {
    return Container(
      // width: double.infinity,
      height: 55 * heightFactor,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: child,
    );
  }

  void onTapStartOrEndDate(String startOrEnd) async {
    if (widget.isLocked) return;

    DateTime? initialDateTime =
        startOrEnd == 'start' || widget.editChallenge.endDate == null
            ? widget.editChallenge.startDate
            : widget.editChallenge.endDate;
    setState(() {
      if (startOrEnd == 'start') {
        widget.editChallenge.startDate = null;
      } else if (startOrEnd == 'end') {
        widget.editChallenge.endDate = null;
        widget.editChallenge.setFrequencyAmount();
      }
    });

    bool isDateTimeChanged = false;

    await showCupertinoModalPopup(
      context: context,
      builder: (c) {
        var size = MediaQuery.of(context).size;
        return GestureDetector(
          onTap: () {
            if (startOrEnd == 'start') {
              setState(() {
                if (!isDateTimeChanged) {
                  widget.editChallenge.startDate = initialDateTime ??
                      DesignUtil.dateWithoutTime(DateTime.now());
                }
                widget.editChallenge.setEndDate();
              });
            } else if (startOrEnd == 'end') {
              setState(() {
                if (!isDateTimeChanged) {
                  widget.editChallenge.endDate = initialDateTime ??
                      DesignUtil.dateWithoutTime(DateTime.now());
                }
                widget.editChallenge.setFrequencyAmount();
              });
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            height: size.height * 0.27,
            child: CupertinoDatePicker(
              maximumDate: startOrEnd == 'start' &&
                      widget.editChallenge.acceptanceCriterias.first.frequency
                              .amount ==
                          null &&
                      widget.editChallenge.startDate != null
                  ? widget.editChallenge.endDate
                  : null,
              minimumDate: startOrEnd == 'end'
                  ? initialDateTime != null
                      ? widget.editChallenge.startDate
                      : null
                  : DesignUtil.dateWithoutTime(DateTime.now()),
              initialDateTime: initialDateTime,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                value = DesignUtil.dateWithoutTime(value);
                isDateTimeChanged = true;
                setState(() {
                  if (startOrEnd == 'start') {
                    widget.editChallenge.startDate = value;
                    widget.editChallenge.setEndDate();
                  } else if (startOrEnd == 'end') {
                    widget.editChallenge.endDate = value;
                    widget.editChallenge.setFrequencyAmount();
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }

  String _dateFormat(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
