import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
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
  List<UserModel> users = [];

  late final groupChallengesProvider = Provider.of<GroupChallengesProvider>(
    context,
    listen: false,
  );

  late final usersProvider = Provider.of<UsersProvider>(
    context,
    listen: false,
  );

  final scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    groupChallengesProvider.getById(widget.groupChallenge.id).then((value) {
      _groupChallenge = value;
      usersProvider
          .getUsersByIds(value.participants.map((e) => e.userId).toList())
          .then((value) {
        setState(() {
          users = value;
        });
      });
    });
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
          users = await usersProvider.getUsersByIds(
              _groupChallenge.participants.map((e) => e.userId).toList());
          setState(() {});
        },
        scrollController: scrollController,
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            itemCount: _groupChallenge.participants.length,
            itemBuilder: (context, index) {
              UserModel user = users.firstWhere(
                  (user) =>
                      user.id == _groupChallenge.participants[index].userId,
                  orElse: () => UserModel.empty());
              return SpaceColumnComponent(
                child: ListItemParticipantComponent(
                    onTap: () => _onTapParticipant(
                        _groupChallenge.participants[index], user),
                    participant: _groupChallenge.participants[index],
                    user: user,
                    groupChallenge: _groupChallenge,
                    position: index),
              );
            }),
      ),
    );
  }

  _onTapParticipant(ParticipantModel participant, UserModel user) {
    Navigator.of(context)
        .push(NoAnimationPageRouteComponent(builder: (context) {
      return RepetitionPage(
          preTitle: '${widget.preTitle}/$title/${user.username}',
          attempt: participant.getLatestAttempt(),
          groupChallenge: _groupChallenge,
          participant: participant);
    })).then((_) {
      setState(() {});
    });
  }
}
