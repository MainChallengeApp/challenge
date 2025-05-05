import 'dart:math';

import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/scroll_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/group_challenge_card_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeChallengePage extends StatefulWidget {
  const HomeChallengePage({
    super.key,
    required this.initialChallengeId,
    this.filterOptions = '',
  });
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

  final _groupChallengesProvider = getIt<GroupChallengesProvider>();
  late GroupChallengesProvider _listeningGroupChallengesProvider;

  final _usersProvider = getIt<UsersProvider>();

  List<GroupChallengeModel> _filteredChallenges = [];

  @override
  initState() {
    super.initState();
    _groupChallengesProvider.getById(widget.initialChallengeId);
    ScrollService.fixOverScroll(
        _pageController, () => _filteredChallenges.length);
  }

  @override
  Widget build(BuildContext context) {
    _listeningGroupChallengesProvider =
        Provider.of<GroupChallengesProvider>(context);
    _mergeAndSortChallenges();

    if (_filteredChallenges.isEmpty) {
      _navigatorPop(context);
      return Container();
    }

    _jumpToCurrentChallenge();

    return ScaffoldComponent(
      appBar: AppBarComponent(title: TabItemEnum.home.name),
      body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          children: _filteredChallenges.map((challenge) {
            challenge.checkStatus();
            return GroupChallengeCardComponent(groupChallenge: challenge);
          }).toList()),
    );
  }

  void _navigatorPop(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
    });
  }

  void _mergeAndSortChallenges() {
    _filteredChallenges.clear();
    _filteredChallenges
        .addAll(_listeningGroupChallengesProvider.groupChallenges);
    _filteredChallenges = _filteredChallenges
        .where((element) =>
            element.searchInChallenge(widget.filterOptions) &&
            element.getParticipant(_usersProvider.user.id).isAccepted())
        .toList();
    _filteredChallenges = GroupChallengeModel.sortChallengeList(
        groupChallenges: _filteredChallenges, userId: _usersProvider.user.id);
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

    if (_currentChallengeIndex >= _filteredChallenges.length) {
      _currentChallengeIndex = _filteredChallenges.length - 1;
      _pageController.jumpToPage(_currentChallengeIndex);
      return;
    }

    int actualIndex = _filteredChallenges
        .indexWhere((challenge) => challenge.id == _currentChallengeId);

    if (actualIndex == -1) {
      _currentChallengeId = _filteredChallenges[_currentChallengeIndex].id;
      return;
    }

    if (_currentChallengeIndex != actualIndex) {
      _currentChallengeIndex = actualIndex;
      _pageController.jumpToPage(actualIndex);
    }
  }
}
