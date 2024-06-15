import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/models/frequency_model.dart';
import 'package:challenge/pages/components/simple_components/custom_button_component.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:flutter/material.dart';

class ActionButtonComponent extends StatefulWidget {
  final ChallengeModel challenge;
  final Function(ChallengeModel challenge) onTapStart;
  final Function(ChallengeModel challenge) onTapEnd;
  final Function(ChallengeModel challenge) onTapAgain;
  final Function(ChallengeModel challenge) onTapNext;

  const ActionButtonComponent({
    super.key,
    required this.challenge,
    required this.onTapStart,
    required this.onTapEnd,
    required this.onTapAgain,
    required this.onTapNext,
  });

  @override
  State<ActionButtonComponent> createState() => _ActionButtonComponentState();
}

class _ActionButtonComponentState extends State<ActionButtonComponent> {
  TextEditingController frequencyAmountTextEditingController =
      TextEditingController();

  bool isKeyboardUp = false;

  late FrequencyModel frequency = widget.challenge.frequency;

  ChallengeController challengeController = ChallengeController();

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
    if (widget.challenge.isInBacklog()) {
      return true;
    }
    if (widget.challenge.getCurrentRepetition() == null &&
        widget.challenge.isInProgress()) {
      return true;
    } else {
      widget.challenge.getCurrentRepetition()?.evaluateRepetitionStatus();
      return (widget.challenge.getCurrentRepetition()?.isInBacklog() ??
              false) &&
          frequency.type == FrequencyTypeEnum.time;
    }
  }

  Widget _buildStartButton() {
    return CustomButtonComponent(
      onTap: () => widget.onTapStart(widget.challenge),
      text: "Start",
      isPrimaryButton: true,
    );
  }

  bool _shouldShowEndButton() {
    if (!widget.challenge.isInProgress()) {
      return false;
    }

    return (widget.challenge.getCurrentRepetition() != null &&
                    widget.challenge
                        .getCurrentRepetition()!
                        .progressList
                        .isEmpty ||
                widget.challenge.getCurrentRepetitionNumber() ==
                    frequency.getMaxAmoutOfRepetitions()) &&
            widget.challenge.isInProgress() ||
        widget.challenge.getCurrentRepetition() != null &&
            widget.challenge.getCurrentRepetition()!.isInProgress();
  }

  bool _shouldShowNextButton() {
    if (widget.challenge.getCurrentRepetitionNumber() ==
        widget.challenge.frequency.getMaxAmoutOfRepetitions()) {
      return false;
    }

    if (widget.challenge.frequency.type == FrequencyTypeEnum.daily ||
        widget.challenge.frequency.type == FrequencyTypeEnum.weekday) {
      return false;
    }

    return widget.challenge.getCurrentRepetition()?.progressList.isNotEmpty ??
        false;
  }

  Widget _buildNextButton() {
    return CustomButtonComponent(
      onTap: () => widget.onTapNext(widget.challenge),
      isPrimaryButton:
          (widget.challenge.getCurrentRepetition()?.isComplete() ?? false) &&
              frequency.type == FrequencyTypeEnum.time,
      text: frequency.type == FrequencyTypeEnum.time
          ? "Next"
          : "Next in ${widget.challenge.nextIn()}",
    );
  }

  Widget _buildEndButton() {
    return CustomButtonComponent(
      onTap: () => widget.onTapEnd(widget.challenge),
      text: frequency.type != FrequencyTypeEnum.time &&
              widget.challenge.getCurrentRepetitionNumber() ==
                  frequency.getMaxAmoutOfRepetitions()
          ? "Ends in ${widget.challenge.nextIn()}"
          : "End",
      subText: frequency.type == FrequencyTypeEnum.daily &&
              (frequency.amount == null ||
                  widget.challenge.getCurrentRepetitionNumber() <
                      frequency.getMaxAmoutOfRepetitions()!)
          ? "Next in ${widget.challenge.nextIn()}"
          : null,
      isPrimaryButton:
          widget.challenge.getCurrentRepetitionProgressPercentageProgess() >=
                  1 &&
              frequency.type == FrequencyTypeEnum.time,
      padding: const EdgeInsets.all(5),
    );
  }

  bool _shouldShowAcceptAgainButton() {
    return widget.challenge.isSucceeded();
  }

  Widget _buildAcceptAgainButton() {
    return CustomButtonComponent(
      onTap: () => widget.onTapAgain(widget.challenge),
      text: "Accept Again",
      isPrimaryButton: true,
    );
  }

  bool _shouldShowTryAgainButton() {
    return widget.challenge.isFailed();
  }

  Widget _buildTryAgainButton() {
    return CustomButtonComponent(
      onTap: () => widget.onTapAgain(widget.challenge),
      text: "Try Again",
      isPrimaryButton: true,
    );
  }
}
