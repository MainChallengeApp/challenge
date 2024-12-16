import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/challenge/date_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/switch_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChallengeStartAndEndDateComponent extends StatefulWidget {
  final ChallengeModel editChallenge;
  final bool isLocked;
  final Function? reloadSearchChallengePage;

  const ChallengeStartAndEndDateComponent(
      {super.key,
      required this.editChallenge,
      this.isLocked = false,
      this.reloadSearchChallengePage});

  @override
  State<ChallengeStartAndEndDateComponent> createState() =>
      _ChallengeStartAndEndDateComponentState();
}

class _ChallengeStartAndEndDateComponentState
    extends State<ChallengeStartAndEndDateComponent> {
  bool _dateWithTime = false;

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
        date: widget.editChallenge.startDate,
        text: 'Start',
        textColor: widget.isLocked
            ? Theme.of(context).colorScheme.tertiary
            : Colors.black,
      ),
    );
  }

  void onTapStartOrEndDate(String startOrEnd) async {
    if (widget.isLocked) return;

    DateTime? initialDateTime = setInitialTime(startOrEnd);

    _dateWithTime = initialDateTime != null &&
        initialDateTime
                .difference(UtilService.dateWithoutTime(initialDateTime))
                .inSeconds !=
            0;

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
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            var size = MediaQuery.of(context).size;
            return GestureDetector(
              onTap: () {
                if (startOrEnd == 'start') {
                  setState(() {
                    if (!isDateTimeChanged) {
                      widget.editChallenge.startDate = initialDateTime ??
                          (_dateWithTime
                              ? TimeService.now()
                              : UtilService.dateWithoutTime(TimeService.now()));
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
                          UtilService.dateWithoutTime(TimeService.now()).add(
                              const Duration(
                                  hours: 23, minutes: 59, seconds: 59));
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
                        Radius.circular(CardComponent.standardBorderRadius),
                    topRight:
                        Radius.circular(CardComponent.standardBorderRadius),
                  ),
                ),
                height: size.height * 0.3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: BottomNavigationComponent.standardMargin * 2.2,
                          right: BottomNavigationComponent.standardMargin * 2.2,
                          top: BottomNavigationComponent.standardMargin / 1.8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Time',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SwitchComponent(
                              value: _dateWithTime,
                              onChanged: (value) {
                                setModalState(() {
                                  _dateWithTime = value;
                                  if (_dateWithTime) {
                                    initialDateTime =
                                        setInitialTime(startOrEnd);
                                    return;
                                  }

                                  if (startOrEnd == 'start' &&
                                      widget.editChallenge.startDate != null) {
                                    widget.editChallenge.startDate =
                                        UtilService.dateWithoutTime(
                                            widget.editChallenge.startDate!);
                                    widget.editChallenge.setEndDate();
                                  } else if (startOrEnd == 'end' &&
                                      widget.editChallenge.endDate != null) {
                                    widget.editChallenge.endDate =
                                        UtilService.dateWithoutTime(
                                                widget.editChallenge.endDate!)
                                            .add(const Duration(
                                                hours: 23,
                                                minutes: 59,
                                                seconds: 59));
                                    widget.editChallenge.setFrequencyAmount();
                                  }
                                  initialDateTime = setInitialTime(startOrEnd);

                                  setState(() {});
                                });
                              }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CupertinoDatePicker(
                        key: UniqueKey(),
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
                        initialDateTime: initialDateTime ?? TimeService.now(),
                        mode: _dateWithTime
                            ? CupertinoDatePickerMode.dateAndTime
                            : CupertinoDatePickerMode.date,
                        dateOrder: DatePickerDateOrder.dmy,
                        showDayOfWeek: true,
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
                  ],
                ),
              ),
            );
          });
        });
  }

  DateTime? setInitialTime(String startOrEnd) {
    return startOrEnd == 'start'
        ? widget.editChallenge.startDate
        : widget.editChallenge.endDate != null
            ? UtilService.dateWithoutTime(widget.editChallenge.endDate!)
                .add(const Duration(hours: 23, minutes: 59, seconds: 59))
            : widget.editChallenge.startDate != null
                ? UtilService.dateWithoutTime(widget.editChallenge.startDate!)
                    .add(const Duration(hours: 23, minutes: 59, seconds: 59))
                : null;
  }
}
