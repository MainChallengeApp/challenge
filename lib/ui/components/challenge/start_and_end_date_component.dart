import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

class StartAndEndDateComponent extends StatefulWidget {
  final ChallengeModel? editChallenge;
  final AttemptModel? editAttempt;
  final GroupChallengeModel? groupChallenge;
  final Function? reloadParentPage;

  const StartAndEndDateComponent.challenge(
      {super.key, required this.editChallenge, this.reloadParentPage})
      : editAttempt = null,
        groupChallenge = null;

  const StartAndEndDateComponent.attempt(
      {super.key,
      required this.editAttempt,
      required this.groupChallenge,
      this.reloadParentPage})
      : editChallenge = null;

  @override
  State<StartAndEndDateComponent> createState() =>
      _StartAndEndDateComponentState();
}

class _StartAndEndDateComponentState extends State<StartAndEndDateComponent> {
  bool _isDateWithTime = false;

  @override
  Widget build(BuildContext context) {
    _setIsDateWithTime();
    return CustomContainerComponent(
      child: Column(
        children: [
          _startAndEndDates(),
          const SpaceComponent(height: 5),
          _dateProgress()
        ],
      ),
    );
  }

  Row _startAndEndDates() {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(_getStartDate() == null
                ? '-'
                : '${UtilService.dateFormat(_getStartDate()!)} ${_isDateWithTime ? ' ${UtilService.timeFormat(_getStartDate()!)}' : ''}'),
          ),
        ),
        const Text('-'),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(_getEndDate() == null
                ? '-'
                : '${UtilService.dateFormat(_getEndDate()!)} ${_isDateWithTime ? ' ${UtilService.timeFormat(_getEndDate()!)}' : ''}'),
          ),
        ),
      ],
    );
  }

  Container _dateProgress() {
    return Container(
      width: double.infinity,
      height: 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
            width: 1,
            strokeAlign: BorderSide.strokeAlignInside),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: _calcDateProgress(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  bool _setIsDateWithTime() {
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
    return _isDateWithTime;
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

  _calcDateProgress() {
    if (_getStartDate() != null &&
        _getEndDate() == null &&
        _getStartDate()!.isBefore(TimeService.now())) {
      return 0.25;
    }

    if (_getStartDate() == null || _getEndDate() == null) {
      return 0.0;
    }
    final startDate = _getStartDate()!.millisecondsSinceEpoch;
    final endDate = _getEndDate()!.millisecondsSinceEpoch;
    final now = TimeService.now().millisecondsSinceEpoch;
    if (now < startDate) {
      return 0.0;
    }
    if (now > endDate) {
      return 1.0;
    }
    return (now - startDate) / (endDate - startDate);
  }
}
