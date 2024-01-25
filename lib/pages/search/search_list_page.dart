import 'dart:convert';

import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/components/list_items/list_item_challenge_small_component.dart';
import 'package:challenge/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/models/challenge_model.dart';

import 'package:challenge/components/navigation/no_animation_page_route_component.dart';
import 'search_challenge_page.dart';

class SearchListPage extends StatefulWidget {
  const SearchListPage(
      {super.key, required this.title, this.onPush, required this.selectTab});
  final String title;
  final ValueChanged<ChallengeModel>? onPush;
  final Function selectTab;

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
    return FutureBuilder(
        future: challengesFutures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            filteredChallenges = snapshot.data!
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
                  // separatorBuilder: (context, index) => const SizedBox( // doesnt work properly with scrollbar (scrollbar jumps around)
                  //       height: 17,
                  //     ),
                  itemBuilder: (BuildContext content, int index) {
                    if (index == 0) {
                      return Column(
                        // cloumn instead of seperator
                        children: [
                          ListItemSearchbarComponent(
                            changeList: changeList,
                            textEditingController:
                                TextEditingController(text: searchBarText),
                          ),
                          const SizedBox(
                            height: 17,
                          )
                        ],
                      );
                    }
                    // if (index == filteredChallenges.length + 1) {  // only for seperator...
                    //   return Container(); // + 1 for searchbar
                    // }
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
                        ),
                        const SizedBox(
                          height: 17,
                        )
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
          title: widget.title,
          challenge: challenge,
          selectTab: widget.selectTab,
          challenges: filteredChallenges,
          initialChalleneIndex: index,
        ),
      ),
    );
  }
}
