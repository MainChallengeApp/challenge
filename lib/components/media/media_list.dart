import 'dart:convert';

import 'package:challenge/components/media/list_item_media_small.dart';
import 'package:challenge/components/media/media_detail.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/components/list_items/list_item_icon_small.dart';
import 'package:challenge/components/list_items/list_item_search_bar.dart';
import 'package:challenge/models/challenge.dart';
import 'package:provider/provider.dart';

import '../../providers/design_provider.dart';

class MediaList extends StatefulWidget {
  const MediaList(
      {super.key, required this.preTitle, this.tapOnNewChallenge, required this.challenge});
  final String preTitle;
  final Function? tapOnNewChallenge;
  final Challenge challenge;

  @override
  State<MediaList> createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  late Future<List<Challenge>> challengesFutures;

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
          foregroundColor: Colors.black,
          titleSpacing: 0,
          title: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  '${widget.preTitle}/Media',
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
            challengeList = snapshot.data!
                .where((element) => element.title.contains(searchBarText))
                .toList();

            List<Media> mediaList = widget.challenge.media.where((element) => element.title.contains(searchBarText)).toList(); //.where((e) => e.title.contains(searchBarText))

            return ListView.separated(
                itemCount: mediaList.length +
                    1 +
                    1 +
                    1, // +1 for extra separator at the end +1 for new Challenge listitem + 1 for searchbar
                separatorBuilder: (context, index) => const SizedBox(
                      height: 17,
                    ),
                itemBuilder: (BuildContext content, int index) {
                  if (index == 0) {
                    return ListItemSearchbar(
                      changeList: changeList,
                    );
                  }
                  if (index == 1) {
                    return ListItemIconSmall(
                      onTap: () => widget.tapOnNewChallenge!.call(),
                      icon: Icons.add,
                      title: "Upload Media",
                    );
                  }
                  if (index == mediaList.length + 1 + 1) {
                    return Container(); // +1 for new Challenge listitem + 1 for searchbar
                  }
                  return ListItemMediaSmall(
                    onTap: () => ppush(context, index: index-1-1),
                    media: mediaList[index - 1 - 1],
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

  changeList(String value) {
    setState(() {
      // challengesFutures = getChallenges(context);
      searchBarText = value;
    });
  }

  void ppush(BuildContext context, {required int index}) {
    context.read<DesignProvider>().setIsBottomNavBarVisible(false);
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) =>
            MediaDetail(media: widget.challenge.media, preTitle: '${widget.preTitle}/Media', initialMediaIdex: index,),
      ),
    ).then((_) => setState(() {}));
  }
}
