import 'dart:math';

import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/enums/search_filter_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/search_challenges_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/types/all_search_results_type.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_challenge_small_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_info_component.dart';
import 'package:challenge/ui/components/list_items/list_item_invite_friends_component.dart';
import 'package:challenge/ui/components/list_items/list_item_recent_search_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_with_filter_component.dart';
import 'package:challenge/ui/components/list_items/list_item_user_component.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/search/search_all_page.dart';
import 'package:challenge/ui/pages/search/search_user_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'search_challenge_page.dart';

class SearchListPage extends StatefulWidget {
  final String title;
  final bool isSearchBarAutoFocus;
  final List<ChallengeCategoryEnum> categories;
  final bool isUserSearchActive;
  final SearchFilterEnum initialSearchFilter;

  const SearchListPage({
    super.key,
    this.title = 'Search',
    this.isSearchBarAutoFocus = false,
    this.categories = const [],
    this.isUserSearchActive = false,
    this.initialSearchFilter = SearchFilterEnum.all,
  });

  @override
  State<SearchListPage> createState() => _SearchListPageState();
}

class _SearchListPageState extends State<SearchListPage> {
  late List<ChallengeModel> searchChallenges;
  late List<UserModel> searchedUsers;

  final ScrollController scrollController = ScrollController();

  late final searchChallengesProvider =
      Provider.of<SearchChallengesProvider>(context, listen: false);
  late final listeningSearchChallengesProvider =
      Provider.of<SearchChallengesProvider>(context, listen: true);

