import 'dart:math';

import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:flutter/material.dart';

class AcceptanceCriteriaComponent extends StatefulWidget {
  final void Function() onTap;
  final UserChallengeModel userChallenge;
  final void Function() onTapNewProgress;

  const AcceptanceCriteriaComponent(
      {super.key,
      required this.onTap,
      required this.userChallenge,
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
            widthFactor: !widget.userChallenge.isInProgress()
                ? min(widget.userChallenge.getCurrentPercentage(), 1)
                : min(
                    widget.userChallenge
                        .getCurrentRepetitionProgressPercentage(),
                    1),
            heightFactor: 1,
            child: Container(
              // width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color:
                      widget.userChallenge.status == ChallengeStatusEnum.failed
                          ? red
                          : green,
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
                          // progressPercentage(widget.challenge.acceptanceCriteria),
                          repetition(),
                          repetitionProgressAbsolute(),
                          // amountOfProgress(),
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
      visible: widget.userChallenge.isInProgress(),
      child: GestureDetector(
        onTap: widget.onTapNewProgress,
        child: ContainerInContainerComponent(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            margin: const EdgeInsets.only(left: 10),
            color: Colors.white,
            border: Border.all(color: themeColor5, width: 1),
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
    return (widget.userChallenge.frequency.amount == 1 &&
            widget.userChallenge.frequency.type == FrequencyTypeEnum.time)
        ? Container()
        : widget.userChallenge.isInBacklog()
            ? ContainerInContainerTextComponent(
                text:
                    '${widget.userChallenge.frequency.amount ?? '∞'} ${widget.userChallenge.frequency.typeToString()}')
            : ContainerInContainerTextComponent(
                text:
                    '${widget.userChallenge.getCurrentRepetitionNumber()}/${widget.userChallenge.frequency.amount ?? '∞'} ${widget.userChallenge.frequency.typeToString()}');
  }

  repetitionProgressAbsolute() {
    return widget.userChallenge.acceptanceCriteria.unit != '' ||
            widget.userChallenge.acceptanceCriteria.amount != 0
        ? widget.userChallenge.isInProgress() ||
                (widget.userChallenge.frequency.amount != null &&
                        widget.userChallenge.frequency.amount! == 1) &&
                    !widget.userChallenge.isInBacklog()
            ? ContainerInContainerTextComponent(
                text:
                    '${UtilService.doubleAsIntString(widget.userChallenge.getCurrentRepetitionProgressAbsolute())}/${UtilService.doubleAsIntString(widget.userChallenge.acceptanceCriteria.amount)} ${widget.userChallenge.acceptanceCriteria.unit}')
            : ContainerInContainerTextComponent(
                text:
                    '${UtilService.doubleAsIntString(widget.userChallenge.acceptanceCriteria.amount)} ${widget.userChallenge.acceptanceCriteria.unit}')
        : Container();
  }

  percentageDone() {
    return ContainerInContainerTextComponent(
        text:
            '${UtilService.doubleAsIntString((widget.userChallenge.getCurrentPercentage() * 100).roundToDouble())} %');
  }

  repetitionPercentage() {
    return ContainerInContainerTextComponent(
        text:
            '${UtilService.doubleAsIntString((widget.userChallenge.getCurrentRepetitionProgressPercentage() * 100).roundToDouble())} %');
  }

  amountOfProgress() {
    return widget.userChallenge.isInProgress() ||
            !widget.userChallenge.isInBacklog() &&
                widget.userChallenge.frequency.amount == 1
        ? ContainerInContainerComponent(
            child: Row(children: [
            Text(
              '${widget.userChallenge.getCurrentRepetition()?.progressList.length ?? 0} ',
              style: const TextStyle(fontSize: 10, color: themeColor3),
            ),
            Icon(
              IconEnum.progress.icon,
              size: 10,
              color: themeColor3,
            )
          ]))
        : Container();
  }
}
