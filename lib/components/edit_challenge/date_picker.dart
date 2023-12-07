// ignore_for_file: must_be_immutable

import 'package:challenge/models/challenge.dart';
import 'package:flutter/material.dart';

class DatePickerExample extends StatefulWidget {
  DatePickerExample(
      {super.key,
      this.restorationId,
      required this.initialDate,
      required this.editChallenge,
      required this.isStartDate,
      this.isActualEmpty = false});

  final String? restorationId;
  DateTime initialDate;
  final Challenge editChallenge;
  final bool isStartDate;
  bool isActualEmpty;

  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

/// RestorationProperty objects can be used because of RestorationMixin.
class _DatePickerExampleState extends State<DatePickerExample>
    with RestorationMixin {
  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => widget.restorationId;
  static DateTime staticInitDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = RestorableDateTime(widget.initialDate);
  }

  late final RestorableDateTime _selectedDate;
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      staticInitDate = widget.initialDate;
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendar,
          initialDate: staticInitDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(9999),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        widget.initialDate = newSelectedDate;
        widget.isActualEmpty = false;
        if (widget.isStartDate) {
          widget.editChallenge.startDate = newSelectedDate;
        } else {
          widget.editChallenge.endDate = newSelectedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: () => _restorableDatePickerRouteFuture.present(),
          child: widget.isActualEmpty
              ? const Text(
                  '                         -') // extra space so the user can click next to the -
              : Text(
                  '${_selectedDate.value.day}.${_selectedDate.value.month}.${_selectedDate.value.year}')),
    );
  }
}
