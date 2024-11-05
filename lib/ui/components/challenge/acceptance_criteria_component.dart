import 'dart:math';

import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class AcceptanceCriteriaComponent extends StatefulWidget {
  final void Function() onTap;
  final AttemptModel attempt;
  final void Function() onTapNewProgress;

  const AcceptanceCriteriaComponent(
      {super.key,
      required this.onTap,
      required this.attempt,
      required this.onTapNewProgress});

  @override
  State<AcceptanceCriteriaComponent> createState() =>
      _AcceptanceCriteriaComponentState();
}

class _AcceptanceCriteriaComponentState
    extends State<AcceptanceCriteriaComponent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: !widget.attempt.isInProgress()
                ? min(widget.attempt.getCurrentPercentage(), 1)
                : min(
                    widget.attempt.getCurrentRepetitionProgressPercentage(), 1),
            heightFactor: 1,
            child: Container(
              // width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: widget.attempt.status == ChallengeStatusEnum.failed
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
                        children: [
                          repetition(),
                          repetitionProgressAbsolute(),
                        ],
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
      visible: widget.attempt.isInProgress(),
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
    return (widget.attempt.frequency.amount == 1 &&
            widget.attempt.frequency.type == FrequencyTypeEnum.time)
        ? Container()
        : widget.attempt.isInBacklog()
            ? ContainerInContainerTextComponent(
                text:
                    '${widget.attempt.frequency.amount ?? '∞'} ${widget.attempt.frequency.typeToString()}')
            : ContainerInContainerTextComponent(
                text:
                    '${widget.attempt.getCurrentRepetitionNumber()}/${widget.attempt.frequency.amount ?? '∞'} ${widget.attempt.frequency.typeToString()}');
  }

  repetitionProgressAbsolute() {
    return widget.attempt.acceptanceCriteria.unit != '' ||
            widget.attempt.acceptanceCriteria.amount != 0
        ? widget.attempt.isInProgress() ||
                (widget.attempt.frequency.amount != null &&
                        widget.attempt.frequency.amount! == 1) &&
                    !widget.attempt.isInBacklog()
            ? ContainerInContainerTextComponent(
                text:
                    '${UtilService.doubleAsIntString(widget.attempt.getCurrentRepetitionProgressAbsolute())}/${UtilService.doubleAsIntString(widget.attempt.acceptanceCriteria.amount)} ${widget.attempt.acceptanceCriteria.unit}')
            : ContainerInContainerTextComponent(
                text:
                    '${UtilService.doubleAsIntString(widget.attempt.acceptanceCriteria.amount)} ${widget.attempt.acceptanceCriteria.unit}')
        : Container();
  }
}
