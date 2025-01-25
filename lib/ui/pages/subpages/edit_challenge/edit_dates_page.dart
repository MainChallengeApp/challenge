import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditDatesPage extends StatefulWidget {
  final ChallengeModel challenge;

  const EditDatesPage({
    Key? key,
    required this.challenge,
  }) : super(key: key);

  @override
  State<EditDatesPage> createState() => _EditDatesPageState();
}

class _EditDatesPageState extends State<EditDatesPage> {
  late final ChallengeModel _editChallenge = widget.challenge.copy();
  bool _isOnStart = true;
  bool _isDatePickExpanded = true;
  late final bool _isAmountVisible =
      _editChallenge.frequency.type == FrequencyTypeEnum.daily;

  late final TextEditingController _amountTextEditingController =
      TextEditingController(text: _editChallenge.frequency.amount?.toString());
  final FocusNode _amountFocusNode = FocusNode();

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          if (_isAmountVisible) {
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
                  _datePickerContainer(),
                ],
              ),
            ),
            _actionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _datePickerContainer() {
    return SpaceColumnComponent(
      child: ListItemContainerComponent(
        padding: EdgeInsets.zero,
        isHeightDynamic: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_dates(), _datePicker(), _resetButton()],
        ),
      ),
    );
  }

  Widget _datePicker() {
    return Visibility(
      visible: _isDatePickExpanded,
      child: CalendarDatePicker2(
        config: CalendarDatePicker2Config(
          currentDate: TimeService.now(),
          allowSameValueSelection: true,
          firstDate: _getFirstDate(),
          lastDate: _getLastDate(),
          calendarType: CalendarDatePicker2Type.range,
          daySplashColor: Theme.of(context).colorScheme.primary,
          monthViewController: ScrollController(),
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
            _isOnStart = isStart;
            _isDatePickExpanded = true;
            _amountFocusNode.unfocus();
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _resetButton() {
    return Visibility(
      visible: _isDatePickExpanded,
      child: CustomButtonComponent(
        onTap: () {
          setState(() {
            if (_isOnStart) {
              _setStartDate(null);
            } else {
              _setEndDate(null);
            }
            if (_editChallenge.frequency.type == FrequencyTypeEnum.daily) {
              _editChallenge.frequency.amount = null;
              _amountTextEditingController.text = '';
            }
          });
        },
        text: 'Reset',
        margin: const EdgeInsets.all(CardComponent.standardPadding),
      ),
    );
  }

  SpaceColumnComponent _actionButtons() {
    return SpaceColumnComponent(
      height: BottomNavigationComponent.standardMargin,
      isSpaceOnTop: true,
      child: Row(
        children: [
          const SpaceComponent(
            width: ListItemContainerComponent.standardMargin,
          ),
          Expanded(
            child: ListItemButtonComponent(
              onTap: _onTapCancel,
              text: 'Cancel',
              isMainButton: false,
              margin: EdgeInsets.zero,
            ),
          ),
          const SpaceComponent(),
          Expanded(
            child: ListItemButtonComponent(
              margin: EdgeInsets.zero,
              onTap: _onTapAccept,
              text: 'Accept',
            ),
          ),
          const SpaceComponent(
            width: ListItemContainerComponent.standardMargin,
          ),
        ],
      ),
    );
  }

  void _onValueChanged(List<DateTime?> newDates) {
    if (_isOnStart) {
      _setStartDate(newDates.last);
    } else {
      _setEndDate(newDates.last);
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
    return _editChallenge.startDate;
  }

  DateTime? _getEndDate() {
    return _editChallenge.endDate;
  }

  void _setStartDate(DateTime? date) {
    setState(() {
      _editChallenge.startDate = date;
      if (_editChallenge.frequency.type == FrequencyTypeEnum.daily &&
          _editChallenge.frequency.amount == null) {
        _calcFrequencyAmount();
        return;
      }
      _calcEndDate();
    });
  }

  void _setEndDate(DateTime? date) {
    setState(() {
      _editChallenge.endDate = date;
      if (_editChallenge.frequency.type == FrequencyTypeEnum.daily &&
          _editChallenge.frequency.amount == null) {
        _calcFrequencyAmount();
        return;
      }
      _calcStartDate();
    });
  }

  void _calcEndDate() {
    _editChallenge.calcEndDate();
  }

  void _calcStartDate() {
    _editChallenge.calcStartDate();
  }

  DateTime? _getFirstDate() {
    return null; // You can set a minimum date if needed
  }

  DateTime? _getLastDate() {
    return null; // You can set a maximum date if needed
  }

  _amount() {
    return Visibility(
      visible: _isAmountVisible,
      child: SpaceColumnComponent(
        child: ListItemIconTextInputComponent(
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
                _editChallenge.frequency.amount = null;
                _editChallenge.calcEndDate();
                return;
              }
              _editChallenge.frequency.amount = int.parse(value);
              _editChallenge.calcEndDate();
            });
          },
          onSubmitted: (_) {
            _onTapAccept();
          },
          textInputAction: TextInputAction.next,
          lableText: 'Day Amount',
          hintText: 'max.',
          maxLength: DatabaseService.maxFrequencyAmountLength,
          removeActionIcon: true,
        ),
      ),
    );
  }

  void _onTapAccept() {
    widget.challenge.startDate = _editChallenge.startDate;
    widget.challenge.endDate = _editChallenge.endDate;
    widget.challenge.frequency.amount = _editChallenge.frequency.amount;
    Navigator.of(context).pop();
  }

  void _onTapCancel() {
    Navigator.of(context).pop();
  }

  void _calcFrequencyAmount() {
    _editChallenge.setFrequencyAmount();
    _amountTextEditingController.text =
        _editChallenge.frequency.amount?.toString() ?? '';
  }
}
