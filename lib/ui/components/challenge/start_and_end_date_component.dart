import 'dart:async';

import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
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
  late Timer _timer;

  @override
  initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _setIsDateWithTime();
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(CustomContainerComponent.standardRadius),
      child: SizedBox(
        height: CustomContainerComponent.standardHeight,
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: _calcDateProgress(),
              heightFactor: 1,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.themeColor4,
                    borderRadius: const BorderRadius.all(Radius.circular(
                        CustomContainerComponent.standardRadius))),
              ),
            ),
            CustomContainerComponent(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                  horizontal: CustomContainerComponent.standardPadding),
              child: _startAndEndDates(),
            ),
          ],
        ),
      ),
    );
  }

  _startAndEndDates() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              'Start',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Expanded(child: SizedBox()),
            Text(
              _getStartDate() == null
                  ? '-'
                  : '${UtilService.dateFormat(_getStartDate()!)} ${_isDateWithTime ? ' ${UtilService.timeFormat(_getStartDate()!)}' : ''}',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          children: [
            Text(
              'End',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Expanded(child: SizedBox()),
            Text(
              _getEndDate() == null
                  ? '-'
                  : '${UtilService.dateFormat(_getEndDate()!)} ${_isDateWithTime ? ' ${UtilService.timeFormat(_getEndDate()!)}' : ''}',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      ],
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
      if (_timer.isActive) {
        widget.reloadParentPage?.call();
        _timer.cancel();
      }
      return 1.0;
    }

    return (now - startDate) / (endDate - startDate);
  }
}
