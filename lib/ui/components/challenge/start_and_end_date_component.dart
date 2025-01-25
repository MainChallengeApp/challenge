import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/challenge/date_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/small_container_in_container_text_component.dart';
import 'package:challenge/ui/components/simple_components/small_container_in_list_item_component.dart';
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
  late final AttemptModel? _originalAttempt = widget.editAttempt?.copy();
  late final DateTime? _originalEndDate = _getEndDate();
  late final DateTime? _originalStartDate = _getStartDate();

  @override
  Widget build(BuildContext context) {
    _dateWithTime = _getStartDate() != null &&
            _getStartDate()!
                    .difference(UtilService.dateWithoutTime(_getStartDate()!))
                    .inSeconds !=
                0 ||
        _getEndDate() != null &&
            _getEndDate()!
                    .difference(UtilService.dateWithoutTime(_getEndDate()!))
                    .inSeconds !=
                0;
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

  _getFirstDate(bool isOnStartDate) {
    DateTime firstDate = _minimumDate(isOnStartDate) ?? DateTime(1970, 1, 1);
    return firstDate;
  }

  void onTapStartOrEndDate(String startOrEnd) async {
    if (widget.isLocked) return;

    bool isOnStartDate = startOrEnd == 'start';
    bool isOnTime = false;
    Map<bool, PageController?> dayViewControllers = {};

    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Material(
            type: MaterialType.transparency,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              var size = MediaQuery.of(context).size;
              List<DateTime?> dates = [
                _getStartDate() == null && _getEndDate() != null
                    ? _getEndDate()
                    : _getStartDate(),
                _getEndDate()
              ];

              // Function to create or recreate the PageController
              PageController createPageController() {
                int monthsBetween = _monthsBetween(
                    _getFirstDate(isOnStartDate),
                    isOnStartDate
                        ? _getStartDate() ?? TimeService.now()
                        : _getEndDate() ?? TimeService.now());
                dayViewControllers[isOnStartDate] = PageController(
                  initialPage: monthsBetween,
                );
                return dayViewControllers[isOnStartDate]!;
              }

              // Create the PageController initially if not on time
              if (dayViewControllers[isOnStartDate] == null ||
                  !dayViewControllers[isOnStartDate]!.hasClients) {
                createPageController();
              }

              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft:
                        Radius.circular(CardComponent.standardBorderRadius),
                    topRight:
                        Radius.circular(CardComponent.standardBorderRadius),
                  ),
                ),
                height: size.height * 0.63,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: BottomNavigationComponent.standardMargin,
                          right: BottomNavigationComponent.standardMargin,
                          top: BottomNavigationComponent.standardMargin),
                      child: Row(
                        children: [
                          Expanded(
                              child: DateComponent(
                                  onTap: () {
                                    if (isOnStartDate &&
                                        _getStartDate() != null) {
                                      if (isOnTime) {
                                        isOnTime = false;
                                      } else {
                                        int monthsBetween = _monthsBetween(
                                            _getFirstDate(isOnStartDate),
                                            _getStartDate()!);
                                        if (dayViewControllers[isOnStartDate] !=
                                                null &&
                                            dayViewControllers[isOnStartDate]!
                                                .hasClients) {
                                          dayViewControllers[isOnStartDate]
                                              ?.animateToPage(monthsBetween,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease);
                                        }
                                      }
                                    }
                                    setModalState(() {
                                      isOnStartDate = true;
                                      if (_getStartDate() == null) {
                                        isOnTime = false;
                                      }
                                    });
                                  },
                                  isSelected: isOnStartDate,
                                  textColor: isOnStartDate
                                      ? Colors.black
                                      : Theme.of(context).colorScheme.tertiary,
                                  date: _getStartDate(),
                                  text: 'Start')),
                          const SpaceComponent(),
                          Expanded(
                              child: DateComponent(
                                  onTap: () {
                                    if (!isOnStartDate &&
                                        _getEndDate() != null) {
                                      if (isOnTime) {
                                        isOnTime = false;
                                      } else {
                                        int monthsBetween = _monthsBetween(
                                            _getFirstDate(isOnStartDate),
                                            _getEndDate()!);
                                        if (dayViewControllers[isOnStartDate] !=
                                                null &&
                                            dayViewControllers[isOnStartDate]!
                                                .hasClients) {
                                          dayViewControllers[isOnStartDate]
                                              ?.animateToPage(monthsBetween,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease);
                                        }
                                      }
                                    }
                                    setModalState(() {
                                      isOnStartDate = false;
                                      if (_getEndDate() == null) {
                                        isOnTime = false;
                                      }
                                    });

                                    // dumb workaround to jump to the right month page
                                    // TODO add for start date component (somehow not necessary)
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (!isOnStartDate &&
                                          _getEndDate() != null) {
                                        int monthsBetween = _monthsBetween(
                                            _getFirstDate(!isOnStartDate),
                                            _getEndDate()!);
                                        if (dayViewControllers[false] != null &&
                                            dayViewControllers[false]!
                                                .hasClients) {
                                          dayViewControllers[false]
                                              ?.jumpToPage(monthsBetween - 1);
                                        }
                                      }
                                      if (!isOnStartDate &&
                                          _getEndDate() != null) {
                                        int monthsBetween = _monthsBetween(
                                            _getFirstDate(!isOnStartDate),
                                            _getEndDate()!);
                                        if (dayViewControllers[false] != null &&
                                            dayViewControllers[false]!
                                                .hasClients) {
                                          dayViewControllers[false]
                                              ?.jumpToPage(monthsBetween);
                                        }
                                      }
                                    });
                                  },
                                  isSelected: !isOnStartDate,
                                  textColor: !isOnStartDate
                                      ? Colors.black
                                      : Theme.of(context).colorScheme.tertiary,
                                  date: _getEndDate(),
                                  text: 'End')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: isOnTime
                          ? CupertinoDatePicker(
                              key: ValueKey(isOnStartDate),
                              mode: CupertinoDatePickerMode.time,
                              use24hFormat: true,
                              maximumDate: _maximumDate(isOnStartDate),
                              minimumDate: _minimumDate(isOnStartDate),
                              initialDateTime: isOnStartDate
                                  ? _getStartDate() ?? TimeService.now()
                                  : _getEndDate() ?? TimeService.now(),
                              onDateTimeChanged: (DateTime newDateTime) {
                                if (isOnStartDate) {
                                  _setStartDate(newDateTime);
                                } else {
                                  _setEndDate(newDateTime);
                                }
                                setModalState(() {});
                              },
                            )
                          : CalendarDatePicker2(
                              key: ValueKey(isOnStartDate),
                              config: CalendarDatePicker2Config(
                                  currentDate: TimeService.now(),
                                  allowSameValueSelection: true,
                                  firstDate: _getFirstDate(isOnStartDate),
                                  lastDate: _maximumDate(isOnStartDate),
                                  calendarType: CalendarDatePicker2Type.range,
                                  daySplashColor:
                                      Theme.of(context).colorScheme.primary,
                                  monthViewController: ScrollController(),
                                  centerAlignModePicker: true,
                                  hideMonthPickerDividers: true,
                                  hideYearPickerDividers: true,
                                  dayViewController:
                                      dayViewControllers[isOnStartDate] ??
                                          createPageController(),
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

                                setModalState(() {});
                              },
                            ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          isOnTime = !isOnTime;
                          // if (isOnTime) {
                          //   // Dispose of the PageController when switching to time picker
                          //   dayViewController?.dispose();
                          //   dayViewController = null;
                          // }
                          setModalState(() {});
                        },
                        child: SizedBox(
                          height: SmallContainerInListItemComponent.height,
                          child: Visibility(
                            visible: isOnStartDate && _getStartDate() != null ||
                                !isOnStartDate && _getEndDate() != null,
                            child: SmallContainerInContainerTextComponent(
                              text: isOnTime
                                  ? isOnStartDate
                                      ? UtilService.dateFormat(_getStartDate())
                                      : UtilService.dateFormat(_getEndDate())
                                  : isOnStartDate
                                      ? UtilService.timeFormat(_getStartDate())
                                      : UtilService.timeFormat(_getEndDate()),
                              margin: const EdgeInsets.only(
                                  right:
                                      BottomNavigationComponent.standardMargin),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: SpaceComponent.standardHeight,
                          bottom: BottomNavigationComponent.standardMargin),
                      child: ListItemButtonComponent(
                          isMainButton: false,
                          onTap: () {
                            if (isOnStartDate) {
                              _setStartDate(null);
                            } else {
                              _setEndDate(null);
                            }
                            setModalState(() {});
                          },
                          text: 'Reset'),
                    )
                  ],
                ),
              );
            }),
          );
        }).then((_) {
      widget.reloadParentPage?.call();
    });
  }

  DateTime? _minimumDate(bool isOnStartDate) {
    if (widget.editChallenge != null) {
      return null;
    }

    if (!isOnStartDate) {
      FrequencyModel frequency =
          widget.editAttempt!.getFrequency(widget.groupChallenge!);
      if (frequency.type == FrequencyTypeEnum.daily &&
          frequency.amount != null) {
        return _originalStartDate?.add(Duration(days: frequency.amount!));
      }
      return _originalStartDate;
    }

    if (widget.groupChallenge!.startDate == null) {
      return null;
    }
    return _originalAttempt?.startDate
                ?.isBefore(widget.groupChallenge!.startDate!) ??
            false
        ? null
        : widget.groupChallenge!.startDate;
  }

  DateTime? _maximumDate(bool isOnStartDate) {
    if (widget.editChallenge != null) {
      return null;
    }

    if (isOnStartDate) {
      FrequencyModel frequency =
          widget.editAttempt!.getFrequency(widget.groupChallenge!);
      if (frequency.type == FrequencyTypeEnum.daily &&
          frequency.amount != null) {
        return _originalEndDate?.subtract(Duration(days: frequency.amount!));
      }
      return _originalEndDate;
    }

    if (widget.groupChallenge!.endDate == null) {
      return null;
    }
    return _originalAttempt?.endDate
                ?.isAfter(widget.groupChallenge!.endDate!) ??
            false
        ? null
        : widget.groupChallenge!.endDate;
  }

  void _calcEndDate() {
    if (widget.editChallenge != null) {
      widget.editChallenge!.calcEndDate();
      return;
    }
    if (widget.editAttempt != null && widget.groupChallenge != null) {
      widget.editAttempt!.setEndDate(widget.groupChallenge!);
    }
  }

  void _calcStartDate() {
    if (widget.editChallenge != null) {
      widget.editChallenge!.calcStartDate();
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
      if (widget.editChallenge != null) {
        widget.editChallenge!.endDate = endDate;
        _calcStartDate();
        return;
      }
      if (widget.editAttempt != null && widget.groupChallenge != null) {
        widget.editAttempt!.endDate = endDate;
        _calcStartDate();
      }
    });
  }

  _setStartDate(DateTime? startDate) {
    setState(() {
      if (widget.editChallenge != null) {
        widget.editChallenge!.startDate = startDate;
        _calcEndDate();
        return;
      }
      if (widget.editAttempt != null && widget.groupChallenge != null) {
        widget.editAttempt!.startDate = startDate;
        _calcEndDate();
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

  int _monthsBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.year - from.year) * 12 + to.month - from.month;
  }
}
