import 'dart:math';

import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeTotalPercentageComponent extends StatefulWidget {
  final ChallengeModel challenge;

  const ChallengeTotalPercentageComponent({super.key, required this.challenge});

  @override
  State<ChallengeTotalPercentageComponent> createState() =>
      _ChallengeTotalPercentageComponentState();
}

class _ChallengeTotalPercentageComponentState
    extends State<ChallengeTotalPercentageComponent> {
  late final _usersProvider =
      Provider.of<UsersProvider>(context, listen: false);

  late final UserChallengeModel _userChallenge =
      widget.challenge is UserChallengeModel
          ? (widget.challenge as UserChallengeModel)
          : widget.challenge is GroupChallengeModel
              ? (widget.challenge as GroupChallengeModel)
                  .toUserChallengeModel(_usersProvider.user.id)
              : throw Error();

  @override
  Widget build(BuildContext context) {
    return ContainerInContainerTextComponent(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: CustomContainerComponent.standardHeight * 0.6,
        color: (_userChallenge.isFailed()
            ? Theme.of(context).colorScheme.red
            : _userChallenge.isSucceeded()
                ? Theme.of(context).colorScheme.green
                : null),
        textColor: _userChallenge.isFailed() || _userChallenge.isSucceeded()
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.tertiary,
        text:
            '${(min(_userChallenge.getCurrentPercentage(), 1) * 100).floor()} %',
        textStyle: Theme.of(context).textTheme.titleSmall);
  }
}
