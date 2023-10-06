import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nested_navigation_demo_flutter/globals.dart';
import 'package:nested_navigation_demo_flutter/list_item_challenge_small.dart';
import 'package:nested_navigation_demo_flutter/list_item_icon_small.dart';
import 'package:nested_navigation_demo_flutter/list_item_search_bar.dart';
import 'package:nested_navigation_demo_flutter/models/challenge.dart';

class HomeList extends StatefulWidget {
  const HomeList(
      {super.key, required this.title, this.onPush, this.tapOnNewChallenge});
  final String title;
  final ValueChanged<Challenge>? onPush;
  final Function? tapOnNewChallenge;


  @override
  State<HomeList> createState() => _HomeListState();


}

class _HomeListState extends State<HomeList> {
  late Future<List<Challenge>> challengesFutures;

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
          leading: const Icon(Icons.chevron_left, color: Colors.transparent,),
          foregroundColor: Colors.black,
          title: Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.title,
              style: const TextStyle(color: Colors.black, fontSize: appBarFontSize),
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
            final challenges = snapshot.data!;

            return ListView.separated(
        itemCount: challenges.length + 1 + 1 + 1, // +1 for extra separator at the end +1 for new Challenge listitem + 1 for searchbar
        separatorBuilder: (context, index) => const SizedBox(height: 17,),
        itemBuilder: (BuildContext content, int index) {
          if(index == 0) return const ListItemSearchbar();
          if(index == 1) return ListItemIconSmall(onTap:  () => widget.tapOnNewChallenge!.call(), icon: Icons.plus_one, title: "new Challenge",);
          if (index == challenges.length + 1 + 1) return Container(); // +1 for new Challenge listitem + 1 for searchbar
          Challenge challenge = challenges[index - 1 -1 ];  // -1 for new Challenge listitem - 1 for searchbar
          return ListItemChallengeSmall(
            onTap: () => widget.onPush?.call(challenge),
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
    final data = await assetBundle.loadString('assets/home_challenges.json');

    final body = json.decode(data);
    return body.map<Challenge>(Challenge.fromJson).toList();
  }
}
