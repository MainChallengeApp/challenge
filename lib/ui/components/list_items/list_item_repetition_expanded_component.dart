import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/challenge/action_button_component.dart';
import 'package:challenge/ui/components/challenge/date_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_repetition_component.dart';
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
      required this.participant,
      required this.isEditableByUser});

  final RepetitionModel repetition;
  final AttemptModel attempt;
  final GroupChallengeModel groupChallenge;
  final ParticipantModel participant;
  final bool isEditableByUser;
  final void Function()? onTap;
  final void Function(int repetitionNumber) onTapNextRepetition;

  @override
  State<ListItemRepetitionExpandedComponent> createState() =>
      _ListItemRepetitionExpandedComponentState();
}

class _ListItemRepetitionExpandedComponentState
    extends State<ListItemRepetitionExpandedComponent> {
  final _groupChallengesProvider = getIt<GroupChallengesProvider>();

  late final _listeningGroupChallengesProvider =
      Provider.of<GroupChallengesProvider>(
    context,
    listen: true,
  );

  @override
  Widget build(BuildContext context) {
    _listeningGroupChallengesProvider.groupChallenges;

    widget.repetition.evaluateRepetitionStatus();
    return Stack(
      children: [
        ListItemRepetitionComponent(
          repetition: widget.repetition,
          attempt: widget.attempt,
          groupChallenge: widget.groupChallenge,
          onTap: widget.onTap,
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
                    2, // -2 for the border
              ),
              const SpaceComponent(),
              Row(
                children: [
                  Expanded(
                      child: Align(
                    alignment: Alignment.bottomLeft,
                    child: widget.repetition.startDate == null &&
                            widget.isEditableByUser
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 16, bottom: 16, right: 8),
                            child: ActionButtonComponent(
                              groupChallenge: widget.groupChallenge,
                              attempt: widget.attempt,
                              onTapAgain: () => {},
                              onTapEnd: (_) => {},
                              onTapNext: (_) => {},
                              onTapStart: _onTapStart,
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
                              widget.repetition.isInProgress() &&
                              widget.isEditableByUser
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, bottom: 16, right: 16),
                              child: ActionButtonComponent(
                                  groupChallenge: widget.groupChallenge,
                                  attempt: widget.attempt,
                                  onTapStart: _onTapStart,
                                  onTapEnd: _onTapEnd,
                                  onTapAgain: () => {},
                                  onTapNext: _onTapNext),
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

  _onTapNext(AttemptModel attempt) async {
    attempt.endRepetition(widget.groupChallenge);
    widget.onTapNextRepetition.call(
      attempt
          .getLastRepetition(
            widget.groupChallenge,
          )!
          .repetitionNumber,
    );
    setState(() {});
    _groupChallengesProvider.updateAttempt(
        widget.groupChallenge, widget.participant, attempt);
  }

  _onTapEnd(AttemptModel attempt) {
    EndChallengeDialog.show(
        context: context,
        challengeTitle: widget.groupChallenge.title,
        onTapYes: () {
          _groupChallengesProvider.endAttempt(
              widget.groupChallenge, widget.participant, attempt);
        });
  }

  _onTapStart(AttemptModel attempt) async {
    attempt.getCurrentRepetition(widget.groupChallenge)?.start();
    await _groupChallengesProvider.updateAttempt(
        widget.groupChallenge, widget.participant, attempt);
  }
}
