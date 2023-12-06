import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/components/list_items/list_item_challenge_small.dart';
import 'package:challenge/components/list_items/list_item_search_bar.dart';
import 'package:challenge/models/challenge.dart';

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

  String searchBarText = "";

  @override
  void initState() {
    super.initState();
    challengesFutures = getChallenges(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: const Icon(
            Icons.chevron_left,
            color: Colors.transparent,
          ),
          foregroundColor: Colors.black,
          titleSpacing: 0,
          title: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  widget.title,
                  style: const TextStyle(
                      color: Colors.black, fontSize: appBarFontSize),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
        ),
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

            return ListView.separated(
                itemCount: filteredChallenges.length +
                    1 +
                    1, // +1 for extra separator at the end +1 for new Challenge listitem + 1 for searchbar
                separatorBuilder: (context, index) => const SizedBox(
                      height: 17,
                    ),
                itemBuilder: (BuildContext content, int index) {
                  if (index == 0) {
                    return ListItemSearchbar(changeList: changeList);
                  }
                  if (index == filteredChallenges.length + 1) {
                    return Container(); // +1 for new Challenge listitem + 1 for searchbar
                  }
                  Challenge challenge = filteredChallenges[index -
                      1]; // -1 for new Challenge listitem - 1 for searchbar
                  return ListItemChallengeSmall(
                    onTap: () => onTapChallenge(
                        challenge: challenge,
                        index: index - 1), // widget.onPush?.call(challenge),
                    challenge: challenge,
                  );
                });
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
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) => SearchChallenge(
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
