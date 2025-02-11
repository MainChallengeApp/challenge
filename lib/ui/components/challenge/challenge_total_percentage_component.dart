import 'dart:math';

import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/components/simple_components/small_container_in_list_item_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class ChallengeTotalPercentageComponent extends StatefulWidget {
  final GroupChallengeModel groupChallenge;
  final AttemptModel attempt;

  const ChallengeTotalPercentageComponent(
      {super.key, required this.attempt, required this.groupChallenge});

  @override
  State<ChallengeTotalPercentageComponent> createState() =>
      _ChallengeTotalPercentageComponentState();
}

class _ChallengeTotalPercentageComponentState
    extends State<ChallengeTotalPercentageComponent> {
  @override
  Widget build(BuildContext context) {
    widget.attempt.checkStatus(widget.groupChallenge);
    return ContainerInContainerTextComponent(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.symmetric(
            horizontal: ContainerInContainerComponent.standardPaddingSmall),
        height: SmallContainerInListItemComponent.height,
        border: Border.all(
            color: Theme.of(context).colorScheme.surface,
            width: 0.5,
            strokeAlign: BorderSide.strokeAlignOutside),
        color: (widget.attempt.isFailed(widget.groupChallenge)
            ? Theme.of(context).colorScheme.red
            : widget.attempt.isSucceeded(widget.groupChallenge)
                ? Theme.of(context).colorScheme.green
                : null),
        textColor: widget.attempt.isFailed(widget.groupChallenge) ||
                widget.attempt.isSucceeded(widget.groupChallenge)
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.tertiary,
        text:
            '${(min(widget.attempt.getCurrentPercentage(widget.groupChallenge), 1) * 100).floor()} %',
        textStyle: Theme.of(context).textTheme.titleSmall);
  }
}
