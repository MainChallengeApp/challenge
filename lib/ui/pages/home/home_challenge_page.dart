import 'dart:math';

import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/ui/components/cards/group_challenge_card_component.dart';
import 'package:challenge/ui/components/cards/user_challenge_card_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeChallengePage extends StatefulWidget {
  const HomeChallengePage({
    super.key,
    required this.preTitle,
    required this.initialChallengeId,
    this.filterOptions = '',
  });
  final String preTitle;
  final String initialChallengeId;
  final String filterOptions;

  @override
  State<HomeChallengePage> createState() => _HomeChallengePageState();
}

class _HomeChallengePageState extends State<HomeChallengePage> {
  late final PageController _pageController =
      PageController(initialPage: _currentChallengeIndex);

  late String _currentChallengeId = widget.initialChallengeId;

  late int _currentChallengeIndex = max(
      _filteredChallenges
          .indexWhere((challenge) => challenge.id == widget.initialChallengeId),
      0);

  late final _listeningUserChallengesProvider =
      Provider.of<UserChallengesProvider>(context, listen: true);
  late final _listeningGroupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context, listen: true);

  List<ChallengeModel> _filteredChallenges = [];

  @override
  Widget build(BuildContext context) {
    _mergeAndSortChallenges();

    if (_filteredChallenges.isEmpty) {
      _navigatorPop(context);
      return Container();
    }

    _jumpToCurrentChallenge();

    return Scaffold(
      appBar: AppBarComponent(preTitle: widget.preTitle),
      backgroundColor: Colors.white,
      body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          children: _filteredChallenges.map((challenge) {
            challenge.checkChallengeStatus();
            return challenge is UserChallengeModel
                ? UserChallengeCardComponent(
                    userChallenge: challenge, preTitle: widget.preTitle)
                : challenge is GroupChallengeModel
                    ? GroupChallengeCardComponent(
                        groupChallenge: challenge, preTitle: widget.preTitle)
                    : Container();
          }).toList()),
      bottomNavigationBar: const BottomNavigationComponent(),
    );
  }

  void _navigatorPop(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
    });
  }

  void _mergeAndSortChallenges() {
    _filteredChallenges.clear();
    _filteredChallenges.addAll(_listeningUserChallengesProvider.userChallenges);
    _filteredChallenges
        .addAll(_listeningGroupChallengesProvider.groupChallenges);
    _filteredChallenges = _filteredChallenges
        .where((element) => element.searchInChallenge(widget.filterOptions))
        .toList();
    _filteredChallenges =
        ChallengeModel.sortChallengeList(challenges: _filteredChallenges);
  }

  void _onPageChanged(int value) {
    setState(() {
      _currentChallengeId = _filteredChallenges[value].id;
      _currentChallengeIndex = value;
    });
  }

  void _jumpToCurrentChallenge() {
    if (!_pageController.hasClients) {
      return;
    }

    int actualIndex = _filteredChallenges
        .indexWhere((challenge) => challenge.id == _currentChallengeId);
    if (_currentChallengeIndex != actualIndex) {
      _currentChallengeIndex = actualIndex;
      _pageController.jumpToPage(actualIndex);
    }
  }
}
