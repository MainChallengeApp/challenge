import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/challenge/date_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/switch_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartAndEndDateComponent extends StatefulWidget {
  final ChallengeModel? editChallenge;
  final AttemptModel? editAttempt;
  final GroupChallengeModel? groupChallenge;
  final bool isLocked;
  final Function? reloadParentPage;

  const StartAndEndDateComponent.challenge(
      {super.key,
      required this.editChallenge,
      this.isLocked = false,
      this.reloadParentPage})
      : editAttempt = null,
        groupChallenge = null;

  const StartAndEndDateComponent.attempt(
      {super.key,
      required this.editAttempt,
      required this.groupChallenge,
      this.isLocked = false,
      this.reloadParentPage})
      : editChallenge = null;

  @override
  State<StartAndEndDateComponent> createState() =>
      _StartAndEndDateComponentState();
}

class _StartAndEndDateComponentState extends State<StartAndEndDateComponent> {
  bool _dateWithTime = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _startDateComponent(),
        const SpaceComponent(),
        _endDateComponent(),
      ],
    );
  }

  Expanded _endDateComponent() {
    return Expanded(
      child: DateComponent(
        onTap: widget.isLocked ? null : () => onTapStartOrEndDate('end'),
        date: _getEndDate(),
        text: 'End',
        textColor: widget.isLocked
            ? Theme.of(context).colorScheme.tertiary
            : Colors.black,
      ),
    );
  }

  Expanded _startDateComponent() {
    return Expanded(
      child: DateComponent(
        onTap: widget.isLocked ? null : () => onTapStartOrEndDate('start'),
        date: _getStartDate(),
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

    // setState(() {
    //   if (startOrEnd == 'start') {
    //     _setStartDate(null);
    //   } else if (startOrEnd == 'end') {
    //     _setEndDate(null);
    //     calcFrequencyAmount();
    //     widget.reloadParentPage?.call();
    //   }
    // });

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
                      _setStartDate(initialDateTime ??
                          (_dateWithTime
                              ? TimeService.now()
                              : UtilService.dateWithoutTime(
                                  TimeService.now())));
                      if (_getEndDate() == null) {
                        calcEndDate();
                      }
                      calcFrequencyAmount();
                      widget.reloadParentPage?.call();
                    }
                  });
                } else if (startOrEnd == 'end') {
                  setState(() {
                    if (!isDateTimeChanged) {
                      _setEndDate(initialDateTime ??
                          UtilService.dateWithoutTime(TimeService.now()));

                      if (_getStartDate() == null) {
                        calcStartDate();
                      }
                      calcFrequencyAmount();
                      widget.reloadParentPage?.call();
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
                                      _getStartDate() != null) {
                                    _setStartDate(UtilService.dateWithoutTime(
                                        _getStartDate()!));
                                    calcEndDate();
                                  } else if (startOrEnd == 'end' &&
                                      _getEndDate() != null) {
                                    _setEndDate(UtilService.dateWithoutTime(
                                        _getEndDate()!));
                                    calcStartDate();
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
                        maximumDate: _maximumDate(startOrEnd),
                        minimumDate: _minimumDate(startOrEnd, initialDateTime),
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
                              _setStartDate(value);
                              calcEndDate();
                            } else if (startOrEnd == 'end') {
                              _setEndDate(value);
                              calcStartDate();
                              widget.reloadParentPage?.call();
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

  DateTime? _minimumDate(String startOrEnd, DateTime? initialDateTime) {
    if (startOrEnd == 'start') {
      if (widget.editAttempt != null && widget.groupChallenge != null) {
        if (widget.groupChallenge!.startDate == null) {
          return null;
        }
        return widget.editAttempt!
                    .getStartDate(widget.groupChallenge!)
                    ?.isBefore(widget.groupChallenge!.startDate!) ??
                false
            ? null
            : widget.groupChallenge!.startDate;
      }
      return null;
    } else {
      if (widget.editAttempt != null && widget.groupChallenge != null) {
        return (widget.groupChallenge?.startDate ?? DateTime(0))
                .isAfter(widget.editAttempt?.startDate ?? DateTime(0))
            ? widget.groupChallenge?.startDate
            : widget.editAttempt?.startDate;
      }
      return initialDateTime != null ? _getStartDate() : null;
    }
  }

  DateTime? _maximumDate(String startOrEnd) {
    if (startOrEnd == 'end') {
      if (widget.editAttempt != null && widget.groupChallenge != null) {
        if (widget.groupChallenge!.endDate == null) {
          return null;
        }
        return widget.editAttempt!
                    .getEndDate(widget.groupChallenge!)
                    ?.isAfter(widget.groupChallenge!.endDate!) ??
                false
            ? null
            : widget.groupChallenge!.endDate;
      }
      return null;
    } else {
      if (widget.editAttempt != null && widget.groupChallenge != null) {
        return widget.editAttempt!.getEndDate(widget.groupChallenge!);
      }
      return getFrequencyAmount() == null && _getStartDate() != null
          ? _getEndDate()
          : null;
    }
  }

  DateTime? setInitialTime(String startOrEnd) {
    if (startOrEnd == 'start') {
      if (widget.editAttempt != null && widget.groupChallenge != null) {
        return _getStartDate() ?? widget.groupChallenge!.startDate;
      }
      return _getStartDate();
    } else {
      if (widget.editAttempt != null && widget.groupChallenge != null) {
        return _getEndDate() ?? widget.groupChallenge!.endDate;
      }
      return _getEndDate() ?? _getStartDate();
    }
  }

  void calcEndDate() {
    if (widget.editChallenge != null) {
      widget.editChallenge!.setEndDate();
      return;
    }
    if (widget.editAttempt != null && widget.groupChallenge != null) {
      widget.editAttempt!.setEndDate(widget.groupChallenge!);
    }
  }

  void calcStartDate() {
    if (widget.editChallenge != null) {
      widget.editChallenge!.setStartDate();
      return;
    }
    if (widget.editAttempt != null && widget.groupChallenge != null) {
      widget.editAttempt!.setStartDate(widget.groupChallenge!);
    }
  }

  void calcFrequencyAmount() {
    if (widget.editChallenge != null) {
      widget.editChallenge!.setFrequencyAmount();
      return;
    }
    if (widget.editAttempt != null && widget.groupChallenge != null) {
      widget.editAttempt!.setFrequencyAmount(widget.groupChallenge!);
    }
  }

  _setEndDate(DateTime? endDate) {
    if (!_dateWithTime && endDate != null) {
      endDate = UtilService.dateWithoutTime(endDate);
    }
    if (widget.editChallenge != null) {
      widget.editChallenge!.endDate = endDate;
      return;
    }
    if (widget.editAttempt != null && widget.groupChallenge != null) {
      widget.editAttempt!.endDate = endDate;
    }
  }

  _setStartDate(DateTime? startDate) {
    if (widget.editChallenge != null) {
      widget.editChallenge!.startDate = startDate;
      return;
    }
    if (widget.editAttempt != null && widget.groupChallenge != null) {
      widget.editAttempt!.startDate = startDate;
    }
  }

  _getEndDate() {
    if (widget.editChallenge != null) {
      return widget.editChallenge!.endDate;
    }
    return widget.editAttempt!.getEndDate(widget.groupChallenge!);
  }

  _getStartDate() {
    if (widget.editChallenge != null) {
      return widget.editChallenge!.startDate;
    }
    return widget.editAttempt!.getStartDate(widget.groupChallenge!);
  }

  int? getFrequencyAmount() {
    if (widget.editChallenge != null) {
      return widget.editChallenge!.frequency.amount;
    }
    return widget.editAttempt!.getFrequency(widget.groupChallenge!).amount;
  }
}
