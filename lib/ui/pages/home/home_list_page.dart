import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_challenge_small_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/dialogs/delete_challenge_dialog.dart';
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
  late final userChallengesProvider =
      Provider.of<UserChallengesProvider>(context, listen: false);
  late final listeningUserChallengesProvider =
      Provider.of<UserChallengesProvider>(context);

  late final groupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context, listen: false);
  late final listeningGroupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context);

  late List<UserChallengeModel> filteredUserChallenges;
  late List<GroupChallengeModel> filteredGroupChallenges;

  List<ChallengeModel> filteredChallenges = [];

  ScrollController scrollController = ScrollController();

  String searchBarText = '';

  @override
  void initState() {
    super.initState();
    userChallengesProvider.getAllOfUser();
    groupChallengesProvider.getAllOfUser();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBarComponent(
          preTitle: widget.title,
          isFirstPageInRoute: true,
        ),
        backgroundColor: Colors.white,
        body: _buildList(),
        bottomNavigationBar: const BottomNavigationComponent(),
      ),
    );
  }

  Widget _buildList() {
    filteredUserChallenges = listeningUserChallengesProvider.userChallenges
        .where((element) => element.searchInChallenge(searchBarText))
        .toList();

    filteredGroupChallenges = listeningGroupChallengesProvider.groupChallenges
        .where((element) => element.searchInChallenge(searchBarText))
        .toList();

    filteredChallenges = [];

    filteredChallenges.addAll(filteredUserChallenges);
    filteredChallenges.addAll(filteredGroupChallenges);
    filteredChallenges =
        ChallengeModel.sortChallengeList(challenges: filteredChallenges);

    return Column(
      children: [
        searchBar(),
        Expanded(
          child: RefreshIndicatorComponent(
            scrollController: scrollController,
            onRefresh: () async {
              await userChallengesProvider.getAllOfUser();
              setState(() {});
            },
            child: RawScrollbar(
              controller: scrollController,
              radius: const Radius.circular(4),
              thumbColor: Theme.of(context).colorScheme.tertiary,
              padding: const EdgeInsets.only(right: 4),
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount: filteredChallenges.length +
                      1, // +1 for new Challenge listItem
                  itemBuilder: (BuildContext content, int index) {
                    if (index == 0) {
                      return newChallenge();
                    }
                    ChallengeModel challenge = filteredChallenges[
                        index - 1]; // -1 for new Challenge listItem

                    challenge.checkChallengeStatus();
                    return SpaceColumnComponent(
                      child: ListItemChallengeSmallComponent(
                        onTap: () => onTapChallenge(context,
                            challenge: challenge, index: index - 1),
                        challenge: challenge,
                        onTapDeleteChallenge: () =>
                            onTapDeleteChallenge(challenge),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ],
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

  void onTapChallenge(BuildContext context,
      {required ChallengeModel challenge, required int index}) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => HomeChallengePage(
          preTitle: widget.title,
          initialUserChallengeId: challenge.id,
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

  void onTapDeleteChallenge(ChallengeModel challenge) {
    DeleteChallengeDialog.show(
      context: context,
      challengeTitle: challenge.title,
      onTapYes: () async {
        if (challenge is UserChallengeModel) {
          await userChallengesProvider.delete(challenge);
        } else if (challenge is GroupChallengeModel) {
          await groupChallengesProvider.delete(challenge);
        }
      },
    );
  }
}
