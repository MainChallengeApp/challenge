import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/providers/search_challenges_provider.dart';
import 'package:challenge/ui/components/categories/category_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/search/search_list_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'search_challenge_page.dart';

class SearchCategoriesPage extends StatefulWidget {
  const SearchCategoriesPage({super.key, required this.title});
  final String title;

  @override
  State<SearchCategoriesPage> createState() => _SearchCategoriesPageState();
}

class _SearchCategoriesPageState extends State<SearchCategoriesPage> {
  late List<ChallengeModel> challenges;
  final ScrollController scrollController = ScrollController();

  late final searchChallengesProvider =
      Provider.of<SearchChallengesProvider>(context, listen: false);

  String searchBarText = '';

  @override
  void initState() {
    super.initState();
    searchChallengesProvider.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(preTitle: widget.title, isFirstPageInRoute: true),
      body: Container(
        color: Colors.white,
        child: _buildList(),
      ),
      bottomNavigationBar: const BottomNavigationComponent(),
    );
  }

  Widget _buildList() {
    List<ChallengeCategoryEnum> categories = ChallengeCategoryEnum.values;
    return RawScrollbar(
      controller: scrollController,
      radius: const Radius.circular(4),
      thumbColor: themeColor3,
      padding: const EdgeInsets.only(right: 4),
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemCount: categories.length + 1, //  + 1 for searchBar
          itemBuilder: (BuildContext content, int index) {
            if (index == 0) {
              return SpaceColumnComponent(
                child: ListItemSearchBarComponent(
                  onTap: onTapSearchBar,
                  changeList: changeList,
                  isEnabled: false,
                  textEditingController:
                      TextEditingController(text: searchBarText),
                  hintText: 'Search for new Challenges...',
                ),
              );
            } else if (index == 1) {
              return SpaceColumnComponent(
                  child: Row(
                children: [
                  const SpaceComponent(
                    width: 20,
                  ),
                  mental(),
                  const SpaceComponent(),
                  physical(),
                  const SpaceComponent(
                    width: 20,
                  ),
                ],
              ));
            } else if (index == 2) {
              return SpaceColumnComponent(
                  child: Row(
                children: [
                  const SpaceComponent(
                    width: 20,
                  ),
                  social(),
                  const SpaceComponent(),
                  other(),
                  const SpaceComponent(
                    width: 20,
                  ),
                ],
              ));
            } else if (index == 3) {
              return SpaceColumnComponent(
                  child: Row(
                children: [
                  const SpaceComponent(
                    width: 20,
                  ),
                  newChallenge(),
                  const SpaceComponent(),
                  shuffle(),
                  const SpaceComponent(
                    width: 20,
                  ),
                ],
              ));
            }
            return Container();
          }),
    );
  }

  Expanded shuffle() {
    return Expanded(
        child: CategoryComponent(
      text: 'Shuffle',
      icon: IconEnum.shuffle.icon,
      onTap: onTapRandom,
    ));
  }

  Expanded newChallenge() {
    return Expanded(
        child: CategoryComponent(
      text: 'New\nChallenge',
      icon: IconEnum.newChallenge.icon,
      onTap: () => onTapNewChallenge(),
    ));
  }

  Expanded other() {
    return Expanded(
        child: CategoryComponent(
      text: 'Other',
      imagePath: 'assets/images/categories/other.png',
      onTap: () => onTapCategory(const [ChallengeCategoryEnum.other], 'Other'),
    ));
  }

  Expanded social() {
    return Expanded(
        child: CategoryComponent(
      text: 'Social',
      imagePath: 'assets/images/categories/social.png',
      onTap: () =>
          onTapCategory(const [ChallengeCategoryEnum.social], 'Social'),
    ));
  }

  Expanded physical() {
    return Expanded(
        child: CategoryComponent(
      text: 'Physical',
      imagePath: 'assets/images/categories/physical_health.png',
      onTap: () => onTapCategory(
          const [ChallengeCategoryEnum.physicalHealth], 'Physical'),
    ));
  }

  Expanded mental() {
    return Expanded(
        child: CategoryComponent(
      text: 'Mental',
      imagePath: 'assets/images/categories/mental_health.png',
      onTap: () =>
          onTapCategory(const [ChallengeCategoryEnum.mentalHealth], 'Mental'),
    ));
  }

  changeList(String value) {
    setState(() {
      searchBarText = value;
    });
  }

  void onTapSearchBar() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchListPage(
            title: 'All Challenges',
            preTitle: 'Search',
            isFirstPageInRoute: false,
            initialSearchText: searchBarText,
            isSearchBarAutoFocus: true),
      ),
    );
  }

  void onTapCategory(List<ChallengeCategoryEnum> categories, String title) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchListPage(
          title: title,
          preTitle: 'Search',
          isFirstPageInRoute: false,
          categories: categories,
        ),
      ),
    );
  }

  void onTapRandom() {
    List<ChallengeModel> challengesCopy =
        searchChallengesProvider.searchChallenges;
    challengesCopy.shuffle();
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchChallengePage(
          title: 'Search/Shuffle',
          initChallenge: challengesCopy[0],
          challenges: challengesCopy,
          initChallengeIndex: 0,
        ),
      ),
    );
  }

  onTapNewChallenge() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => EditChallengePage(
          preTitle: widget.title,
          challenge: ChallengeModel.empty(),
          isNewChallenge: true,
          isSearchNewChallenge: true,
        ),
      ),
    ).then((_) => setState(() {}));
  }
}
