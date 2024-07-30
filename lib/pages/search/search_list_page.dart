import 'dart:convert';

import 'package:challenge/components/list_items/list_item_challenge_small_component.dart';
import 'package:challenge/components/list_items/list_item_icon_small_component.dart';
import 'package:challenge/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:challenge/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/components/simple_components/space_column_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:flutter/material.dart';

import 'search_challenge_page.dart';

class SearchListPage extends StatefulWidget {
  final String preTitle;
  final String title;
  final ValueChanged<ChallengeModel>? onPush;
  final bool isFirstPageInRoute;
  final String initialSearchText;
  final bool isSearchBarAutoFocus;
  final List<ChallengeModel> challenges;

  const SearchListPage(
      {super.key,
      this.preTitle = '',
      required this.title,
      this.onPush,
      this.isFirstPageInRoute = true,
      this.initialSearchText = '',
      this.isSearchBarAutoFocus = false,
      required this.challenges});

  @override
  State<SearchListPage> createState() => _SearchListPageState();
}

class _SearchListPageState extends State<SearchListPage> {
  late Future<List<ChallengeModel>> challengesFutures;
  late List<ChallengeModel> filteredChallenges;
  final ScrollController scrollController = ScrollController();

  String searchBarText = '';

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
        ),
        bottomNavigationBar: const BottomNavigationComponent());
  }

  Widget _buildList() {
    filteredChallenges = widget.challenges
        .where((element) => element.searchInChallenge(searchBarText))
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
          itemCount: filteredChallenges.length +
              1 +
              1, //  + 1 for searchBar + 1 for new Challenge
          itemBuilder: (BuildContext content, int index) {
            if (index == 0) {
              return Column(
                children: [
                  ListItemSearchBarComponent(
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

            if (index == filteredChallenges.length + 1) {
              return SpaceColumnComponent(
                  child: ListItemIconSmallComponent(
                onTap: onTapNewChallenge,
                icon: Icons.add,
                title: searchBarText == '' ? 'New Challenge' : searchBarText,
              ));
            }

            ChallengeModel challenge =
                filteredChallenges[index - 1]; // - 1 for searchBar
            return SpaceColumnComponent(
              child: ListItemChallengeSmallComponent(
                onTap: () => onTapChallenge(
                    challenge: challenge,
                    index: index - 1), // widget.onPush?.call(challenge),
                challenge: challenge,
                isSearch: true,
              ),
            );
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
