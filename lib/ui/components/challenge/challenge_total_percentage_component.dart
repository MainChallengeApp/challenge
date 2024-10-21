import 'dart:math';

import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class ChallengeTotalPercentageComponent extends StatelessWidget {
  final ChallengeModel challenge;
  final bool isVisible;
  final EdgeInsets? padding;

  const ChallengeTotalPercentageComponent(
      {super.key,
      required this.challenge,
      this.isVisible = true,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return ContainerInContainerTextComponent(
        margin: const EdgeInsets.all(0),
        padding: padding,
        color: isVisible
            ? (challenge.isFailed()
                ? Theme.of(context).colorScheme.red
                : challenge.isSucceeded()
                    ? Theme.of(context).colorScheme.green
                    : null)
            : Colors.transparent,
        textColor: challenge.isFailed() || challenge.isSucceeded()
            ? Colors.white
            : null,
        text: isVisible
            ? '${(min(challenge.getCurrentPercentage(), 1) * 100).floor()} %'
            : '',
        textStyle: Theme.of(context).textTheme.titleSmall);
  }
}
