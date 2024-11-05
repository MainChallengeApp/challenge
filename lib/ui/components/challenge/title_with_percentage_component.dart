import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/ui/components/challenge/challenge_total_percentage_component.dart';
import 'package:challenge/ui/components/challenge/group_challenge_icon_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/title_component.dart';
import 'package:flutter/material.dart';

class TitleWithPercentageComponent extends StatelessWidget {
  final GroupChallengeModel groupChallenge;
  final AttemptModel attempt;

  const TitleWithPercentageComponent({
    super.key,
    required this.groupChallenge,
    required this.attempt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TitleComponent(title: groupChallenge.title),
        ),
        Visibility(
            visible: groupChallenge.participants.length > 1,
            child: GroupChallengeIconComponent(challenge: groupChallenge)),
        Visibility(
          visible: !attempt.isInBacklog(),
          child: Padding(
            padding: const EdgeInsets.only(
                left: CustomContainerComponent.standardPadding),
            child: ChallengeTotalPercentageComponent(attempt: attempt),
          ),
        )
      ],
    );
  }
}
