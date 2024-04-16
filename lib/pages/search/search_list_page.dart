import 'dart:convert';

import 'package:challenge/pages/components/navigation/app_bar_component.dart';
import 'package:challenge/pages/components/simple_components/space_component.dart';
import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/pages/components/list_items/list_item_challenge_small_component.dart';
import 'package:challenge/pages/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/models/challenge_model.dart';

import 'package:challenge/pages/components/navigation/no_animation_page_route_component.dart';
import 'search_challenge_page.dart';

class SearchListPage extends StatefulWidget {
  const SearchListPage(
      {super.key,
      this.preTitle = "",
      required this.title,
      this.onPush,
      required this.selectTab,
      this.isFirstPageInRoute = true,
      this.initialSearchText = "",
      this.isSearchBarAutoFocus = false,
      this.categories = const []});
  final String preTitle;
  final String title;
  final ValueChanged<ChallengeModel>? onPush;
  final Function selectTab;
  final bool isFirstPageInRoute;
  final String initialSearchText;
  final bool isSearchBarAutoFocus;
  final List<ChallengeCategoryEnum> categories;

  @override
  State<SearchListPage> createState() => _SearchListPageState();
}

class _SearchListPageState extends State<SearchListPage> {
  late Future<List<ChallengeModel>> challengesFutures;
  late List<ChallengeModel> filteredChallenges;
  final ScrollController scrollController = ScrollController();

  String searchBarText = "";

  @override
  void initState() {
    super.initState();
    challengesFutures = getChallenges(context);
    searchBarText = widget.initialSearchText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent(
            preTitle: widget.preTitle,
            titleText: widget.title,
            isFirstPageInRoute: widget.isFirstPageInRoute),
        body: Container(
          color: Colors.white,
          child: _buildList(),
        ));
  }

  Widget _buildList() {
    return FutureBuilder(
        future: challengesFutures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            filteredChallenges = snapshot.data!
                .where((element) => element.isInCategories(widget.categories))
                .where((element) => element.searchInChallenge(searchBarText))
                .toList();
            filteredChallenges.sort((a, b) =>
                a.title.toLowerCase().compareTo(b.title.toLowerCase()));

            return RawScrollbar(
              controller: scrollController,
              radius: const Radius.circular(4),
              thumbColor: themeColor3,
              padding: const EdgeInsets.only(right: 4),
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount:
                      filteredChallenges.length + 1, //  + 1 for searchbar
                  itemBuilder: (BuildContext content, int index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          ListItemSearchbarComponent(
                            autoFocus: widget.isSearchBarAutoFocus,
                            changeList: changeList,
                            textEditingController:
                                TextEditingController(text: searchBarText),
                            hintText: 'Search for new Challenges...',
                          ),
                          const SpaceComponent()
                        ],
                      );
                    }
                    ChallengeModel challenge =
                        filteredChallenges[index - 1]; // - 1 for searchbar
                    return Column(
                      children: [
                        ListItemChallengeSmallComponent(
                          onTap: () => onTapChallenge(
                              challenge: challenge,
                              index:
                                  index - 1), // widget.onPush?.call(challenge),
                          challenge: challenge,
                          isSearch: true,
                        ),
                        const SpaceComponent()
                      ],
                    );
                  }),
            );
          } else {
            return const Center(child: Text('Error with loading data...'));
          }
        });
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

  onTapChallenge({required ChallengeModel challenge, required int index}) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => SearchChallengePage(
          title: '${widget.preTitle}/${widget.title}',
          initChallenge: challenge,
          selectTab: widget.selectTab,
          challenges: filteredChallenges,
          initChalleneIndex: index,
        ),
      ),
    ).then((value) => setState(
          () {},
        ));
  }
}
