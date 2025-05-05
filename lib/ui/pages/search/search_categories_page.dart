import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/search_filter_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/providers/search_challenges_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/categories/category_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/search/search_list_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  final searchChallengesProvider = getIt<SearchChallengesProvider>();
  final _tabProvider = getIt<TabProvider>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
      appBar: AppBarComponent(title: widget.title, isFirstPageInRoute: true),
      body: Container(
        color: Colors.white,
        child: _buildCategories(),
      ),
    );
  }

  Widget _buildCategories() {
    return CupertinoScrollbar(
      controller: scrollController,
      child: Column(
        children: [
          SpaceColumnComponent(
            child: ListItemSearchBarComponent(
              onTap: onTapSearchBar,
              isEditable: false,
              textEditingController: TextEditingController(),
              hintText: 'Search for Challenges and Users',
            ),
          ),
          Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              children: [
                SpaceColumnComponent(
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
                )),
                SpaceColumnComponent(
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
                )),
                SpaceColumnComponent(
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
                ))
              ],
            ),
          ),
        ],
      ),
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

  void onTapSearchBar() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => const SearchListPage(
            isUserSearchActive: true, isSearchBarAutoFocus: true),
      ),
    );
  }

  void onTapCategory(List<ChallengeCategoryEnum> categories, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchListPage(
          title: title,
          categories: categories,
          initialSearchFilter: SearchFilterEnum.challenges,
        ),
      ),
    );
  }

  void onTapRandom() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchChallengePage(
          title: 'Shuffle',
          initChallengeIndex: 0,
          searchText: '',
          categories: [],
          isRandom: true,
        ),
      ),
    );
  }

  onTapNewChallenge() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditChallengePage(
          challenge: ChallengeModel.empty(),
          isNewChallenge: true,
        ),
      ),
    ).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
      if (mounted) {
        setState(() {});
      }
    });
  }
}
