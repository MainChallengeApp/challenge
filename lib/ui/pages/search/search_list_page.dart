import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/search_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_challenge_small_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_filter_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'search_challenge_page.dart';

class SearchListPage extends StatefulWidget {
  final String preTitle;
  final String? title;
  final ValueChanged<ChallengeModel>? onPush;
  final bool isFirstPageInRoute;
  final String initialSearchText;
  final bool isSearchBarAutoFocus;
  final List<ChallengeCategoryEnum> categories;
  final bool isUserSearchActive;

  const SearchListPage({
    super.key,
    this.preTitle = '',
    this.title,
    this.onPush,
    this.isFirstPageInRoute = true,
    this.initialSearchText = '',
    this.isSearchBarAutoFocus = false,
    this.categories = const [],
    this.isUserSearchActive = false,
  });

  @override
  State<SearchListPage> createState() => _SearchListPageState();
}

class _SearchListPageState extends State<SearchListPage> {
  late List<ChallengeModel> filteredChallenges;
  late List<UserModel> filteredUsers;

  final ScrollController scrollController = ScrollController();

  late final searchChallengesProvider =
      Provider.of<SearchChallengesProvider>(context, listen: false);

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  int numberOfBuilds = 0;

  String searchBarText = '';

  @override
  void initState() {
    super.initState();
    searchBarText = widget.initialSearchText;
    searchChallengesProvider.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent(
            preTitle: widget.preTitle,
            titleText: widget.title,
            isFirstPageInRoute: widget.isFirstPageInRoute),
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: _buildChallengesList(),
        ),
        bottomNavigationBar: const BottomNavigationComponent());
  }

  Widget _buildChallengesList() {
    filteredChallenges = searchChallengesProvider.searchChallenges
        .where((element) =>
            element.searchInChallenge(searchBarText) &&
            element.isInCategories(widget.categories))
        .toList();
    filteredChallenges
        .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return Expanded(
      child: RawScrollbar(
        controller: scrollController,
        radius: const Radius.circular(4),
        thumbColor: themeColor3,
        padding: const EdgeInsets.only(right: 4),
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            itemCount: filteredChallenges.length +
                1 +
                1 +
                1, // + 1 for searchBar + 1 for filter + 1 for new Challenge
            itemBuilder: (BuildContext content, int index) {
              numberOfBuilds++;
              if (index == 0) {
                return SpaceColumnComponent(
                    child: ListItemSearchBarComponent(
                  autoFocus: widget.isSearchBarAutoFocus && numberOfBuilds == 1,
                  changeList: changeList,
                  textEditingController:
                      TextEditingController(text: searchBarText),
                  hintText: 'Search for Challenges and Users...',
                ));
              }

              if (index == 1) {
                return SpaceColumnComponent(
                    child: ListItemSearchFilterComponent(
                  onTapChallenges: () {},
                  onTapUsers: () {},
                ));
              }

              if (index == filteredChallenges.length + 1 + 1) {
                return SpaceColumnComponent(
                    child: ListItemIconTextComponent(
                  onTap: onTapNewChallenge,
                  icon: Icons.add,
                  title: searchBarText == '' ? 'New Challenge' : searchBarText,
                ));
              }

              ChallengeModel challenge = filteredChallenges[index - 1 - 1];
              return SpaceColumnComponent(
                child: ListItemChallengeSmallComponent(
                  onTap: () => onTapChallenge(
                      challenge: challenge,
                      index: index), // widget.onPush?.call(challenge),
                  challenge: challenge,
                  isSearch: true,
                ),
              );
            }),
      ),
    );
  }

  Widget _buildUsersList() {
    filteredChallenges = searchChallengesProvider.searchChallenges
        .where((element) =>
            element.searchInChallenge(searchBarText) &&
            element.isInCategories(widget.categories))
        .toList();
    filteredChallenges
        .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return RawScrollbar(
      controller: scrollController,
      radius: const Radius.circular(4),
      thumbColor: themeColor3,
      padding: const EdgeInsets.only(right: 4),
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemCount: filteredChallenges.length,
          itemBuilder: (BuildContext content, int index) {
            numberOfBuilds++;
            ChallengeModel challenge = filteredChallenges[index];
            return SpaceColumnComponent(
              child: ListItemChallengeSmallComponent(
                onTap: () => onTapChallenge(
                    challenge: challenge,
                    index: index), // widget.onPush?.call(challenge),
                challenge: challenge,
                isSearch: true,
              ),
            );
          }),
    );
  }

  changeList(String value) {
    setState(() {
      // challengesFutures = getChallenges(context);
      searchBarText = value;
    });
  }

  onTapChallenge({required ChallengeModel challenge, required int index}) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchChallengePage(
          title: '${widget.preTitle}/${widget.title}',
          initChallenge: challenge,
          challenges: filteredChallenges,
          initChallengeIndex: index,
        ),
      ),
    ).then((value) => setState(
          () {},
        ));
  }

  onTapNewChallenge() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => EditChallengePage(
          preTitle: '${widget.preTitle}/${widget.title}',
          challenge: ChallengeModel.empty(title: searchBarText),
          isNewChallenge: true,
          isSearchNewChallenge: true,
        ),
      ),
    ).then((_) => setState(() {}));
  }
}
