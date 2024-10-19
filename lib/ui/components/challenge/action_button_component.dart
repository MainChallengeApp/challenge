import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:flutter/material.dart';

class ActionButtonComponent extends StatefulWidget {
  final UserChallengeModel userChallenge;
  final Function(UserChallengeModel userChallenge) onTapStart;
  final Function(UserChallengeModel userChallenge) onTapEnd;
  final Function(UserChallengeModel userChallenge) onTapAgain;
  final Function(UserChallengeModel userChallenge) onTapNext;

  const ActionButtonComponent({
    super.key,
    required this.userChallenge,
    required this.onTapStart,
    required this.onTapEnd,
    required this.onTapAgain,
    required this.onTapNext,
  });

  @override
  State<ActionButtonComponent> createState() => _ActionButtonComponentState();
}

class _ActionButtonComponentState extends State<ActionButtonComponent> {
  late FrequencyModel frequency = widget.userChallenge.frequency;

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
    if (widget.userChallenge.isInBacklog()) {
      return true;
    }
    if (widget.userChallenge.getCurrentRepetition() == null &&
        widget.userChallenge.isInProgress()) {
      return true;
    } else {
      widget.userChallenge.getCurrentRepetition()?.evaluateRepetitionStatus();
      return (widget.userChallenge.getCurrentRepetition()?.isInBacklog() ??
              false) &&
          frequency.type == FrequencyTypeEnum.time;
    }
  }

  Widget _buildStartButton() {
    return CustomButtonComponent(
      onTap: () => widget.onTapStart(widget.userChallenge),
      text: 'Start',
      isPrimaryButton: true,
    );
  }

  bool _shouldShowEndButton() {
    if (!widget.userChallenge.isInProgress()) {
      return false;
    }

    return (widget.userChallenge.getCurrentRepetition() != null &&
                    widget.userChallenge
                        .getCurrentRepetition()!
                        .progressList
                        .isEmpty ||
                widget.userChallenge.getCurrentRepetitionNumber() ==
                    frequency.getMaxAmountOfRepetitions()) &&
            widget.userChallenge.isInProgress() ||
        widget.userChallenge.getCurrentRepetition() != null &&
            widget.userChallenge.getCurrentRepetition()!.isInProgress();
  }

  bool _shouldShowNextButton() {
    if (!widget.userChallenge.isInProgress()) {
      return false;
    }

    if (widget.userChallenge.getCurrentRepetitionNumber() ==
        widget.userChallenge.frequency.getMaxAmountOfRepetitions()) {
      return false;
    }

    if (widget.userChallenge.frequency.type == FrequencyTypeEnum.daily ||
        widget.userChallenge.frequency.type == FrequencyTypeEnum.weekday) {
      return false;
    }

    return widget.userChallenge
            .getCurrentRepetition()
            ?.progressList
            .isNotEmpty ??
        false;
  }

  Widget _buildNextButton() {
    return CustomButtonComponent(
      onTap: () => widget.onTapNext(widget.userChallenge),
      isPrimaryButton:
          (widget.userChallenge.getCurrentRepetition()?.isComplete() ??
                  false) &&
              frequency.type == FrequencyTypeEnum.time,
      text: frequency.type == FrequencyTypeEnum.time
          ? 'Next'
          : 'Next in ${widget.userChallenge.endsIn()}',
    );
  }

  Widget _buildEndButton() {
    return CustomButtonComponent(
      onTap: () => widget.onTapEnd(widget.userChallenge),
      text: 'End',
      subText: frequency.type == FrequencyTypeEnum.daily &&
              (frequency.amount == null ||
                  widget.userChallenge.getCurrentRepetitionNumber() <
                      frequency.getMaxAmountOfRepetitions()!)
          ? 'Next in ${widget.userChallenge.endsIn()}'
          : frequency.type != FrequencyTypeEnum.time &&
                  widget.userChallenge.getCurrentRepetitionNumber() ==
                      frequency.getMaxAmountOfRepetitions()
              ? 'Ends in ${widget.userChallenge.endsIn()}'
              : null,
      isPrimaryButton:
          widget.userChallenge.getCurrentRepetitionProgressPercentage() >= 1 &&
              frequency.type == FrequencyTypeEnum.time,
      padding: const EdgeInsets.all(5),
    );
  }

  bool _shouldShowAcceptAgainButton() {
    return widget.userChallenge.isSucceeded();
  }

  Widget _buildAcceptAgainButton() {
    return CustomButtonComponent(
      onTap: () => widget.onTapAgain(widget.userChallenge),
      text: 'Accept Again',
      isPrimaryButton: true,
    );
  }

  bool _shouldShowTryAgainButton() {
    return widget.userChallenge.isFailed();
  }

  Widget _buildTryAgainButton() {
    return CustomButtonComponent(
      onTap: () => widget.onTapAgain(widget.userChallenge),
      text: 'Try Again',
      isPrimaryButton: true,
    );
  }
}