  late final _usersProvider =
      Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);
  final _tabProvider = getIt<TabProvider>();

  int numberOfBuilds = 0;

  final textEditingController = TextEditingController();

  late SearchFilterEnum selectedSearchFilter = widget.initialSearchFilter;

  @override
  void initState() {
    super.initState();
    searchChallengesProvider.initSearchChallenges(
        categories: widget.categories);
    if (widget.isUserSearchActive) {
      _usersProvider.getSearchedPaginated(isInit: true);
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        switch (selectedSearchFilter) {
          case SearchFilterEnum.all:
            searchChallengesProvider.getSearchedPaginated(
                searchText: textEditingController.text,
                categories: widget.categories);
            _usersProvider.getSearchedPaginated(
                searchText: textEditingController.text);
            break;
          case SearchFilterEnum.challenges:
            searchChallengesProvider.getSearchedPaginated(
                searchText: textEditingController.text,
                categories: widget.categories);
            break;
          case SearchFilterEnum.users:
            _usersProvider.getSearchedPaginated(
                searchText: textEditingController.text);
            break;
          default:
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ScaffoldComponent(
          appBar: AppBarComponent(title: widget.title),
          body: Column(
            children: [
              SpaceColumnComponent(
                  child: ListItemSearchWithFilterComponent(
                autoFocus: widget.isSearchBarAutoFocus && numberOfBuilds == 0,
                textEditingController: textEditingController,
                isUserSearchActive: widget.isUserSearchActive,
                initialSearchFilter: selectedSearchFilter,
                onTapActionIcon: _onTapActionIcon,
                onSubmitted: _onSubmitted,
                onChangeList: _onChangeList,
                onTapFilter: _onTapFilter,
                onTapOutside: _onTapOutside,
              )),
              Expanded(
                  child: textEditingController.text.isEmpty &&
                          widget.categories.isEmpty
                      ? buildRecentSearches()
                      : selectedSearchFilter == SearchFilterEnum.challenges
                          ? _buildChallengesList()
                          : selectedSearchFilter == SearchFilterEnum.users
                              ? _buildUsersList()
                              : _buildAllList())
            ],
          )),
    );
  }

  _onTapFilter(searchFilter) {
    setState(() {
      selectedSearchFilter = searchFilter;
    });
  }

  _onSubmitted(String text) async {
    if (text.isEmpty) {
      return;
    }
    await _onChangeList(text);
    _usersProvider.addRecentSearch(text);
  }

  _onTapOutside(PointerDownEvent _) async {
    String text = textEditingController.text;
    if (text.isEmpty) {
      return;
    }
    _usersProvider.addRecentSearch(text);
  }

  _onTapActionIcon() {
    setState(() {
      textEditingController.clear();
    });
  }

  Widget _buildChallengesList() {
    searchChallenges = listeningSearchChallengesProvider.searchChallenges;

    return RefreshIndicatorComponent(
      scrollController: scrollController,
      onRefresh: () async {
        await searchChallengesProvider.getSearchedPaginated(
            searchText: textEditingController.text,
            categories: widget.categories,
            isInit: true);
      },
      child: CupertinoScrollbar(
        controller: scrollController,
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            itemCount: searchChallenges.length +
                1, // + 1 for loading circle or  new Challenge
            itemBuilder: (BuildContext content, int index) {
              numberOfBuilds++;
              if (index == searchChallenges.length) {
                return listeningSearchChallengesProvider
                        .isEndOfSearchedListReached
                    ? SpaceColumnComponent(
                        child: ListItemIconTextComponent(
                        onTap: onTapNewChallenge,
                        icon: Icons.add,
                        title: textEditingController.text == ''
                            ? 'New Challenge'
                            : textEditingController.text,
                      ))
                    : const Center(
                        child: SpaceColumnComponent(
                            child: LoadingCircleComponent()),
                      );
              }

              ChallengeModel challenge = searchChallenges[index];
              return SpaceColumnComponent(
                child: ListItemChallengeSmallComponent(
                  onTap: () => onTapChallenge(index: index),
                  challenge: challenge,
                  isSearch: true,
                ),
              );
            }),
      ),
    );
  }

  Widget _buildUsersList() {
    searchedUsers = listeningUsersProvider.searchUsers;
    return RefreshIndicatorComponent(
      scrollController: scrollController,
      onRefresh: () async {
        await _usersProvider.getSearchedPaginated(
            searchText: textEditingController.text, isInit: true);
      },
      child: CupertinoScrollbar(
        controller: scrollController,
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            itemCount: searchedUsers.length + 1, // + 1 for loading circle
            itemBuilder: (BuildContext content, int index) {
              numberOfBuilds++;

              if (index == searchedUsers.length) {
                return listeningUsersProvider.isEndOfSearchedListReached
                    ? SpaceColumnComponent(
                        child: ListItemInviteFriendsComponent(
                        username: _usersProvider.user.username,
                      ))
                    : const Center(
                        child: SpaceColumnComponent(
                            child: LoadingCircleComponent()),
                      );
              }

              UserModel user = searchedUsers[index];
              return SpaceColumnComponent(
                child: ListItemUserComponent(
                  onTap: () => onTapUser(user: user, index: index),
                  user: user,
                  isSearch: true,
                ),
              );
            }),
      ),
    );
  }

  _buildAllList() {
    List<dynamic> allSearchResults = _getAllList();

    return RefreshIndicatorComponent(
      scrollController: scrollController,
      onRefresh: () async {
        await _onChangeList(textEditingController.text);
      },
      child: CupertinoScrollbar(
        controller: scrollController,
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            itemCount: allSearchResults.length + 1, // + 1 for loading circle
            itemBuilder: (BuildContext content, int index) {
              numberOfBuilds++;

              if (index == allSearchResults.length) {
                return listeningUsersProvider.isEndOfSearchedListReached &&
                        listeningSearchChallengesProvider
                            .isEndOfSearchedListReached
                    ? SpaceColumnComponent(
                        child: ListItemInviteFriendsComponent(
                        username: _usersProvider.user.username,
                      ))
                    : const Center(
                        child: SpaceColumnComponent(
                            child: LoadingCircleComponent()),
                      );
              }

              if (allSearchResults[index] is ChallengeModel) {
                ChallengeModel challenge = allSearchResults[index];
                return SpaceColumnComponent(
                  child: ListItemChallengeSmallComponent(
                    onTap: () => _onTapAllEntry(index: index),
                    challenge: challenge,
                    isSearch: true,
                  ),
                );
              }

              UserModel user = allSearchResults[index];
              return SpaceColumnComponent(
                child: ListItemUserComponent(
                  onTap: () => _onTapAllEntry(index: index),
                  user: user,
                  isSearch: true,
                ),
              );
            }),
      ),
    );
  }

  onTapChallenge({required int index}) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchChallengePage(
          initChallengeIndex: index,
          searchText: textEditingController.text,
          categories: widget.categories,
        ),
      ),
    ).then((value) => setState(
          () {},
        ));
  }

  _onTapAllEntry({required int index}) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchAllPage(
          initialIndex: index,
          searchText: textEditingController.text,
          getList: _getAllList,
          getPagination: () {
            searchChallengesProvider.getSearchedPaginated(
                searchText: textEditingController.text,
                categories: widget.categories);
            _usersProvider.getSearchedPaginated(
                searchText: textEditingController.text);
          },
        ),
      ),
    ).then((value) => setState(
          () {},
        ));
  }

  List<dynamic> _getAllList() {
    List<dynamic> allSearchResults = [
      ...listeningSearchChallengesProvider.searchChallenges,
      ...listeningUsersProvider.searchUsers,
    ];

    AllSearchResultsType.sortList(allSearchResults);
    return allSearchResults;
  }

  onTapUser({required UserModel user, required int index}) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchUserPage(
          getUsersList: () => searchedUsers,
          initUserId: user.id,
          searchText: textEditingController.text,
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
          challenge: ChallengeModel.empty(title: textEditingController.text),
          isNewChallenge: true,
          isSearchNewChallenge: true,
        ),
      ),
    ).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _onChangeList(String searchText) async {
    await searchChallengesProvider.getSearchedPaginated(
        searchText: searchText, categories: widget.categories, isInit: true);
    await _usersProvider.getSearchedPaginated(
        searchText: searchText, isInit: true);
  }

  buildRecentSearches() {
    return RefreshIndicatorComponent(
      scrollController: scrollController,
      onRefresh: () async {
        await _usersProvider.getUser();
      },
      child: CupertinoScrollbar(
        controller: scrollController,
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            itemCount:
                max(listeningUsersProvider.user.recentSearches.length, 1),
            itemBuilder: (BuildContext content, int index) {
              numberOfBuilds++;

              if (listeningUsersProvider.user.recentSearches.isEmpty) {
                return const SpaceColumnComponent(
                  child: ListItemInfoComponent(
                    text: 'No recent searches',
                  ),
                );
              }
              String recentSearch =
                  listeningUsersProvider.user.recentSearches[index];
              return SpaceColumnComponent(
                child: ListItemRecentSearchComponent(
                  onTap: () async {
                    await _onChangeList(recentSearch);
                    setState(() {
                      textEditingController.text = recentSearch;
                    });
                  },
                  onTapActionIcon: () =>
                      _usersProvider.removeRecentSearch(recentSearch),
                  recentSearch: recentSearch,
                ),
              );
            }),
      ),
    );
  }
}
