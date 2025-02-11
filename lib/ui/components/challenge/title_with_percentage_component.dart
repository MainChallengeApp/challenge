import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/challenge/challenge_total_percentage_component.dart';
import 'package:challenge/ui/components/challenge/group_challenge_icon_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/title_component.dart';
import 'package:challenge/ui/pages/home/ranking_page.dart';
import 'package:challenge/ui/pages/home/repetition/repetition_page.dart';
import 'package:flutter/material.dart';

class TitleWithPercentageComponent extends StatefulWidget {
  final GroupChallengeModel groupChallenge;
  final ParticipantModel participant;
  final AttemptModel attempt;

  const TitleWithPercentageComponent({
    super.key,
    required this.groupChallenge,
    required this.attempt,
    required this.participant,
  });

  @override
  State<TitleWithPercentageComponent> createState() =>
      _TitleWithPercentageComponentState();
}

class _TitleWithPercentageComponentState
    extends State<TitleWithPercentageComponent> {
  final _tabProvider = getIt<TabProvider>();
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TitleComponent(title: widget.groupChallenge.title),
        ),
        Visibility(
            visible: widget.groupChallenge.participants.length > 1,
            child: GestureDetector(
              onTap: onTapGroupChallengeIcon,
              child: GroupChallengeIconComponent(
                groupChallenge: widget.groupChallenge,
                participant: widget.participant,
              ),
            )),
        Visibility(
          visible: !widget.attempt.isInBacklog(widget.groupChallenge),
          child: Padding(
            padding: const EdgeInsets.only(
                left: CustomContainerComponent.standardPadding),
            child: GestureDetector(
              onTap: onTapChallengePercentage,
              child: ChallengeTotalPercentageComponent(
                attempt: widget.attempt,
                groupChallenge: widget.groupChallenge,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onTapGroupChallengeIcon() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RankingPage(groupChallenge: widget.groupChallenge),
      ),
    ).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onTapChallengePercentage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepetitionPage(
          groupChallenge: widget.groupChallenge,
          attempt: widget.attempt,
          participant: widget.participant,
        ),
      ),
    ).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
      if (mounted) {
        setState(() {});
      }
    });
  }
}
