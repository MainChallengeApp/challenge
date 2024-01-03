import 'dart:convert';

import 'package:challenge/components/navigation/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/components/list_items/list_item_challenge_small.dart';
import 'package:challenge/components/list_items/list_item_search_bar.dart';
import 'package:challenge/models/challenge.dart';

import 'package:challenge/components/navigation/no_animation_page_route.dart';
import 'search_challenge.dart';

class SearchList extends StatefulWidget {
  const SearchList(
      {super.key, required this.title, this.onPush, required this.selectTab});
  final String title;
  final ValueChanged<Challenge>? onPush;
  final Function selectTab;

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  late Future<List<Challenge>> challengesFutures;
  late List<Challenge> filteredChallenges;
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
        appBar: CustomeAppBar(preTitle: widget.title, isFirstPage: true),
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
            return const CircularProgressIndicator();
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
                          ListItemSearchbar(changeList: changeList),
                          const SizedBox(
                            height: 17,
                          )
                        ],
                      );
                    }
                    // if (index == filteredChallenges.length + 1) {  // only for seperator...
                    //   return Container(); // + 1 for searchbar
                    // }
                    Challenge challenge =
                        filteredChallenges[index - 1]; // - 1 for searchbar
                    return Column(
                      children: [
                        ListItemChallengeSmall(
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
            return const Text('Error with loading data...');
          }
        });
  }

  static Future<List<Challenge>> getChallenges(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/search_challenges.json');

    final body = json.decode(data);
    return body.map<Challenge>((e) => Challenge.fromJson(e)).toList();
  }

  changeList(String value) {
    setState(() {
      // challengesFutures = getChallenges(context);
      searchBarText = value;
    });
  }

  onTapChallenge({required Challenge challenge, required int index}) {
    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) => SearchChallenge(
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
