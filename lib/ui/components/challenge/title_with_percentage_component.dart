import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/ui/components/challenge/challenge_total_percentage_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/title_component.dart';
import 'package:flutter/material.dart';

class TitleWithPercentageComponent extends StatelessWidget {
  final ChallengeModel challenge;
  final bool isSearch;

  const TitleWithPercentageComponent({
    super.key,
    required this.challenge,
    this.isSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TitleComponent(title: challenge.title),
        ),
        const SpaceComponent(
          width: CardComponent.standardPadding,
        ),
        Visibility(
          visible: !challenge.isInBacklog(),
          child: ChallengeTotalPercentageComponent(
              challenge: challenge,
              isVisible: !isSearch,
              padding: const EdgeInsets.all(7)),
        )
      ],
    );
  }
}
