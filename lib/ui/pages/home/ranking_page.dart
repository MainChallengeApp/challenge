import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_participant_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/home/repetition/repetition_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingPage extends StatefulWidget {
  final GroupChallengeModel groupChallenge;

  const RankingPage({super.key, required this.groupChallenge});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  late GroupChallengeModel _groupChallenge = widget.groupChallenge;

  late final _groupChallengesProvider = getIt<GroupChallengesProvider>();
  late final _listeningGroupChallengesProvider =
      Provider.of<GroupChallengesProvider>(
    context,
  );

  final _scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    if (mounted) {
      _groupChallengesProvider.getById(widget.groupChallenge.id).then((value) {
        if (mounted) {
          _groupChallenge = value;
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _groupChallenge = _listeningGroupChallengesProvider.groupChallenges
        .firstWhere((element) => element.id == widget.groupChallenge.id,
            orElse: () => _groupChallenge);
    _groupChallenge.sortParticipants();
    return ScaffoldComponent(
      appBar: const AppBarComponent(title: 'Ranking'),
      isBottomNavigationVisible: false,
      body: RefreshIndicatorComponent(
        onRefresh: () async {
          _groupChallenge =
              await _groupChallengesProvider.getById(widget.groupChallenge.id);
          setState(() {});
        },
        scrollController: _scrollController,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemCount: _groupChallenge.participants.length,
                  itemBuilder: (context, index) {
                    ParticipantModel participant =
                        _groupChallenge.participants[index];
                    return SpaceColumnComponent(
                      child: ListItemParticipantComponent(
                          onTap: () => _onTapParticipant(participant),
                          groupChallenge: _groupChallenge,
                          participant: participant,
                          attempt: participant.getLatestAttempt()),
                    );
                  }),
            ),
            _cancelButton(),
          ],
        ),
      ),
    );
  }

  _onTapParticipant(ParticipantModel participant) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RepetitionPage(
          attempt: participant.getLatestAttempt(),
          groupChallenge: _groupChallenge,
          participant: participant);
    })).then((_) {
      setState(() {});
    });
  }

  _cancelButton() {
    return Column(
      children: [
        const SpaceComponent(),
        ListItemButtonComponent(
          onTap: _onTapCancel,
          text: 'Cancel',
          isMainButton: false,
        ),
        const SpaceComponent(
          height: BottomNavigationComponent.standardMargin,
        )
      ],
    );
  }

  void _onTapCancel() {
    Navigator.pop(context);
  }
}
