import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/bottom_buttons_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditDatesPage extends StatefulWidget {
  final ChallengeModel? challenge;
  final AttemptModel? attempt;
  final GroupChallengeModel? groupChallenge;

  const EditDatesPage.challenge({
    super.key,
    required this.challenge,
  })  : attempt = null,
        groupChallenge = null;

  const EditDatesPage.attempt({
    super.key,
    required this.attempt,
    required this.groupChallenge,
  }) : challenge = null;

  @override
  State<EditDatesPage> createState() => _EditDatesPageState();
}

class _EditDatesPageState extends State<EditDatesPage> {
  late final bool _isChallenge = widget.challenge != null;
  late final ChallengeModel? _editChallenge =
      _isChallenge ? widget.challenge!.copy() : null;
  late final AttemptModel? _editAttempt =
      !_isChallenge ? widget.attempt!.copy() : null;

  bool _isOnStart = true;
  bool _isOnTime = false;
  bool _isDatePickExpanded = true;
  late bool _isDateWithTime = _setIsDateWithTime();
  late final bool _isAmountVisible =
      _getFrequency().type == FrequencyTypeEnum.daily;
  late final bool _isAmountEditable = _isChallenge;

  late final TextEditingController _amountTextEditingController =
      TextEditingController(text: _getFrequency().amount?.toString());
  final FocusNode _amountFocusNode = FocusNode();

  final GlobalKey _datePickerKey = GlobalKey();
  late var _datePickerScrollController =
      PageController(initialPage: _getInitialPage());

