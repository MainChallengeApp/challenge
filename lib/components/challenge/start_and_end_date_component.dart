import 'package:challenge/components/challenge/date_component.dart';
import 'package:challenge/components/simple_components/custom_container_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartAndEndDateComponent extends StatefulWidget {
  final ChallengeModel editChallenge;
  final bool isLocked;
  final Function? reloadSearchChallengePage;

  const StartAndEndDateComponent(
      {super.key,
      required this.editChallenge,
      this.isLocked = false,
      this.reloadSearchChallengePage});

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
        startDate(),
        const SpaceComponent(),
        endDate(),
      ],
    );
  }

  Expanded endDate() {
    return Expanded(
      child: DateComponent(
        onTap: widget.isLocked ? null : () => onTapStartOrEndDate('end'),
        date: widget.editChallenge.endDate,
        text: 'End',
        textColor: widget.isLocked ? themeColor3 : Colors.black,
      ),
    );
  }

  Expanded startDate() {
    return Expanded(
      child: DateComponent(
        onTap: widget.isLocked ? null : () => onTapStartOrEndDate('start'),
        date: widget.editChallenge.startDate,
        text: 'Start',
        textColor: widget.isLocked ? themeColor3 : Colors.black,
      ),
    );
  }

  void onTapStartOrEndDate(String startOrEnd) async {
    if (widget.isLocked) return;

    DateTime? initialDateTime = startOrEnd == 'start'
        ? widget.editChallenge.startDate
        : widget.editChallenge.endDate != null
            ? DesignUtil.dateWithoutTime(widget.editChallenge.endDate!)
                .add(const Duration(hours: 23, minutes: 59, seconds: 59))
            : widget.editChallenge.startDate != null
                ? DesignUtil.dateWithoutTime(widget.editChallenge.startDate!)
                    .add(const Duration(hours: 23, minutes: 59, seconds: 59))
                : null;
    setState(() {
      if (startOrEnd == 'start') {
        widget.editChallenge.startDate = null;
      } else if (startOrEnd == 'end') {
        widget.editChallenge.endDate = null;
        widget.editChallenge.setFrequencyAmount();
        widget.reloadSearchChallengePage?.call();
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
                  widget.editChallenge.startDate =
                      initialDateTime ?? DateTime.now();
                  if (widget.editChallenge.endDate == null) {
                    widget.editChallenge.setEndDate();
                  }
                  widget.editChallenge.setFrequencyAmount();
                  widget.reloadSearchChallengePage?.call();
                }
              });
            } else if (startOrEnd == 'end') {
              setState(() {
                if (!isDateTimeChanged) {
                  widget.editChallenge.endDate = initialDateTime ??
                      DesignUtil.dateWithoutTime(DateTime.now()).add(
                          const Duration(hours: 23, minutes: 59, seconds: 59));
                  widget.editChallenge.setFrequencyAmount();
                  widget.reloadSearchChallengePage?.call();
                }
              });
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(CustomContainerComponent.standardRadius),
                topRight:
                    Radius.circular(CustomContainerComponent.standardRadius),
              ),
            ),
            height: size.height * 0.27,
            child: CupertinoDatePicker(
              maximumDate: startOrEnd == 'start' &&
                      widget.editChallenge.frequency.amount == null &&
                      widget.editChallenge.startDate != null
                  ? widget.editChallenge.endDate
                  : null,
              minimumDate: startOrEnd == 'end'
                  ? initialDateTime != null
                      ? widget.editChallenge.startDate
                      : null
                  : null,
              initialDateTime: initialDateTime,
              mode: CupertinoDatePickerMode.dateAndTime,
              use24hFormat: true,
              onDateTimeChanged: (value) {
                isDateTimeChanged = true;
                setState(() {
                  if (startOrEnd == 'start') {
                    widget.editChallenge.startDate = value;
                    widget.editChallenge.setEndDate();
                  } else if (startOrEnd == 'end') {
                    widget.editChallenge.endDate = value;
                    widget.editChallenge.setFrequencyAmount();
                    widget.reloadSearchChallengePage?.call();
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }
}
