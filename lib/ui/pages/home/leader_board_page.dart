import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_participant_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/home/repetition/repetition_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderBoardPage extends StatefulWidget {
  final String preTitle;
  final GroupChallengeModel groupChallenge;

  const LeaderBoardPage(
      {super.key, required this.preTitle, required this.groupChallenge});

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  String title = 'Leader Board';
  late GroupChallengeModel _groupChallenge = widget.groupChallenge;

  late final groupChallengesProvider = Provider.of<GroupChallengesProvider>(
    context,
    listen: false,
  );

  final scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    if (mounted) {
      groupChallengesProvider.getById(widget.groupChallenge.id).then((value) {
        if (mounted) {
          _groupChallenge = value;
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _groupChallenge = groupChallengesProvider.groupChallenges.firstWhere(
        (element) => element.id == widget.groupChallenge.id,
        orElse: () => _groupChallenge);
    _groupChallenge.sortParticipants();
    return Scaffold(
      appBar: AppBarComponent(preTitle: widget.preTitle, titleText: title),
      body: RefreshIndicatorComponent(
        onRefresh: () async {
          _groupChallenge =
              await groupChallengesProvider.getById(widget.groupChallenge.id);
          setState(() {});
        },
        scrollController: scrollController,
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            itemCount: _groupChallenge.participants.length,
            itemBuilder: (context, index) {
              ParticipantModel participant =
                  _groupChallenge.participants[index];
              return SpaceColumnComponent(
                child: ListItemParticipantComponent(
                    onTap: () => _onTapParticipant(participant),
                    participant: participant,
                    groupChallenge: _groupChallenge,
                    position:
                        _groupChallenge.getPositionOf(participant.user.id)),
              );
            }),
      ),
    );
  }

  _onTapParticipant(ParticipantModel participant) {
    Navigator.of(context)
        .push(NoAnimationPageRouteComponent(builder: (context) {
      return RepetitionPage(
          preTitle: '${widget.preTitle}/$title/${participant.user.username}',
          attempt: participant.getLatestAttempt(),
          groupChallenge: _groupChallenge,
          participant: participant);
    })).then((_) {
      setState(() {});
    });
  }
}
