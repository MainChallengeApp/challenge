import 'dart:math';

import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/acceptance_criteria_model.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class AcceptanceCriteriaComponent extends StatefulWidget {
  final GroupChallengeModel groupChallenge;
  final void Function()? onTap;
  final AttemptModel? attempt;
  final void Function()? onTapNewProgress;

  const AcceptanceCriteriaComponent(
      {super.key,
      this.onTap,
      this.attempt,
      this.onTapNewProgress,
      required this.groupChallenge});

  @override
  State<AcceptanceCriteriaComponent> createState() =>
      _AcceptanceCriteriaComponentState();
}

class _AcceptanceCriteriaComponentState
    extends State<AcceptanceCriteriaComponent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CustomContainerComponent.standardHeight,
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: widget.attempt == null
                ? 0
                : !widget.attempt!.isInProgress(widget.groupChallenge)
                    ? min(
                        widget.attempt!
                            .getCurrentPercentage(widget.groupChallenge),
                        1)
                    : min(
                        widget.attempt!.getCurrentRepetitionProgressPercentage(
                            widget.groupChallenge),
                        1),
            heightFactor: 1,
            child: Container(
              // width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: widget.attempt != null &&
                          widget.attempt!.isFailed(widget.groupChallenge)
                      ? Theme.of(context).colorScheme.red
                      : Theme.of(context).colorScheme.green,
                  borderRadius: const BorderRadius.all(Radius.circular(
                      CustomContainerComponent.standardRadius))),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white,
                    width: 10,
                    strokeAlign: BorderSide.strokeAlignOutside),
                borderRadius: const BorderRadius.all(
                    Radius.circular(CustomContainerComponent.standardRadius))),
          ),
          TapContainerComponent(
              onTap: widget.onTap,
              backgroundColor: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [repetition(), repetitionProgressAbsolute()],
                      ),
                    ),
                  ),
                  newProgress()
                ],
              ))
        ],
      ),
    );
  }

  Visibility newProgress() {
    return Visibility(
      visible: widget.attempt != null &&
          widget.attempt!.isInProgress(widget.groupChallenge),
      child: GestureDetector(
        onTap: widget.onTapNewProgress,
        child: ContainerInContainerComponent(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            margin: const EdgeInsets.only(left: 10),
            color: Colors.white,
            border: Border.all(
                color: Theme.of(context).colorScheme.themeColor5, width: 1),
            child: Center(
              child: Icon(
                IconEnum.newChallenge.icon,
                size: 20,
                color: Colors.black,
              ),
            )),
      ),
    );
  }

  repetition() {
    FrequencyModel frequency = widget.attempt == null
        ? widget.groupChallenge.frequency
        : widget.attempt!.getFrequency(widget.groupChallenge);

    return (frequency.amount == 1 && frequency.type == FrequencyTypeEnum.time)
        ? Container()
        : widget.attempt == null ||
                widget.attempt!.isInBacklog(widget.groupChallenge)
            ? ContainerInContainerTextComponent(
                margin: const EdgeInsets.only(
                    right: ContainerInContainerComponent.standardMargin),
                text:
                    '${frequency.amount ?? 'max.'} ${frequency.typeToString()}')
            : ContainerInContainerTextComponent(
                margin: const EdgeInsets.only(
                    right: ContainerInContainerComponent.standardMargin),
                text:
                    '${widget.attempt!.getCurrentRepetitionNumber(widget.groupChallenge)}/${frequency.amount ?? 'max.'} ${frequency.typeToString()}');
  }

  repetitionProgressAbsolute() {
    FrequencyModel frequency = widget.attempt == null
        ? widget.groupChallenge.frequency
        : widget.attempt!.getFrequency(widget.groupChallenge);
    AcceptanceCriteriaModel acceptanceCriteria = widget.attempt == null
        ? widget.groupChallenge.acceptanceCriteria
        : widget.attempt!.getAcceptanceCriteria(widget.groupChallenge);

    return acceptanceCriteria.unit != '' || acceptanceCriteria.amount != 0
        ? widget.attempt != null &&
                (widget.attempt!.isInProgress(widget.groupChallenge) ||
                    (frequency.amount != null && frequency.amount! == 1) &&
                        !widget.attempt!.isInBacklog(widget.groupChallenge))
            ? ContainerInContainerTextComponent(
                margin: const EdgeInsets.only(
                    right: ContainerInContainerComponent.standardMargin),
                text:
                    '${UtilService.doubleAsIntString(widget.attempt!.getCurrentRepetitionProgressAbsolute(widget.groupChallenge))}/${UtilService.doubleAsIntString(acceptanceCriteria.amount)} ${acceptanceCriteria.unit}')
            : ContainerInContainerTextComponent(
                margin: const EdgeInsets.only(
                    right: ContainerInContainerComponent.standardMargin),
                text:
                    '${UtilService.doubleAsIntString(acceptanceCriteria.amount)} ${acceptanceCriteria.unit}')
        : Container();
  }
}
