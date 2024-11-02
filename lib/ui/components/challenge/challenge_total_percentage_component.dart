import 'dart:math';

import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class ChallengeTotalPercentageComponent extends StatelessWidget {
  final UserChallengeModel? userChallenge;
  final bool isVisible;
  final EdgeInsets? padding;

  const ChallengeTotalPercentageComponent(
      {super.key,
      required this.userChallenge,
      this.isVisible = true,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return userChallenge == null
        ? Container()
        : ContainerInContainerTextComponent(
            margin: const EdgeInsets.all(0),
            padding: padding,
            color: isVisible
                ? (userChallenge!.isFailed()
                    ? Theme.of(context).colorScheme.red
                    : userChallenge!.isSucceeded()
                        ? Theme.of(context).colorScheme.green
                        : null)
                : Colors.transparent,
            textColor: userChallenge!.isFailed() || userChallenge!.isSucceeded()
                ? Colors.white
                : Theme.of(context).colorScheme.tertiary,
            text: isVisible
                ? '${(min(userChallenge!.getCurrentPercentage(), 1) * 100).floor()} %'
                : '',
            textStyle: Theme.of(context).textTheme.titleSmall);
  }
}
