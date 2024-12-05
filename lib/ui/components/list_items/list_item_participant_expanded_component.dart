import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_participant_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class ListItemParticipantExpandedComponent extends StatefulWidget {
  const ListItemParticipantExpandedComponent(
      {super.key,
      required this.groupChallenge,
      required this.participant,
      required this.attempt,
      required this.isEditableByUser,
      required this.reloadSearchChallengePage});

  final GroupChallengeModel groupChallenge;
  final ParticipantModel participant;
  final AttemptModel attempt;
  final bool isEditableByUser;
  final Function(AttemptModel) reloadSearchChallengePage;

  @override
  State<ListItemParticipantExpandedComponent> createState() =>
      _ListItemParticipantExpandedComponentState();
}

class _ListItemParticipantExpandedComponentState
    extends State<ListItemParticipantExpandedComponent> {
  late AttemptModel _selectedAttempt = widget.attempt;

  @override
  void didUpdateWidget(ListItemParticipantExpandedComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.attempt != oldWidget.attempt) {
      setState(() {
        _selectedAttempt = widget.attempt;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListItemParticipantComponent(
          groupChallenge: widget.groupChallenge,
          participant: widget.participant,
          attempt: widget.attempt,
        ),
        ListItemContainerComponent(
          isHeightDynamic: true,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(0),
          borderRadius: ListItemContainerComponent.standardBorderRadius + 1,
          child: Column(
            children: [
              const SpaceComponent(
                height: ListItemContainerComponent.standardHeight -
                    2, // -2 for the border
              ),
              _attemptDropDown(),
            ],
          ),
        ),
        const SpaceComponent(),
      ],
    );
  }

  _attemptDropDown() {
    return Visibility(
      visible: widget.participant.attempts.length > 1,
      child: Column(
        children: [
          const SpaceComponent(),
          CustomContainerComponent(
            margin: const EdgeInsets.symmetric(
                horizontal: SpaceComponent.staticWidth),
            child: DropdownButton<AttemptModel>(
              borderRadius: BorderRadius.circular(
                  CustomContainerComponent.standardRadius),
              isExpanded: true,
              underline: Container(),
              value: widget.participant.attempts.firstWhere(
                  (attempt) => attempt.number == _selectedAttempt.number),
              icon: Icon(IconEnum.arrowDown.icon,
                  size: Theme.of(context).textTheme.titleLarge?.fontSize),
              style: Theme.of(context).textTheme.textInputSmall,
              hint: Text(
                'Frequency',
                style: Theme.of(context).textTheme.textInputHintSmall,
              ),
              onChanged: (AttemptModel? attempt) {
                if (attempt == null) {
                  return;
                }
                setState(() {
                  _selectedAttempt = attempt;
                });
                widget.reloadSearchChallengePage.call(_selectedAttempt);
              },
              items: widget.participant.attempts.reversed.map((attempt) {
                return DropdownMenuItem<AttemptModel>(
                    value: attempt,
                    child: Text(
                      'Attempt ${attempt.number}',
                      style: Theme.of(context).textTheme.textInputSmall,
                    ));
              }).toList(),
            ),
          ),
          const SpaceComponent()
        ],
      ),
    );
  }
}
