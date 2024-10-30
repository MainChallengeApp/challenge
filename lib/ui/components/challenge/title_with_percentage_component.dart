import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/ui/components/challenge/challenge_total_percentage_component.dart';
import 'package:challenge/ui/components/simple_components/card_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/title_component.dart';
import 'package:flutter/material.dart';

class TitleWithPercentageComponent extends StatelessWidget {
  final UserChallengeModel userChallenge;
  final bool isSearch;

  const TitleWithPercentageComponent({
    super.key,
    required this.userChallenge,
    this.isSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TitleComponent(title: userChallenge.title),
        ),
        const SpaceComponent(
          width: CardComponent.standardPadding,
        ),
        ChallengeTotalPercentageComponent(
            userChallenge: userChallenge,
            isVisible: !isSearch && !userChallenge.isInBacklog(),
            padding: const EdgeInsets.all(8))
      ],
    );
  }
}
