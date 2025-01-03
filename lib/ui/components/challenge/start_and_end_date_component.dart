import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/challenge/date_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
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
        dateWithTime: _dateWithTime,
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
        dateWithTime: _dateWithTime,
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

    // ignore: unused_local_variable
    bool isDateTimeChanged = false;

    bool isOnStartDate = startOrEnd == 'start';

    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Material(
            type: MaterialType.transparency,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              var size = MediaQuery.of(context).size;
              List<DateTime?> dates = [_getStartDate(), _getEndDate()];
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(CardComponent.standardBorderRadius),
                    topRight:
                        Radius.circular(CardComponent.standardBorderRadius),
                  ),
                ),
                height: size.height * 0.6,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.all(SpaceComponent.standardHeight),
                      child: Row(
                        children: [
                          Expanded(
                              child: DateComponent(
                                  onTap: () => setModalState(() {
                                        isOnStartDate = true;
                                      }),
                                  isSelected: isOnStartDate,
                                  date: _getStartDate(),
                                  text: 'Start')),
                          const SpaceComponent(),
                          Expanded(
                              child: DateComponent(
                                  onTap: () => setModalState(() {
                                        isOnStartDate = false;
                                      }),
                                  isSelected: !isOnStartDate,
                                  date: _getEndDate(),
                                  text: 'End')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CalendarDatePicker2(
                        config: CalendarDatePicker2Config(
                            currentDate: TimeService.now(),
                            allowSameValueSelection: true,
                            calendarType: CalendarDatePicker2Type.range,
                            daySplashColor:
                                Theme.of(context).colorScheme.primary,
                            centerAlignModePicker: true,
                            hideMonthPickerDividers: true,
                            firstDayOfWeek: 1),
                        value: dates,
                        onValueChanged: (newDates) {
                          if (isOnStartDate) {
                            _setStartDate(newDates.last);
                          } else {
                            _setEndDate(newDates.last);
                          }

                          if (_getStartDate() != null &&
                              _getEndDate() != null &&
                              _getStartDate()!.isAfter(_getEndDate()!)) {
                            if (isOnStartDate) {
                              _setEndDate(null);
                            } else {
                              _setStartDate(null);
                            }
                          }

                          if (_getEndDate() != null &&
                              _getStartDate() == null) {
                            _setStartDate(_getEndDate());
                          }

                          isOnStartDate = !isOnStartDate;
                          setModalState(() {});
                        },
                      ),
                    ),
                    SpaceColumnComponent(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: CustomButtonComponent(
                                  onTap: () => {}, text: 'Cancel')),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          );
        });
  }

  // ignore: unused_element
  DateTime? _minimumDate(String startOrEnd, DateTime? initialDateTime) {
    if (startOrEnd == 'start') {
      if (widget.editChallenge != null) {
        return null;
      }
      if (widget.groupChallenge!.startDate == null) {
        return null;
      }
      return _getStartDate()?.isBefore(widget.groupChallenge!.startDate!) ??
              false
          ? null
          : widget.groupChallenge!.startDate;
    } else {
      if (widget.editChallenge != null) {
        return widget.editChallenge!.startDate;
      }
      return _getStartDate();
    }
  }

  // ignore: unused_element
  DateTime? _maximumDate(String startOrEnd) {
    if (startOrEnd == 'end') {
      if (widget.editChallenge != null) {
        return null;
      }
      if (widget.groupChallenge!.endDate == null) {
        return null;
      }
      return _getEndDate()?.isAfter(widget.groupChallenge!.endDate!) ?? false
          ? null
          : widget.groupChallenge!.endDate;
    } else {
      if (widget.editChallenge != null) {
        return widget.editChallenge!.endDate;
      }
      return _getEndDate();
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
    setState(() {
      if (!_dateWithTime && endDate != null) {
        endDate = UtilService.dateWithoutTime(endDate!);
      }
      if (widget.editChallenge != null) {
        widget.editChallenge!.endDate = endDate;
        return;
      }
      if (widget.editAttempt != null && widget.groupChallenge != null) {
        widget.editAttempt!.endDate = endDate;
      }
    });
  }

  _setStartDate(DateTime? startDate) {
    setState(() {
      if (widget.editChallenge != null) {
        widget.editChallenge!.startDate = startDate;
        return;
      }
      if (widget.editAttempt != null && widget.groupChallenge != null) {
        widget.editAttempt!.startDate = startDate;
      }
    });
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
