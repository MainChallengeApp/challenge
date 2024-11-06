import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/challenge/date_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttemptStartAndEndDateComponent extends StatefulWidget {
  final AttemptModel attempt;
  final bool isLocked;
  final Function? reloadSearchChallengePage;
  final GroupChallengeModel groupChallenge;

  const AttemptStartAndEndDateComponent(
      {super.key,
      required this.attempt,
      this.isLocked = false,
      this.reloadSearchChallengePage,
      required this.groupChallenge});

  @override
  State<AttemptStartAndEndDateComponent> createState() =>
      _AttemptStartAndEndDateComponentState();
}

class _AttemptStartAndEndDateComponentState
    extends State<AttemptStartAndEndDateComponent> {
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
        date: widget.attempt.getEndDate(widget.groupChallenge),
        text: 'End',
        textColor: widget.isLocked
            ? Theme.of(context).colorScheme.tertiary
            : Colors.black,
      ),
    );
  }

  Expanded startDate() {
    return Expanded(
      child: DateComponent(
        onTap: widget.isLocked ? null : () => onTapStartOrEndDate('start'),
        date: widget.attempt.getStartDate(widget.groupChallenge),
        text: 'Start',
        textColor: widget.isLocked
            ? Theme.of(context).colorScheme.tertiary
            : Colors.black,
      ),
    );
  }

  void onTapStartOrEndDate(String startOrEnd) async {
    if (widget.isLocked) return;

    DateTime? initialDateTime = startOrEnd == 'start'
        ? widget.attempt.getStartDate(widget.groupChallenge)
        : widget.attempt.getEndDate(widget.groupChallenge) != null
            ? UtilService.dateWithoutTime(
                    widget.attempt.getEndDate(widget.groupChallenge)!)
                .add(const Duration(hours: 23, minutes: 59, seconds: 59))
            : widget.attempt.getStartDate(widget.groupChallenge) != null
                ? UtilService.dateWithoutTime(
                        widget.attempt.getStartDate(widget.groupChallenge)!)
                    .add(const Duration(hours: 23, minutes: 59, seconds: 59))
                : null;
    setState(() {
      if (startOrEnd == 'start') {
        widget.attempt.startDate = null;
      } else if (startOrEnd == 'end') {
        widget.attempt.endDate = null;
        widget.attempt.setFrequencyAmount(widget.groupChallenge);
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
              setState(() async {
                if (!isDateTimeChanged) {
                  widget.attempt.startDate = initialDateTime ?? DateTime.now();
                  if (widget.attempt.getEndDate(widget.groupChallenge) ==
                      null) {
                    widget.attempt.setEndDate(widget.groupChallenge);
                  }
                  widget.attempt.setFrequencyAmount(widget.groupChallenge);
                  widget.reloadSearchChallengePage?.call();
                }
              });
            } else if (startOrEnd == 'end') {
              setState(() async {
                if (!isDateTimeChanged) {
                  widget.attempt.endDate = initialDateTime ??
                      UtilService.dateWithoutTime(DateTime.now()).add(
                          const Duration(hours: 23, minutes: 59, seconds: 59));
                  widget.attempt.setFrequencyAmount(widget.groupChallenge);
                  widget.reloadSearchChallengePage?.call();
                }
              });
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(CardComponent.standardBorderRadius),
                topRight: Radius.circular(CardComponent.standardBorderRadius),
              ),
            ),
            height: size.height * 0.3,
            child: CupertinoDatePicker(
              maximumDate: startOrEnd == 'start' &&
                      widget.attempt
                              .getFrequency(widget.groupChallenge)
                              .amount ==
                          null &&
                      widget.attempt.getStartDate(widget.groupChallenge) != null
                  ? widget.attempt.getEndDate(widget.groupChallenge)
                  : null,
              minimumDate: startOrEnd == 'end'
                  ? initialDateTime != null
                      ? widget.attempt.getStartDate(widget.groupChallenge)
                      : null
                  : null,
              initialDateTime: initialDateTime,
              mode: CupertinoDatePickerMode.dateAndTime,
              use24hFormat: true,
              onDateTimeChanged: (value) {
                isDateTimeChanged = true;
                setState(() {
                  if (startOrEnd == 'start') {
                    widget.attempt.startDate = value;
                    widget.attempt.setEndDate(widget.groupChallenge);
                  } else if (startOrEnd == 'end') {
                    widget.attempt.endDate = value;
                    widget.attempt.setFrequencyAmount(widget.groupChallenge);
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
