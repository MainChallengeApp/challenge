import 'dart:math';

import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/ui/components/challenge/action_button_component.dart';
import 'package:challenge/ui/components/challenge/date_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_fraction_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/dialogs/end_challenge_dialog.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListItemRepetitionExpandedComponent extends StatefulWidget {
  const ListItemRepetitionExpandedComponent(
      {super.key,
      required this.repetition,
      this.onTap,
      required this.userChallenge,
      required this.onTapNextRepetition});

  final RepetitionModel repetition;
  final UserChallengeModel userChallenge;
  final void Function()? onTap;
  final void Function(int repetitionNumber) onTapNextRepetition;

  @override
  State<ListItemRepetitionExpandedComponent> createState() =>
      _ListItemRepetitionExpandedComponentState();
}

class _ListItemRepetitionExpandedComponentState
    extends State<ListItemRepetitionExpandedComponent> {
  late final userChallengesProvider = Provider.of<UserChallengesProvider>(
    context,
    listen: false,
  );

  late final listeningProvider = Provider.of<UserChallengesProvider>(
    context,
    listen: true,
  );

  late BuildContext pageContext;

  @override
  Widget build(BuildContext context) {
    listeningProvider.userChallenges;

    pageContext = context;
    widget.repetition.evaluateRepetitionStatus();
    return Stack(
      children: [
        ListItemFractionComponent(
          initialProgress:
              min(1, widget.repetition.getLastProgressPercentage()),
          isFailed: widget.userChallenge.isFailed(),
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
                              userChallenge: widget.userChallenge,
                              onTapAgain: (_) => {},
                              onTapEnd: (_) => {},
                              onTapNext: (_) => {},
                              onTapStart: onTapStart,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 10, bottom: 10, right: 5),
                            child: DateComponent(
                                date: widget.repetition.startDate,
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
                                  left: 5, bottom: 10, right: 10),
                              child: ActionButtonComponent(
                                  userChallenge: widget.userChallenge,
                                  onTapStart: onTapStart,
                                  onTapEnd: onTapEnd,
                                  onTapAgain: (_) => {},
                                  onTapNext: onTapNext),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, bottom: 10, right: 10),
                              child: DateComponent(
                                  date: widget.repetition.endDate, text: 'End'),
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

  onTapNext(UserChallengeModel userChallenge) {
    setState(() {
      userChallenge.endRepetition();
      widget.onTapNextRepetition
          .call(userChallenge.getLastRepetition()!.repetitionNumber);
    });
    userChallengesProvider.update(userChallenge);
  }

  onTapEnd(UserChallengeModel userChallenge) {
    EndChallengeDialog.show(
        context: pageContext,
        onTapYes: () {
          userChallengesProvider.end(userChallenge);
        });
  }

  onTapStart(userChallenge) {
    userChallengesProvider.start(userChallenge);
  }

  repetition() {
    return ContainerInContainerTextComponent(
        text:
            '${widget.repetition.repetitionNumber}/${widget.userChallenge.frequency.amount ?? '∞'} ${widget.userChallenge.frequency.typeToString()}');
  }

  progress() {
    return ContainerInContainerTextComponent(
        text:
            '${DesignUtil.doubleAsIntString(widget.repetition.getLastProgressAbsolute())}/${DesignUtil.doubleAsIntString(widget.userChallenge.acceptanceCriteria.amount)} ${widget.userChallenge.acceptanceCriteria.unit}');
  }

  repetitionIcon() {
    return const IconContainerInListItemComponent(
      icon: Icons.repeat_rounded,
    );
  }
}
