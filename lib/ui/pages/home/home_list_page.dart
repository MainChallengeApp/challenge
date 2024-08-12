import 'dart:async';

import 'package:challenge/globals.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_challenge_small_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/home/home_challenge_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeListPage extends StatefulWidget {
  const HomeListPage({super.key, required this.title, this.onPush});
  final String title;
  final ValueChanged<ChallengeModel>? onPush;

  @override
  State<HomeListPage> createState() => _HomeListPageState();
}

class _HomeListPageState extends State<HomeListPage> {
  ChallengeController challengeController = ChallengeController();

  late final userChallengesProvider =
      Provider.of<UserChallengesProvider>(context, listen: false);
  late final listeningProvider = Provider.of<UserChallengesProvider>(context);

  late List<UserChallengeModel> filteredUserChallenges;

  ScrollController scrollController = ScrollController();

  String searchBarText = '';

  Timer? timer;

  @override
  void initState() {
    super.initState();
    userChallengesProvider.getAllOfUser();
    timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        preTitle: widget.title,
        isFirstPageInRoute: true,
      ),
      backgroundColor: Colors.white,
      body: _buildList(),
      bottomNavigationBar: const BottomNavigationComponent(),
    );
  }

  Widget _buildList() {
    filteredUserChallenges = listeningProvider.userChallenges
        .where((element) => element.searchInChallenge(searchBarText))
        .toList();

    filteredUserChallenges =
        ChallengeModel.sortChallengeList(challenges: filteredUserChallenges)
            as List<UserChallengeModel>;

    return RawScrollbar(
      controller: scrollController,
      radius: const Radius.circular(4),
      thumbColor: themeColor3,
      padding: const EdgeInsets.only(right: 4),
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemCount: filteredUserChallenges.length +
              1 +
              1, // +1 for new Challenge listItem + 1 for searchBar
          itemBuilder: (BuildContext content, int index) {
            if (index == 0) {
              return searchBar();
            }
            if (index == 1) {
              return newChallenge();
            }
            UserChallengeModel challenge = filteredUserChallenges[index -
                1 -
                1]; // -1 for new Challenge listItem - 1 for searchBar

            challenge.checkChallengeStatus();
            return SpaceColumnComponent(
              child: ListItemChallengeSmallComponent(
                onTap: () => push(context,
                    userChallenge: challenge, index: index - 1 - 1),
                challenge: challenge,
                onTapDeleteChallenge: () => deleteChallenge(challenge),
              ),
            );
          }),
    );
  }

  SpaceColumnComponent newChallenge() {
    return SpaceColumnComponent(
      child: ListItemIconTextComponent(
        onTap: () => tapOnNewChallenge(),
        icon: Icons.add_rounded,
        title: 'New Challenge',
      ),
    );
  }

  SpaceColumnComponent searchBar() {
    return SpaceColumnComponent(
      child: ListItemSearchBarComponent(
        changeList: changeList,
        textEditingController: TextEditingController(text: searchBarText),
        hintText: 'Search in your Challenges...',
      ),
    );
  }

  changeList(String value) {
    setState(() {
      searchBarText = value;
    });
  }

  void push(BuildContext context,
      {required UserChallengeModel userChallenge, required int index}) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => HomeChallengePage(
          preTitle: widget.title,
          initialUserChallengeId: userChallenge.id,
          filterOptions: searchBarText,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  tapOnNewChallenge() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => EditChallengePage(
          preTitle: widget.title,
          challenge: ChallengeModel.empty(),
          isNewChallenge: true,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void deleteChallenge(UserChallengeModel userChallenge) {
    setState(() {
      userChallengesProvider.delete(userChallenge);
    });
  }
}
