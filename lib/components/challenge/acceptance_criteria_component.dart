import 'dart:math';

import 'package:challenge/components/simple_components/container_in_container_component.dart';
import 'package:challenge/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/components/simple_components/custom_container_component.dart';
import 'package:challenge/components/simple_components/tap_container_component.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';

class AcceptanceCriteriaComponent extends StatefulWidget {
  final void Function() onTap;
  final ChallengeModel challenge;

  const AcceptanceCriteriaComponent(
      {super.key, required this.onTap, required this.challenge});

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
            widthFactor: !widget.challenge.isInProgress()
                ? min(widget.challenge.getCurrentPercentage(), 1)
                : min(widget.challenge.getCurrentRepetitionProgressPercentage(),
                    1),
            heightFactor: 1,
            child: Container(
              // width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: widget.challenge.status == ChallengeStatusEnum.failed
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // progressPercentage(widget.challenge.acceptanceCriteria),
                    repetition(),
                    repetitionProgressAbsolute(),
                    amountOfProgress(),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  repetition() {
    return (widget.challenge.frequency.amount == 1 &&
            widget.challenge.frequency.type == FrequencyTypeEnum.time)
        ? Container()
        : widget.challenge.isInBacklog()
            ? ContainerInContainerTextComponent(
                text:
                    '${widget.challenge.frequency.amount ?? '∞'} ${widget.challenge.frequency.typeToString()}')
            : ContainerInContainerTextComponent(
                text:
                    '${widget.challenge.getCurrentRepetitionNumber()}/${widget.challenge.frequency.amount ?? '∞'} ${widget.challenge.frequency.typeToString()}');
  }

  repetitionProgressAbsolute() {
    return widget.challenge.acceptanceCriteria.unit != '' ||
            widget.challenge.acceptanceCriteria.amount != 0
        ? widget.challenge.isInProgress() ||
                (widget.challenge.frequency.amount != null &&
                        widget.challenge.frequency.amount! == 1) &&
                    !widget.challenge.isInBacklog()
            ? ContainerInContainerTextComponent(
                text:
                    '${DesignUtil.doubleAsIntString(widget.challenge.getCurrentRepetitionProgressAbsolute())}/${DesignUtil.doubleAsIntString(widget.challenge.acceptanceCriteria.amount)} ${widget.challenge.acceptanceCriteria.unit}')
            : ContainerInContainerTextComponent(
                text:
                    '${DesignUtil.doubleAsIntString(widget.challenge.acceptanceCriteria.amount)} ${widget.challenge.acceptanceCriteria.unit}')
        : Container();
  }

  percentageDone() {
    return ContainerInContainerTextComponent(
        text:
            '${DesignUtil.doubleAsIntString((widget.challenge.getCurrentPercentage() * 100).roundToDouble())} %');
  }

  repetitionPercentage() {
    return ContainerInContainerTextComponent(
        text:
            '${DesignUtil.doubleAsIntString((widget.challenge.getCurrentRepetitionProgressPercentage() * 100).roundToDouble())} %');
  }

  amountOfProgress() {
    return widget.challenge.isInProgress() ||
            !widget.challenge.isInBacklog() &&
                widget.challenge.frequency.amount == 1
        ? ContainerInContainerComponent(
            child: Row(children: [
            Text(
              '${widget.challenge.getCurrentRepetition()?.progressList.length ?? 0} ',
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
