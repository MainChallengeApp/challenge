import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/pages/components/simple_components/container_in_container_text_component.dart';
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
    return GestureDetector(
      onTap: widget.onTap,
      child: Center(
        child: SizedBox(
          height: 55,
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor:
                    widget.challenge.acceptanceCriteria.calcProgressRatio() > 1
                        ? 1
                        : widget.challenge.acceptanceCriteria
                            .calcProgressRatio(),
                heightFactor: 1,
                child: Container(
                  // width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color:
                          widget.challenge.status == ChallengeStatusEnum.failed
                              ? Colors.red
                              : Colors.green,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16))),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white,
                        width: 10,
                        strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white.withAlpha(170),
                      border: Border.all(
                          width: 1,
                          color: const Color.fromRGBO(226, 232, 240, 1)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16))),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // progressPercentage(widget.challenge.acceptanceCriteria),
                        repetition(widget.challenge.acceptanceCriteria,
                            widget.challenge.startDate),
                        progressAbsolute(widget.challenge.acceptanceCriteria),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  progressAbsolute(AcceptanceCriteriaModel acceptanceCriteria) {
    return acceptanceCriteria.unit != '' || acceptanceCriteria.amount != 0
        ? ContainerInContainerTextComponent(
            text:
                '${DesignUtil.doubleAsInt(acceptanceCriteria.currentProgress)}/${DesignUtil.doubleAsInt(acceptanceCriteria.amount)} ${acceptanceCriteria.unit}')
        : Container();
  }

  repetition(AcceptanceCriteriaModel acceptanceCriteria,
      DateTime? challengeStartDate) {
    return ContainerInContainerTextComponent(
        text:
            '${acceptanceCriteria.getCurrentFrequencyAmount(challengeStartDate)}/${acceptanceCriteria.frequency.amount ?? '∞'} ${DesignUtil.dayDaysTimeOrTimes(acceptanceCriteria.frequency)}');
  }
}
