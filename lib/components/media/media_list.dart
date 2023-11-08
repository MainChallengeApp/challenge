import 'package:challenge/components/media/list_item_media_small.dart';
import 'package:challenge/components/media/media_detail.dart';
import 'package:challenge/components/navigation/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:challenge/components/list_items/list_item_icon_small.dart';
import 'package:challenge/components/list_items/list_item_search_bar.dart';
import 'package:challenge/models/challenge.dart';
import 'package:provider/provider.dart';

import '../../models/media.dart';
import '../../providers/design_provider.dart';

class MediaList extends StatefulWidget {
  const MediaList(
      {super.key,
      required this.preTitle,
      this.tapOnNewChallenge,
      required this.challenge});
  final String preTitle;
  final Function? tapOnNewChallenge;
  final Challenge challenge;

  @override
  State<MediaList> createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  String searchBarText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomeAppBar.build(preTitle: widget.preTitle, title: 'Media'),
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: _buildList(),
        ));
  }

  Widget _buildList() {
    List<Media> mediaList = widget.challenge.media
        .where((element) => element.title.contains(searchBarText))
        .toList(); //.where((e) => e.title.contains(searchBarText))

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
              onTap: () => 0, // not yet implemented
              icon: Icons.add,
              title: "Upload Media",
            );
          }
          if (index == mediaList.length + 1 + 1) {
            return Container(); // +1 for new Challenge listitem + 1 for searchbar
          }
          return ListItemMediaSmall(
            onTap: () => ppush(context, index: index - 1 - 1),
            media: mediaList[index - 1 - 1],
          );
        });
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
        pageBuilder: (context, animation1, animation2) => MediaDetail(
          media: widget.challenge.media
              .where((element) => element.title.contains(searchBarText))
              .toList(),
          preTitle: '${widget.preTitle}/Media',
          initialMediaIdex: index,
        ),
      ),
    ).then((_) => setState(() {}));
  }
}
