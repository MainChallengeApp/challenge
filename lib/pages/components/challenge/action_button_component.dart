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
    if (widget.challenge.getCurrentRepetition() == null ||
        widget.challenge.getCurrentRepetition()!.isInBacklog() &&
            widget.challenge.frequency.type == FrequencyTypeEnum.time) {
      return CustomButtonComponent(
        onTap: () => widget.onTapStart(widget.challenge),
        text: "Start",
        isPrimaryButton: true,
      );
    }

    if ((widget.challenge.frequency.amount == 1 ||
                // widget.challenge.getCurrentRepetition() == null ||
                // widget.challenge.getCurrentRepetition()!.progressList.isEmpty ||
                widget.challenge.getCurrentRepetitionNumber() ==
                    widget.challenge.frequency.getMaxAmoutOfRepetitions()) &&
            widget.challenge.isInProgress() ||
        widget.challenge.getCurrentRepetition() != null &&
            widget.challenge.getCurrentRepetition()!.isInProgress()) {
      return CustomButtonComponent(
        onTap: () => widget.onTapEnd(widget.challenge),
        text: "End",
        subText: widget.challenge.frequency.type == FrequencyTypeEnum.daily &&
                widget.challenge.frequency.amount != null &&
                widget.challenge.getCurrentRepetitionNumber() <
                    widget.challenge.frequency.getMaxAmoutOfRepetitions()!
            ? "Next in ${widget.challenge.frequency.nextIn()}"
            : null,
        isPrimaryButton:
            widget.challenge.getCurrentRepetitionProgressPercentageProgess() >=
                    1 &&
                widget.challenge.frequency.type == FrequencyTypeEnum.time,
        padding: const EdgeInsets.all(5),
      );
    }

    if (widget.challenge.isSucceeded()) {
      return CustomButtonComponent(
        onTap: () => widget.onTapAgain(widget.challenge),
        text: "Accept Again",
        isPrimaryButton: true,
      );
    }
    if (widget.challenge.isFailed()) {
      return CustomButtonComponent(
        onTap: () => widget.onTapAgain(widget.challenge),
        text: "Try Again",
        isPrimaryButton: true,
      );
    }

    if (widget.challenge.frequency.type == FrequencyTypeEnum.daily) {
      return CustomButtonComponent(
          onTap: () => widget.onTapNext(widget.challenge),
          text: "Next in ${widget.challenge.frequency.nextIn()}");
    }

    return CustomButtonComponent(
        onTap: () => widget.onTapNext(widget.challenge),
        isPrimaryButton: widget.challenge.getLastRepetition()!.isComplete(),
        text: "Next");
  }
}
