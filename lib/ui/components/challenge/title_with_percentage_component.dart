import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/ui/components/challenge/challenge_total_percentage_component.dart';
import 'package:challenge/ui/components/challenge/group_challenge_icon_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
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
        Visibility(
            visible: challenge is! GroupChallengeModel,
            child: GroupChallengeIconComponent(challenge: challenge)),
        Visibility(
          visible: !isSearch && !challenge.isInBacklog(),
          child: Padding(
            padding: const EdgeInsets.only(
                left: CustomContainerComponent.standardPadding),
            child: ChallengeTotalPercentageComponent(challenge: challenge),
          ),
        )
      ],
    );
  }
}
