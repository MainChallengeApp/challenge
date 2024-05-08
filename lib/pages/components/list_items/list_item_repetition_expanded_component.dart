import 'dart:math';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/models/repetition_model.dart';
import 'package:challenge/pages/components/challenge/action_button_component.dart';
import 'package:challenge/pages/components/list_items/list_item_container_component.dart';
import 'package:challenge/pages/components/list_items/list_item_fraction_component.dart';
import 'package:challenge/pages/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/pages/components/simple_components/custom_container_component.dart';
import 'package:challenge/pages/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/pages/components/simple_components/space_component.dart';
import 'package:challenge/pages/dialogs/end_challenge_dialog.dart';
import 'package:challenge/services/challenge_service.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';

class ListItemRepetitionExpandedComponent extends StatefulWidget {
  const ListItemRepetitionExpandedComponent(
      {super.key,
      required this.repetition,
      this.onTap,
      required this.challenge,
      required this.setStateRepetitionPage,
      required this.addToExpandedRepetition});

  final RepetitionModel repetition;
  final ChallengeModel challenge;
  final void Function()? onTap;
  final void Function() setStateRepetitionPage;
  final void Function(int repetitionNumber) addToExpandedRepetition;

  @override
  State<ListItemRepetitionExpandedComponent> createState() =>
      _ListItemRepetitionExpandedComponentState();
}

class _ListItemRepetitionExpandedComponentState
    extends State<ListItemRepetitionExpandedComponent> {
  final ChallengeService challengeService = ChallengeService();

  late BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    dialogContext = context;
    widget.repetition.evaluateRepetitionStatus();
    return Stack(
      children: [
        ListItemFractionComponent(
          initialProgress:
              min(1, widget.repetition.getLastProgressPercentage()),
          isFailed: widget.repetition.isFailed(widget.challenge),
          onTap: widget.onTap,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [repetitionIcon(), repetition(), progress()],
            ),
          ),
        ),
        ListItemContainerComponent(
          height: 140,
          onTap: widget.onTap,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(0),
          borderRadius: ListItemContainerComponent.standardBorderRadius + 1,
          child: Column(
            children: [
              Container(
                height: ListItemContainerComponent.standardHeight -
                    1, // -1 for the border
              ),
              const SpaceComponent(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: Align(
                    alignment: Alignment.bottomLeft,
                    child: widget.repetition.startDate == null
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 10, bottom: 10, right: 5),
                            child: ActionButtonComponent(
                              challenge: widget.challenge,
                              onTapAgain: (_) => {},
                              onTapEnd: (_) => {},
                              onTapNext: (_) => {},
                              onTapStart: (challenge) {
                                setState(() {
                                  challengeService.startChallenge(challenge);
                                });

                                return;
                              },
                            ),
                          )
                        : CustomContainerComponent(
                            margin: const EdgeInsets.only(
                                left: 10, bottom: 10, right: 5),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Start:",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  DesignUtil.getDateAndTimeFormated(
                                          widget.repetition.startDate)
                                      .split(' ')[0],
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                  )),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: widget.repetition.startDate != null &&
                              widget.repetition.isInProgress()
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, bottom: 10, right: 10),
                              child: ActionButtonComponent(
                                  challenge: widget.challenge,
                                  onTapStart: onTapStart,
                                  onTapEnd: onTapEnd,
                                  onTapAgain: onTapAgain,
                                  onTapNext: onTapNext),
                            )
                          : CustomContainerComponent(
                              margin: const EdgeInsets.only(
                                  left: 5, bottom: 10, right: 10),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "End:",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  Text(
                                    widget.repetition.endDate != null
                                        ? DesignUtil.getDateAndTimeFormated(
                                                widget.repetition.endDate)
                                            .split(' ')[0]
                                        : '-',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SpaceComponent(),
      ],
    );
  }

  onTapNext(challenge) {
    setState(() {
      challengeService.nextRepetition(challenge);
      widget.addToExpandedRepetition
          .call(challenge.getLastRepetition()!.repetitionNumber);
    });
    widget.setStateRepetitionPage.call();
  }

  onTapAgain(challenge) => {};

  onTapEnd(challenge) {
    EndChallengeDialog.show(context, challenge, onTapYes: (challenge) {
      Navigator.pop(EndChallengeDialog.context3);
      setState(() {
        challengeService.endChallenge(challenge);
      });
    }, onTapNo: () {
      Navigator.pop(context);
    });
  }

  onTapStart(challenge) {
    setState(() {
      challengeService.startChallenge(challenge);
    });
  }

  repetition() {
    return ContainerInContainerTextComponent(
        text:
            '${widget.repetition.repetitionNumber}/${widget.challenge.frequency.amount ?? '∞'} ${widget.challenge.frequency.dayDaysTimeOrTimes()}');
  }

  progress() {
    return ContainerInContainerTextComponent(
        text:
            '${DesignUtil.doubleAsInt(widget.repetition.getLastProgressProgress())}/${DesignUtil.doubleAsInt(widget.challenge.acceptanceCriteria.amount)} ${widget.challenge.acceptanceCriteria.unit}');
  }

  repetitionIcon() {
    return const IconContainerInListItemComponent(
      icon: Icons.repeat_rounded,
    );
  }
}
