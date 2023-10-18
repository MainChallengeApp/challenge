import 'dart:convert';

import 'package:challenge/components/media/acceptance_criteria_record_list.dart';
import 'package:challenge/components/media/list_item_acceptance_criteria_bar.dart';
import 'package:challenge/components/media/list_item_media_small.dart';
import 'package:challenge/components/navigation/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/components/list_items/list_item_icon_small.dart';
import 'package:challenge/models/challenge.dart';
import 'package:provider/provider.dart';

import '../../providers/design_provider.dart';

class AcceptanceCriteriaMediaList extends StatefulWidget {
  const AcceptanceCriteriaMediaList(
      {super.key,
      required this.preTitle,
      this.tapOnNewChallenge,
      required this.challenge,
      required this.mediaList,
      required this.acceptanceCriteria});
  final String preTitle;
  final Function? tapOnNewChallenge;
  final Challenge challenge;
  final List<Media> mediaList;
  final AcceptanceCriteria acceptanceCriteria;

  @override
  State<AcceptanceCriteriaMediaList> createState() =>
      _AcceptanceCriteriaMediaListState();
}

class _AcceptanceCriteriaMediaListState
    extends State<AcceptanceCriteriaMediaList> {
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
        appBar: CustomeAppBar.build(preTitle: widget.preTitle, title: 'Media'),
        backgroundColor: Colors.white,
        body: Stack(
          children: [_buildList(), button()],
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

            return ListView.separated(
                itemCount: widget.mediaList.length +
                    1 +
                    1 +
                    1, // +1 for extra separator at the end +1 for new Challenge listitem + 1 for searchbar
                separatorBuilder: (context, index) => const SizedBox(
                      height: 17,
                    ),
                itemBuilder: (BuildContext content, int index) {
                  if (index == 0) {
                    return ListItemAcceptanceCriteriaBar(
                        acceptanceCriteria: widget.acceptanceCriteria);
                  }
                  if (index == 1) {
                    return ListItemIconSmall(
                      onTap: () => widget.tapOnNewChallenge!.call(),
                      icon: Icons.add,
                      title: "Upload Media",
                    );
                  }
                  if (index == widget.mediaList.length + 1 + 1) {
                    return Container(); // +1 for new Challenge listitem + 1 for searchbar
                  }
                  return ListItemMediaSmall(
                    onTap: () => ppush(context, index: index - 1 - 1),
                    media: widget.mediaList[index - 1 - 1],
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
    // Navigator.push(
    //   context,
    //   PageRouteBuilder(
    //     transitionDuration: Duration.zero,
    //     reverseTransitionDuration: Duration.zero,
    //     pageBuilder: (context, animation1, animation2) =>
    //         MediaDetail(media: widget.challenge.media.where((element) => element.title.contains(searchBarText)).toList(), preTitle: '${widget.preTitle}/Media', initialMediaIdex: index,),
    //   ),
    // ).then((_) => setState(() {}));
  }

  button() {
    return GestureDetector(
      onTap: () {
        // Navigator.pop(context);
        // Navigator.pop(context);

        // context.read<DesignProvider>().setIsBottomNavBarVisible(false);

        widget.acceptanceCriteria.evidences.add(
          Evidence(progress: widget.acceptanceCriteria.progress, mediaIds: widget.mediaList.map((e) => e.id).toList())
        );

        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            pageBuilder: (context, animation1, animation2) =>
                AcceptanceCriteriaRecordList(
              preTitle: widget.preTitle,
              mediaList: widget.mediaList,
              acceptanceCriteria: widget.acceptanceCriteria,
              challenge: widget.challenge,
            ),
          ),
        ).then((_) => setState(() {}));
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 55,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: themeColor2,
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: const Center(
              child: Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          )),
        ),
      ),
    );
  }
}
