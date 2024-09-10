import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/search_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_challenge_small_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_with_filter_component.dart';
import 'package:challenge/ui/components/list_items/list_item_user_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/search/search_user_page.dart';
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

  const SearchListPage({
    super.key,
    this.preTitle = '',
    this.title,
    this.onPush,
    this.isFirstPageInRoute = true,
    this.initialSearchText = '',
    this.isSearchBarAutoFocus = false,
    this.categories = const [],
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
  late final listeningSearchChallengesProvider =
      Provider.of<SearchChallengesProvider>(context, listen: true);

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);

  int numberOfBuilds = 0;

  String searchBarText = '';

  bool isFilterOnChallenges = true;

  @override
  void initState() {
    super.initState();
    searchBarText = widget.initialSearchText;
    searchChallengesProvider.getAll();
    usersProvider.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent(
            preTitle: widget.preTitle,
            titleText: widget.title,
            isFirstPageInRoute: widget.isFirstPageInRoute),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SpaceColumnComponent(
                child: ListItemSearchWithFilterComponent(
              autoFocus: widget.isSearchBarAutoFocus && numberOfBuilds == 0,
              textEditingController: TextEditingController(text: searchBarText),
              changeList: changeList,
              isFilterOnChallenges: isFilterOnChallenges,
              onTapChallenges: () {
                setState(() {
                  isFilterOnChallenges = true;
                });
              },
              onTapUsers: () {
                setState(() {
                  isFilterOnChallenges = false;
                });
              },
            )),
            Expanded(
                child: isFilterOnChallenges
                    ? _buildChallengesList()
                    : _buildUsersList())
          ],
        ),
        bottomNavigationBar: const BottomNavigationComponent());
  }

  Widget _buildChallengesList() {
    filteredChallenges = listeningSearchChallengesProvider.searchChallenges
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
          itemCount: filteredChallenges.length + 1, // + 1 for new Challenge
          itemBuilder: (BuildContext content, int index) {
            numberOfBuilds++;
            if (index == filteredChallenges.length) {
              return SpaceColumnComponent(
                  child: ListItemIconTextComponent(
                onTap: onTapNewChallenge,
                icon: Icons.add,
                title: searchBarText == '' ? 'New Challenge' : searchBarText,
              ));
            }

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

  Widget _buildUsersList() {
    filteredUsers = listeningUsersProvider.searchUsers
        .where((element) => element.searchInUser(searchBarText))
        .toList();
    filteredUsers.sort(
        (a, b) => a.username.toLowerCase().compareTo(b.username.toLowerCase()));
    return RawScrollbar(
      controller: scrollController,
      radius: const Radius.circular(4),
      thumbColor: themeColor3,
      padding: const EdgeInsets.only(right: 4),
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemCount: filteredUsers.length,
          itemBuilder: (BuildContext content, int index) {
            numberOfBuilds++;
            UserModel user = filteredUsers[index];
            return SpaceColumnComponent(
              child: ListItemUserComponent(
                onTap: () => onTapUser(user: user, index: index),
                user: user,
                isSearch: true,
                onTapConnect: () {
                  print('onTapConnect');
                },
              ),
            );
          }),
    );
  }

  changeList(String value) {
    setState(() {
      searchBarText = value;
    });
  }

  onTapChallenge({required ChallengeModel challenge, required int index}) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchChallengePage(
          title: '${widget.preTitle}/${widget.title}',
          challenges: filteredChallenges,
          initChallengeIndex: index,
        ),
      ),
    ).then((value) => setState(
          () {},
        ));
  }

  onTapUser({required UserModel user, required int index}) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchUserPage(
          title: '${widget.preTitle}/${widget.title}',
          users: filteredUsers,
          initUserIndex: index,
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