  @override
  initState() {
    super.initState();

    _amountFocusNode.addListener(() {
      if (_amountFocusNode.hasFocus) {
        setState(() {
          _isDatePickExpanded = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _amountFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setIsDateWithTime();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          if (_isAmountVisible && _isAmountEditable) {
            _isDatePickExpanded = false;
          }
        });
      },
      child: ScaffoldComponent(
        appBar: const AppBarComponent(
          title: 'Edit Dates',
        ),
        isBottomNavigationVisible: false,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _amount(),
                  _pickerContainer(),
                ],
              ),
            ),
            _actionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _pickerContainer() {
    return SpaceColumnComponent(
      child: ListItemContainerComponent(
        padding: EdgeInsets.zero,
        isHeightDynamic: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_dates(), _datePicker(), _pickerActionButtons()],
        ),
      ),
    );
  }

  Widget _datePicker() {
    return Visibility(
      visible: _isDatePickExpanded,
      child: CalendarDatePicker2(
        key: _datePickerKey,
        config: CalendarDatePicker2Config(
          currentDate: TimeService.now(),
          allowSameValueSelection: true,
          firstDate: _getFirstDate(),
          lastDate: _getLastDate(),
          calendarType: CalendarDatePicker2Type.range,
          daySplashColor: Theme.of(context).colorScheme.primary,
          dayViewController: _getDatePickerScrollController(),
          centerAlignModePicker: true,
          hideMonthPickerDividers: true,
          hideYearPickerDividers: true,
          firstDayOfWeek: 1,
        ),
        value: [
          _getStartDate() == null && _getEndDate() != null
              ? _getEndDate()
              : _getStartDate(),
          _getEndDate()
        ],
        onValueChanged: _onValueChanged,
      ),
    );
  }

  Widget _dates() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: ListItemContainerComponent.standardPadding,
            top: ListItemContainerComponent.standardPadding,
            bottom: _isDatePickExpanded
                ? 0
                : ListItemContainerComponent.standardPadding,
          ),
          child: IconContainerInListItemComponent(icon: IconEnum.dates.icon),
        ),
        _date(isStart: true),
        _date(isStart: false)
      ],
    );
  }

  Expanded _date({required bool isStart}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (!_isChallenge &&
                _getFrequency().type == FrequencyTypeEnum.daily &&
                _getFrequency().amount == null) {
              return;
            }
            _isOnStart = isStart;
            _isDatePickExpanded = true;
            _amountFocusNode.unfocus();
            if (isStart && _getStartDate() == null) {
              _isOnTime = false;
            } else if (!isStart && _getEndDate() == null) {
              _isOnTime = false;
            }
          });
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceComponent(
                height: 5,
              ),
              Text(
                isStart ? 'Start Date' : 'End Date',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize:
                          Theme.of(context).textTheme.labelSmall?.fontSize,
                      color: _isDatePickExpanded
                          ? isStart == _isOnStart
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.tertiary,
                    ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    UtilService.dateFormat(
                        isStart ? _getStartDate() : _getEndDate()),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _isDatePickExpanded
                              ? isStart == _isOnStart
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  Text(
                    _isDateWithTime
                        ? UtilService.timeFormat(
                            isStart ? _getStartDate() : _getEndDate())
                        : ' ', // to prevent jumping
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _isDatePickExpanded
                              ? isStart == _isOnStart
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pickerActionButtons() {
    return Visibility(
      visible: _isDatePickExpanded,
      child: Row(
        children: [
          Expanded(
            child: CustomButtonComponent(
              onTap: _onTapReset,
              text: 'Reset',
              margin: const EdgeInsets.only(
                left: CardComponent.standardPadding,
                right: CardComponent.standardPadding / 2,
                bottom: CardComponent.standardPadding,
              ),
            ),
          ),
          Expanded(
            child: CustomButtonComponent(
              onTap: _onTapToday,
              text: 'Today',
              margin: const EdgeInsets.only(
                left: CardComponent.standardPadding / 2,
                right: CardComponent.standardPadding,
                bottom: CardComponent.standardPadding,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapReset() {
    setState(() {
      if (_isOnTime) {
        if (_getFrequency().type == FrequencyTypeEnum.daily) {
          _setStartDate(_getStartDate() != null
              ? UtilService.dateWithoutTime(_getStartDate()!)
              : null);
          _setEndDate(_getEndDate() != null
              ? UtilService.dateWithoutTime(_getEndDate()!)
              : null);
        } else if (_isOnStart && _getStartDate() != null) {
          _setStartDate(UtilService.dateWithoutTime(_getStartDate()!));
        } else if (!_isOnStart && _getEndDate() != null) {
          _setEndDate(UtilService.dateWithoutTime(_getEndDate()!));
        }
        return;
      }

      if (_isOnStart) {
        _setStartDate(null);
      } else {
        _setEndDate(null);
      }
      if (_getFrequency().type == FrequencyTypeEnum.daily) {
        _calcFrequencyAmount();
      }
    });
  }

  _actionButtons() {
    return BottomButtonsComponent(buttons: [
      ListItemButtonComponent(
        onTap: _onTapCancel,
        text: 'Cancel',
        isMainButton: false,
        margin: EdgeInsets.zero,
      ),
      ListItemButtonComponent(
        onTap: _onTapAccept,
        text: 'Accept',
        isMainButton: true,
        margin: EdgeInsets.zero,
      ),
    ]);
  }

  void _onValueChanged(List<DateTime?> newDates) {
    if (_isOnStart) {
      DateTime? startDate = _getStartDate();
      Duration timeDifference =
          startDate?.difference(UtilService.dateWithoutTime(startDate)) ??
              const Duration();
      _setStartDate(newDates.last?.add(timeDifference));
      if (_getFrequency().type == FrequencyTypeEnum.time ||
          _getFrequency().amount == null) {
        _isOnStart = false;
      }
    } else {
      DateTime? endDate = _getEndDate();
      Duration timeDifference =
          endDate?.difference(UtilService.dateWithoutTime(endDate)) ??
              const Duration();
      _setEndDate(newDates.last?.add(timeDifference));
    }
    if (_getStartDate() != null && _getEndDate() != null) {
      if (_isOnStart && _getStartDate()!.isAfter(_getEndDate()!)) {
        _setEndDate(_getStartDate());
      } else if (!_isOnStart && _getEndDate()!.isBefore(_getStartDate()!)) {
        _setStartDate(_getEndDate());
      }
    }
  }

  DateTime? _getStartDate() {
    return _isChallenge
        ? _editChallenge!.startDate
        : _editAttempt!.getStartDate(widget.groupChallenge!);
  }

  DateTime? _getEndDate() {
    return _isChallenge
        ? _editChallenge!.endDate
        : _editAttempt!.getEndDate(widget.groupChallenge!);
  }

  FrequencyModel _getFrequency() {
    return _isChallenge
        ? _editChallenge!.frequency
        : _editAttempt!.getFrequency(widget.groupChallenge!);
  }

  void _setStartDate(DateTime? date) {
    setState(() {
      if (_isChallenge) {
        _editChallenge!.startDate = date;
      } else {
        if (widget.groupChallenge != null &&
            widget.groupChallenge!.startDate != null &&
            date != null &&
            date.isBefore(widget.groupChallenge!.startDate!)) {
          _editAttempt!.startDate = widget.groupChallenge!.startDate;
        } else {
          _editAttempt!.startDate = date;
        }
      }
      if (_getFrequency().type == FrequencyTypeEnum.daily &&
          _getFrequency().amount == null) {
        _calcFrequencyAmount();
      }
      _calcEndDate();
    });
  }

  void _setEndDate(DateTime? date) {
    setState(() {
      if (_isChallenge) {
        _editChallenge!.endDate = date;
      } else {
        if (widget.groupChallenge != null &&
            widget.groupChallenge!.endDate != null &&
            date != null &&
            date.isAfter(widget.groupChallenge!.endDate!)) {
          _editAttempt!.endDate = widget.groupChallenge!.endDate;
        } else {
          _editAttempt!.endDate = date;
        }
      }
      if (_getFrequency().type == FrequencyTypeEnum.daily &&
          _getFrequency().amount == null) {
        _calcFrequencyAmount();
        // return;
      }
      _calcStartDate();
    });
  }

  void _calcEndDate() {
    if (_isChallenge) {
      _editChallenge!.calcEndDate();
    } else {
      _editAttempt!.calcEndDate(widget.groupChallenge!);
    }
  }

  void _calcStartDate() {
    if (_isChallenge) {
      _editChallenge!.calcStartDate();
    } else {
      _editAttempt!.calcStartDate(widget.groupChallenge!);
    }
  }

  DateTime? _getFirstDate() {
    if (_isChallenge) {
      return null;
    }

    if (_isOnStart) {
      return widget.groupChallenge!.startDate;
    }

    if (!_isOnStart) {
      FrequencyModel frequency = _getFrequency();
      if (frequency.type == FrequencyTypeEnum.daily &&
          frequency.amount != null) {
        return widget.groupChallenge?.startDate
            ?.add(Duration(days: frequency.amount!));
      }
      return widget.groupChallenge?.startDate;
    }

    if (widget.groupChallenge!.startDate == null) {
      return null;
    }
    return widget.attempt?.startDate
                ?.isBefore(widget.groupChallenge!.startDate!) ??
            false
        ? null
        : widget.groupChallenge!.startDate;
  }

  DateTime? _getLastDate() {
    if (_isChallenge) {
      return null;
    }

    if (_isOnStart) {
      FrequencyModel frequency = _getFrequency();
      if (frequency.type == FrequencyTypeEnum.daily &&
          frequency.amount != null) {
        return widget.groupChallenge?.endDate
            ?.subtract(Duration(days: frequency.amount!));
      }
      return widget.groupChallenge?.endDate;
    }

    if (widget.groupChallenge!.endDate == null) {
      return null;
    }
    return widget.attempt!.endDate?.isAfter(widget.groupChallenge!.endDate!) ??
            false
        ? null
        : widget.groupChallenge!.endDate;
  }

  _amount() {
    return Visibility(
      visible: _isAmountVisible,
      child: SpaceColumnComponent(
        child: ListItemIconTextInputComponent(
          isEnabled: _isAmountEditable,
          icon: IconEnum.numbers.icon,
          textEditingController: _amountTextEditingController,
          focusNode: _amountFocusNode,
          keyboardType: const TextInputType.numberWithOptions(),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[1-9]+[0-9]*')),
          ],
          onChangeTextField: (value) {
            setState(() {
              if (value.isEmpty) {
                _getFrequency().amount = null;
                _calcEndDate();
                return;
              }
              _getFrequency().amount = int.parse(value);
              _calcEndDate();
            });
          },
          onSubmitted: (_) {
            _onTapAccept();
          },
          textInputAction: TextInputAction.next,
          labelText: 'Day Amount',
          hintText: 'max.',
          infoText: 'How many days do you want to do this challenge?',
          maxLength: DatabaseService.maxFrequencyAmountLength,
          removeActionIcon: true,
        ),
      ),
    );
  }

  void _onTapAccept() {
    if (_isChallenge) {
      widget.challenge!.startDate = _editChallenge!.startDate;
      widget.challenge!.endDate = _editChallenge!.endDate;
      widget.challenge!.frequency.amount = _getFrequency().amount;
    } else {
      widget.attempt!.startDate = _editAttempt!.startDate;
      widget.attempt!.endDate = _editAttempt!.endDate;
    }
    Navigator.of(context).pop();
  }

  void _onTapCancel() {
    Navigator.of(context).pop();
  }

  void _calcFrequencyAmount() {
    if (_isChallenge) {
      _editChallenge!.setFrequencyAmount();
    } else {
      _editAttempt!.setFrequencyAmount(widget.groupChallenge!);
    }
    _amountTextEditingController.text =
        _getFrequency().amount?.toString() ?? '';
  }

  _setIsDateWithTime() {
    _isDateWithTime = _getStartDate() != null &&
            _getStartDate()!
                    .difference(UtilService.dateWithoutTime(_getStartDate()!))
                    .inSeconds !=
                0 ||
        _getEndDate() != null &&
            _getEndDate()!
                    .difference(UtilService.dateWithoutTime(_getEndDate()!))
                    .inSeconds !=
                0;
    _isDateWithTime = _isDateWithTime || _isOnTime;
    return _isDateWithTime;
  }

  void _onTapToday() {
    _datePickerScrollController.animateToPage(
      _getInitialPage(),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  int _getInitialPage() {
    final firstDate = _getFirstDate();
    final firstDateYear = firstDate?.year ?? 1970;
    final firstDateMonth = firstDate?.month ?? 1;
    final today = TimeService.now();
    final todayYear = today.year;
    final todayMonth = today.month;

    final yearDifference = todayYear - firstDateYear;
    final monthDifference = todayMonth - firstDateMonth;

    return yearDifference * 12 + monthDifference;
  }

  _getDatePickerScrollController() {
    if (_datePickerScrollController.hasClients) {
      return _datePickerScrollController;
    }
    _datePickerScrollController =
        PageController(initialPage: _getInitialPage());
    return _datePickerScrollController;
  }
}
