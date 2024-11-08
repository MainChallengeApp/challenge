import 'dart:math';

import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/challenge/action_button_component.dart';
import 'package:challenge/ui/components/challenge/date_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_fraction_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/dialogs/end_challenge_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListItemRepetitionExpandedComponent extends StatefulWidget {
  const ListItemRepetitionExpandedComponent(
      {super.key,
      required this.repetition,
      this.onTap,
      required this.attempt,
      required this.onTapNextRepetition,
      required this.groupChallenge,
      required this.participant});

  final RepetitionModel repetition;
  final AttemptModel attempt;
  final GroupChallengeModel groupChallenge;
  final ParticipantModel participant;
  final void Function()? onTap;
  final void Function(int repetitionNumber) onTapNextRepetition;

  @override
  State<ListItemRepetitionExpandedComponent> createState() =>
      _ListItemRepetitionExpandedComponentState();
}

class _ListItemRepetitionExpandedComponentState
    extends State<ListItemRepetitionExpandedComponent> {
  late final groupChallengesProvider = Provider.of<GroupChallengesProvider>(
    context,
    listen: false,
  );

  late final listeningGroupChallengesProvider =
      Provider.of<GroupChallengesProvider>(
    context,
    listen: true,
  );

  late BuildContext pageContext;

  @override
  Widget build(BuildContext context) {
    listeningGroupChallengesProvider.groupChallenges;

    pageContext = context;
    widget.repetition.evaluateRepetitionStatus();
    return Stack(
      children: [
        ListItemFractionComponent(
          initialProgress: min(
              1,
              widget.repetition.getLastProgressPercentage(
                  widget.groupChallenge, widget.attempt)),
          isFailed: widget.attempt.isFailed(),
          onTap: widget.onTap,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [repetitionIcon(), repetition(), progress()],
            ),
          ),
        ),
        ListItemContainerComponent(
          isHeightDynamic: true,
          onTap: widget.onTap,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(0),
          borderRadius: ListItemContainerComponent.standardBorderRadius + 1,
          child: Column(
            children: [
              const SpaceComponent(
                height: ListItemContainerComponent.standardHeight -
                    1, // -1 for the border
              ),
              const SpaceComponent(),
              Row(
                children: [
                  Expanded(
                      child: Align(
                    alignment: Alignment.bottomLeft,
                    child: widget.repetition.startDate == null
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 16, bottom: 16, right: 8),
                            child: ActionButtonComponent(
                              groupChallenge: widget.groupChallenge,
                              attempt: widget.attempt,
                              onTapAgain: () => {},
                              onTapEnd: (_) => {},
                              onTapNext: (_) => {},
                              onTapStart: onTapStart,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 16, bottom: 16, right: 8),
                            child: DateComponent(
                                date: widget.repetition.startDate,
                                textColor:
                                    Theme.of(context).colorScheme.tertiary,
                                text: 'Start'),
                          ),
                  )),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: widget.repetition.startDate != null &&
                              widget.repetition.isInProgress()
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, bottom: 16, right: 16),
                              child: ActionButtonComponent(
                                  groupChallenge: widget.groupChallenge,
                                  attempt: widget.attempt,
                                  onTapStart: onTapStart,
                                  onTapEnd: onTapEnd,
                                  onTapAgain: () => {},
                                  onTapNext: onTapNext),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, bottom: 16, right: 16),
                              child: DateComponent(
                                textColor:
                                    Theme.of(context).colorScheme.tertiary,
                                date: widget.repetition.endDate,
                                text: 'End',
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

  onTapNext(AttemptModel attempt) async {
    setState(() async {
      attempt.endRepetition(widget.groupChallenge);
      widget.onTapNextRepetition.call(
        attempt
            .getLastRepetition(
              widget.groupChallenge,
            )!
            .repetitionNumber,
      );
    });
    groupChallengesProvider.updateAttempt(
        widget.groupChallenge, widget.participant, attempt);
  }

  onTapEnd(AttemptModel attempt) {
    EndChallengeDialog.show(
        context: pageContext,
        challengeTitle: widget.groupChallenge.title,
        onTapYes: () {
          groupChallengesProvider.endAttempt(
              widget.groupChallenge, widget.participant, attempt);
        });
  }

  onTapStart(AttemptModel attempt) {
    groupChallengesProvider.startAttempt(
        widget.groupChallenge, widget.participant, attempt);
  }

  repetition() {
    return ContainerInContainerTextComponent(
        text:
            '${widget.repetition.repetitionNumber}/${widget.attempt.getFrequency(widget.groupChallenge).amount ?? '∞'} ${widget.attempt.getFrequency(widget.groupChallenge).typeToString()}');
  }

  progress() {
    return ContainerInContainerTextComponent(
        text:
            '${UtilService.doubleAsIntString(widget.repetition.getLastProgressAbsolute())}/${UtilService.doubleAsIntString(widget.attempt.getAcceptanceCriteria(widget.groupChallenge).amount)} ${widget.attempt.getAcceptanceCriteria(widget.groupChallenge).unit}');
  }

  repetitionIcon() {
    return const IconContainerInListItemComponent(
      icon: Icons.repeat_rounded,
    );
  }
}
