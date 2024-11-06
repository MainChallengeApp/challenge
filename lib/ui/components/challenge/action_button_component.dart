import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:flutter/material.dart';

class ActionButtonComponent extends StatefulWidget {
  final AttemptModel attempt;
  final Function(AttemptModel) onTapStart;
  final Function(AttemptModel) onTapEnd;
  final Function() onTapAgain;
  final Function(AttemptModel) onTapNext;
  final GroupChallengeModel groupChallenge;

  const ActionButtonComponent({
    super.key,
    required this.attempt,
    required this.onTapStart,
    required this.onTapEnd,
    required this.onTapAgain,
    required this.onTapNext,
    required this.groupChallenge,
  });

  @override
  State<ActionButtonComponent> createState() => _ActionButtonComponentState();
}

class _ActionButtonComponentState extends State<ActionButtonComponent> {
  late FrequencyModel frequency =
      widget.attempt.getFrequency(widget.groupChallenge);

  bool _loading = false;

  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    TimeService.now().then((value) {
      if (mounted) {
        setState(() {
          now = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldShowStartButton()) {
      return _buildStartButton();
    } else if (_shouldShowNextButton()) {
      return _buildNextButton();
    } else if (_shouldShowEndButton()) {
      return _buildEndButton();
    } else if (_shouldShowAcceptAgainButton()) {
      return _buildAcceptAgainButton();
    } else if (_shouldShowTryAgainButton()) {
      return _buildTryAgainButton();
    } else {
      return _buildNextButton();
    }
  }

  bool _shouldShowStartButton() {
    if (widget.attempt.isInBacklog()) {
      return true;
    }
    if (widget.attempt.getCurrentRepetition(widget.groupChallenge, now: now) ==
            null &&
        widget.attempt.isInProgress()) {
      return true;
    } else {
      widget.attempt
          .getCurrentRepetition(widget.groupChallenge, now: now)
          ?.evaluateRepetitionStatus(now: now);
      return (widget.attempt
                  .getCurrentRepetition(widget.groupChallenge, now: now)
                  ?.isInBacklog() ??
              false) &&
          frequency.type == FrequencyTypeEnum.time;
    }
  }

  Widget _buildStartButton() {
    return CustomButtonComponent(
      onTap: () async {
        if (_loading) {
          return;
        }
        setState(() {
          _loading = true;
        });
        await widget.onTapStart(widget.attempt);
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      },
      text: 'Start',
      isPrimaryButton: true,
      isLoading: _loading,
    );
  }

  bool _shouldShowEndButton() {
    if (!widget.attempt.isInProgress()) {
      return false;
    }

    return (widget.attempt.getCurrentRepetition(widget.groupChallenge) !=
                        null &&
                    widget.attempt
                        .getCurrentRepetition(widget.groupChallenge)!
                        .progressList
                        .isEmpty ||
                widget.attempt
                        .getCurrentRepetitionNumber(widget.groupChallenge) ==
                    frequency.getMaxAmountOfRepetitions()) &&
            widget.attempt.isInProgress() ||
        widget.attempt.getCurrentRepetition(widget.groupChallenge) != null &&
            widget.attempt
                .getCurrentRepetition(widget.groupChallenge)!
                .isInProgress();
  }

  bool _shouldShowNextButton() {
    if (!widget.attempt.isInProgress()) {
      return false;
    }

    if (widget.attempt
            .getCurrentRepetitionNumber(widget.groupChallenge, now: now) ==
        widget.attempt
            .getFrequency(widget.groupChallenge)
            .getMaxAmountOfRepetitions()) {
      return false;
    }

    if (widget.attempt.getFrequency(widget.groupChallenge).type ==
            FrequencyTypeEnum.daily ||
        widget.attempt.getFrequency(widget.groupChallenge).type ==
            FrequencyTypeEnum.weekday) {
      return false;
    }

    return widget.attempt
            .getCurrentRepetition(widget.groupChallenge, now: now)
            ?.progressList
            .isNotEmpty ??
        false;
  }

  Widget _buildNextButton() {
    return CustomButtonComponent(
      onTap: () async {
        if (_loading) {
          return;
        }
        setState(() {
          _loading = true;
        });
        await widget.onTapNext(widget.attempt);

        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      },
      isPrimaryButton: (widget.attempt
                  .getCurrentRepetition(widget.groupChallenge, now: now)
                  ?.isComplete() ??
              false) &&
          frequency.type == FrequencyTypeEnum.time,
      text: frequency.type == FrequencyTypeEnum.time
          ? 'Next'
          : 'Next in ${widget.attempt.endsIn(widget.groupChallenge, now: now)}',
      isLoading: _loading,
    );
  }

  Widget _buildEndButton() {
    return CustomButtonComponent(
      onTap: () async {
        if (_loading) {
          return;
        }
        setState(() {
          _loading = true;
        });
        await widget.onTapEnd(widget.attempt);
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      },
      text: 'End',
      subText: frequency.type == FrequencyTypeEnum.daily &&
              (frequency.amount == null ||
                  widget.attempt.getCurrentRepetitionNumber(
                          widget.groupChallenge,
                          now: now) <
                      frequency.getMaxAmountOfRepetitions()!)
          ? 'Next in ${widget.attempt.endsIn(widget.groupChallenge, now: now)}'
          : frequency.type != FrequencyTypeEnum.time &&
                  widget.attempt.getCurrentRepetitionNumber(
                          widget.groupChallenge,
                          now: now) ==
                      frequency.getMaxAmountOfRepetitions()
              ? 'Ends in ${widget.attempt.endsIn(widget.groupChallenge, now: now)}'
              : null,
      isPrimaryButton: widget.attempt.getCurrentRepetitionProgressPercentage(
                  widget.groupChallenge,
                  now: now) >=
              1 &&
          frequency.type == FrequencyTypeEnum.time,
      padding: const EdgeInsets.all(5),
      isLoading: _loading,
    );
  }

  bool _shouldShowAcceptAgainButton() {
    return widget.attempt.isSucceeded();
  }

  Widget _buildAcceptAgainButton() {
    return CustomButtonComponent(
      onTap: () async {
        if (_loading) {
          return;
        }
        setState(() {
          _loading = true;
        });
        await widget.onTapAgain();

        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      },
      text: 'Accept Again',
      isPrimaryButton: true,
      isLoading: _loading,
    );
  }

  bool _shouldShowTryAgainButton() {
    return widget.attempt.isFailed();
  }

  Widget _buildTryAgainButton() {
    return CustomButtonComponent(
      onTap: () async {
        if (_loading) {
          return;
        }
        setState(() {
          _loading = true;
        });
        await widget.onTapAgain();

        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      },
      text: 'Try Again',
      isPrimaryButton: true,
      isLoading: _loading,
    );
  }
}
