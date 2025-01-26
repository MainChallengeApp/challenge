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

  final ScrollController _scrollController = ScrollController();
  double _allScrollPosition = 0.0;
  double _challengesScrollPosition = 0.0;
  double _usersScrollPosition = 0.0;

  late final _searchChallengesProvider =
      Provider.of<SearchChallengesProvider>(context, listen: false);
  late final _listeningSearchChallengesProvider =
      Provider.of<SearchChallengesProvider>(context, listen: true);

  late final _usersProvider = getIt<UsersProvider>();
  late final _listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);
  final _tabProvider = getIt<TabProvider>();

  int _numberOfBuilds = 0;

  final _textEditingController = TextEditingController();

  late SearchFilterEnum _selectedSearchFilter = widget.initialSearchFilter;

  @override
  void initState() {
    super.initState();

    _searchChallengesProvider.initSearchChallenges(
        categories: widget.categories);
    if (widget.isUserSearchActive) {
      _usersProvider.getSearchedPaginated(isInit: true);
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        switch (_selectedSearchFilter) {
          case SearchFilterEnum.all:
            _searchChallengesProvider.getSearchedPaginated(
                searchText: _textEditingController.text,
                categories: widget.categories);
            _usersProvider.getSearchedPaginated(
                searchText: _textEditingController.text);
            break;
          case SearchFilterEnum.challenges:
            _searchChallengesProvider.getSearchedPaginated(
                searchText: _textEditingController.text,
                categories: widget.categories);
            break;
          case SearchFilterEnum.users:
            _usersProvider.getSearchedPaginated(
                searchText: _textEditingController.text);
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
                autoFocus: widget.isSearchBarAutoFocus && _numberOfBuilds == 0,
                textEditingController: _textEditingController,
                isUserSearchActive: widget.isUserSearchActive,
                initialSearchFilter: _selectedSearchFilter,
                onChangeList: _onChangeList,
                onTapFilter: _onTapFilter,
                onTapOutside: _onTapOutside,
              )),
              Expanded(
                  child: _textEditingController.text.isEmpty &&
                          widget.categories.isEmpty
                      ? buildRecentSearches()
                      : _selectedSearchFilter == SearchFilterEnum.challenges
                          ? _buildChallengesList()
                          : _selectedSearchFilter == SearchFilterEnum.users
                              ? _buildUsersList()
                              : _buildAllList())
            ],
          )),
    );
  }

  _onTapFilter(searchFilter) {
    // Save current scroll position
    switch (_selectedSearchFilter) {
      case SearchFilterEnum.all:
        _allScrollPosition = _scrollController.position.pixels;
        break;
      case SearchFilterEnum.challenges:
        _challengesScrollPosition = _scrollController.position.pixels;
        break;
      case SearchFilterEnum.users:
        _usersScrollPosition = _scrollController.position.pixels;
        break;
    }

    setState(() {
      _selectedSearchFilter = searchFilter;
    });

    // Schedule a callback to restore scroll position after the build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreScrollPosition();
    });
  }

  void _restoreScrollPosition() {
    switch (_selectedSearchFilter) {
      case SearchFilterEnum.all:
        _scrollController.jumpTo(_allScrollPosition);
        break;
      case SearchFilterEnum.challenges:
        _scrollController.jumpTo(_challengesScrollPosition);
        break;
      case SearchFilterEnum.users:
        _scrollController.jumpTo(_usersScrollPosition);
        break;
    }
  }

  _onTapOutside(PointerDownEvent _) async {
    String text = _textEditingController.text;
    if (text.isEmpty) {
      return;
    }
    _usersProvider.addRecentSearch(text);
  }

  Widget _buildChallengesList() {
    searchChallenges = _listeningSearchChallengesProvider.searchChallenges;

    return RefreshIndicatorComponent(
      scrollController: _scrollController,
      onRefresh: () async {
        await _searchChallengesProvider.getSearchedPaginated(
            searchText: _textEditingController.text,
            categories: widget.categories,
            isInit: true);
      },
      child: CupertinoScrollbar(
        controller: _scrollController,
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount: searchChallenges.length +
                1, // + 1 for loading circle or  new Challenge
            itemBuilder: (BuildContext content, int index) {
              _numberOfBuilds++;
              if (index == searchChallenges.length) {
                return _listeningSearchChallengesProvider
                        .isEndOfSearchedListReached
                    ? SpaceColumnComponent(
                        child: ListItemIconTextComponent(
                        onTap: onTapNewChallenge,
                        icon: Icons.add,
                        title: _textEditingController.text == ''
                            ? 'New Challenge'
                            : _textEditingController.text,
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
    searchedUsers = _listeningUsersProvider.searchUsers;
    return RefreshIndicatorComponent(
      scrollController: _scrollController,
      onRefresh: () async {
        await _usersProvider.getSearchedPaginated(
            searchText: _textEditingController.text, isInit: true);
      },
      child: CupertinoScrollbar(
        controller: _scrollController,
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount: searchedUsers.length + 1, // + 1 for loading circle
            itemBuilder: (BuildContext content, int index) {
              _numberOfBuilds++;

              if (index == searchedUsers.length) {
                return _listeningUsersProvider.isEndOfSearchedListReached
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
      scrollController: _scrollController,
      onRefresh: () async {
        await _onChangeList(_textEditingController.text);
      },
      child: CupertinoScrollbar(
        controller: _scrollController,
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount: allSearchResults.length + 1, // + 1 for loading circle
            itemBuilder: (BuildContext content, int index) {
              _numberOfBuilds++;

              if (index == allSearchResults.length) {
                return _listeningUsersProvider.isEndOfSearchedListReached &&
                        _listeningSearchChallengesProvider
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
      MaterialPageRoute(
        builder: (context) => SearchChallengePage(
          initChallengeIndex: index,
          searchText: _textEditingController.text,
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
      MaterialPageRoute(
        builder: (context) => SearchAllPage(
          initialIndex: index,
          searchText: _textEditingController.text,
          getList: _getAllList,
          getPagination: () {
            _searchChallengesProvider.getSearchedPaginated(
                searchText: _textEditingController.text,
                categories: widget.categories);
            _usersProvider.getSearchedPaginated(
                searchText: _textEditingController.text);
          },
        ),
      ),
    ).then((value) => setState(
          () {},
        ));
  }

  List<dynamic> _getAllList() {
    List<dynamic> allSearchResults = [
      ..._listeningSearchChallengesProvider.searchChallenges,
      ..._listeningUsersProvider.searchUsers,
    ];

    AllSearchResultsType.sortList(allSearchResults);
    return allSearchResults;
  }

  onTapUser({required UserModel user, required int index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchUserPage(
          getUsersList: () => searchedUsers,
          initUserId: user.id,
          searchText: _textEditingController.text,
        ),
      ),
    ).then((value) => setState(
          () {},
        ));
  }

  onTapNewChallenge() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditChallengePage(
          challenge: ChallengeModel.empty(title: _textEditingController.text),
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
    if (searchText.isEmpty) {
      setState(() {});
      return;
    }
    await _searchChallengesProvider.getSearchedPaginated(
        searchText: searchText,
        categories: widget.categories,
        isInit: true,
        shouldNotify: false);
    await _usersProvider.getSearchedPaginated(
        searchText: searchText, isInit: true, shouldNotify: false);
    setState(() {});
  }

  buildRecentSearches() {
    return RefreshIndicatorComponent(
      scrollController: _scrollController,
      onRefresh: () async {
        await _usersProvider.getUser();
      },
      child: CupertinoScrollbar(
        controller: _scrollController,
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount:
                max(_listeningUsersProvider.user.recentSearches.length, 1),
            itemBuilder: (BuildContext content, int index) {
              _numberOfBuilds++;

              if (_listeningUsersProvider.user.recentSearches.isEmpty) {
                return const SpaceColumnComponent(
                  child: ListItemInfoComponent(
                    text: 'No recent searches',
                  ),
                );
              }
              String recentSearch =
                  _listeningUsersProvider.user.recentSearches[index];
              return SpaceColumnComponent(
                child: ListItemRecentSearchComponent(
                  onTap: () async {
                    await _onChangeList(recentSearch);
                    setState(() {
                      _textEditingController.text = recentSearch;
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
