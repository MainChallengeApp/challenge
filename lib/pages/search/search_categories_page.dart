import 'dart:convert';

import 'package:challenge/components/categories/category_component.dart';
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/pages/search/search_list_page.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/models/challenge_model.dart';

import 'package:challenge/components/navigation/no_animation_page_route_component.dart';
import 'search_challenge_page.dart';

class SearchCategoriesPage extends StatefulWidget {
  const SearchCategoriesPage(
      {super.key, required this.title, required this.selectTab});
  final String title;
  final Function selectTab;

  @override
  State<SearchCategoriesPage> createState() => _SearchCategoriesPageState();
}

class _SearchCategoriesPageState extends State<SearchCategoriesPage> {
  late List<ChallengeModel> challenges;
  late List<ChallengeModel> filteredChallenges;
  final ScrollController scrollController = ScrollController();

  String searchBarText = "";

  @override
  void initState() {
    super.initState();
    getChallenges(context).then((value) => challenges = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBarComponent(preTitle: widget.title, isFirstPageInRoute: true),
        body: Container(
          color: Colors.white,
          child: _buildList(),
        ));
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
          itemCount: categories.length + 1, //  + 1 for searchbar
          // separatorBuilder: (context, index) => const SizedBox( // doesnt work properly with scrollbar (scrollbar jumps around)
          //       height: 17,
          //     ),
          itemBuilder: (BuildContext content, int index) {
            if (index == 0) {
              return Column(
                // cloumn instead of seperator
                children: [
                  GestureDetector(
                    onTap: onTapSearchbar,
                    child: ListItemSearchbarComponent(
                      changeList: changeList,
                      isEnabled: false,
                      textEditingController:
                          TextEditingController(text: searchBarText),
                      hintText: 'Search for new Challenges...',
                    ),
                  ),
                  const SpaceComponent()
                ],
              );
            } else if (index == 1) {
              return Column(
                children: [
                  Row(
                    children: [
                      const SpaceComponent(
                        width: 20,
                      ),
                      Expanded(
                          child: CategoryComponent(
                        text: 'Mental',
                        imagePath: 'assets/images/categories/mental_health.png',
                        onTap: onTapMental,
                      )),
                      const SpaceComponent(),
                      Expanded(
                          child: CategoryComponent(
                        text: 'Physical',
                        imagePath:
                            'assets/images/categories/physical_health.png',
                        onTap: onTapPhysical,
                      )),
                      const SpaceComponent(
                        width: 20,
                      ),
                    ],
                  ),
                  const SpaceComponent()
                ],
              );
            } else if (index == 2) {
              return Column(
                children: [
                  Row(
                    children: [
                      const SpaceComponent(
                        width: 20,
                      ),
                      Expanded(
                          child: CategoryComponent(
                        text: 'Learning',
                        imagePath: 'assets/images/categories/knowledge.png',
                        onTap: onTapLearning,
                      )),
                      const SpaceComponent(),
                      Expanded(
                          child: CategoryComponent(
                        text: 'Social',
                        imagePath: 'assets/images/categories/social.png',
                        onTap: onTapSocial,
                      )),
                      const SpaceComponent(
                        width: 20,
                      ),
                    ],
                  ),
                  const SpaceComponent()
                ],
              );
            } else if (index == 3) {
              return Column(
                children: [
                  Row(
                    children: [
                      const SpaceComponent(
                        width: 20,
                      ),
                      Expanded(
                          child: CategoryComponent(
                        text: 'Other',
                        imagePath: 'assets/images/categories/other2.png',
                        onTap: onTapOther,
                      )),
                      const SpaceComponent(),
                      Expanded(
                          child: CategoryComponent(
                        text: 'Random',
                        imagePath:
                            'assets/images/categories/recommendation.png',
                        onTap: onTapRandom,
                      )),
                      const SpaceComponent(
                        width: 20,
                      ),
                    ],
                  ),
                  const SpaceComponent()
                ],
              );
            }
            return Container();
          }),
    );
  }

  static Future<List<ChallengeModel>> getChallenges(
      BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/search_challenges.json');

    final body = json.decode(data);
    return body.map<ChallengeModel>((e) => ChallengeModel.fromJson(e)).toList();
  }

  changeList(String value) {
    setState(() {
      // challengesFutures = getChallenges(context);
      searchBarText = value;
    });
  }

  void onTapSearchbar() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchListPage(
          title: 'All Challenges',
          preTitle: 'Search',
          selectTab: widget.selectTab,
          isFirstPageInRoute: false,
          initialSearchText: searchBarText,
          isSearchBarAutoFocus: true,
        ),
      ),
    );
  }

  void onTapAllChallenges() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchListPage(
          title: 'Search/All Challenges',
          selectTab: widget.selectTab,
          isFirstPageInRoute: false,
        ),
      ),
    );
  }

  void onTapMental() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchListPage(
          title: 'Mental',
          preTitle: 'Search',
          selectTab: widget.selectTab,
          isFirstPageInRoute: false,
          categories: const [ChallengeCategoryEnum.mentalHealth],
        ),
      ),
    );
  }

  void onTapPhysical() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchListPage(
          title: 'Physical',
          preTitle: 'Search',
          selectTab: widget.selectTab,
          isFirstPageInRoute: false,
          categories: const [ChallengeCategoryEnum.physicalHealth],
        ),
      ),
    );
  }

  void onTapLearning() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchListPage(
          title: 'Learning',
          preTitle: 'Search',
          selectTab: widget.selectTab,
          isFirstPageInRoute: false,
          categories: const [ChallengeCategoryEnum.knowledge],
        ),
      ),
    );
  }

  void onTapSocial() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchListPage(
          title: 'Social',
          preTitle: 'Search',
          selectTab: widget.selectTab,
          isFirstPageInRoute: false,
          categories: const [ChallengeCategoryEnum.social],
        ),
      ),
    );
  }

  void onTapOther() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchListPage(
          title: 'Other',
          preTitle: 'Search',
          selectTab: widget.selectTab,
          isFirstPageInRoute: false,
          categories: const [ChallengeCategoryEnum.other],
        ),
      ),
    );
  }

  void onTapRandom() {
    List<ChallengeModel> challengesCopy = challenges;
    challengesCopy.shuffle();
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchChallengePage(
          title: 'Search/Random',
          selectTab: widget.selectTab,
          challenge: challengesCopy[0],
          challenges: challengesCopy,
          initialChalleneIndex: 0,
        ),
      ),
    );
  }
}
