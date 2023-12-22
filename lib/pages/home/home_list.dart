import 'package:challenge/components/edit_challenge/edit_challenge.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/models/acceptance_criteria.dart';
import 'package:challenge/pages/home/home_challenge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/components/list_items/list_item_challenge_small.dart';
import 'package:challenge/components/list_items/list_item_icon_small.dart';
import 'package:challenge/components/list_items/list_item_search_bar.dart';
import 'package:challenge/models/challenge.dart';

import '../../components/navigation/no_animation_page_route.dart';
import '../../enums/challenge_status.dart';
import '../../models/activity.dart';

class HomeList extends StatefulWidget {
  const HomeList({super.key, required this.title, this.onPush});
  final String title;
  final ValueChanged<Challenge>? onPush;

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  late Future<List<Challenge>> challengesFutures;
  ChallengeController challengeController = ChallengeController();

  ScrollController scrollController = ScrollController();

  String searchBarText = "";

  @override
  void initState() {
    super.initState();
    challengesFutures = challengeController.readFile(context);
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
            allChallengesList = snapshot.data!;
            challengeList = snapshot.data!
                .where((element) => element.searchInChallenge(searchBarText))
                .toList();

            return RawScrollbar(
              controller: scrollController,
              radius: const Radius.circular(4),
              thumbColor: themeColor3,
              padding: const EdgeInsets.only(right: 4),
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount: challengeList.length +
                      1 +
                      1, // +1 for new Challenge listitem + 1 for searchbar
                  // separatorBuilder: (context, index) => const SizedBox(
                  //       height: 17,
                  //     ),
                  itemBuilder: (BuildContext content, int index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          ListItemSearchbar(
                            changeList: changeList,
                          ),
                          const SizedBox(
                            height: 17,
                          )
                        ],
                      );
                    }
                    if (index == 1) {
                      return Column(
                        children: [
                          ListItemIconSmall(
                            onTap: () => tapOnNewChallenge(),
                            icon: Icons.add_rounded,
                            title: "New Challenge",
                          ),
                          const SizedBox(
                            height: 17,
                          )
                        ],
                      );
                    }
                    // if (index == challengeList.length + 1 + 1) {
                    //   return Container(); // +1 for new Challenge listitem + 1 for searchbar
                    // }
                    Challenge challenge = challengeList[index -
                        1 -
                        1]; // -1 for new Challenge listitem - 1 for searchbar
                    return Column(
                      children: [
                        ListItemChallengeSmall(
                          onTap: () => ppush(context,
                              challenge: challenge, index: index - 1 - 1),
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

  changeList(String value) {
    setState(() {
      // challengesFutures = getChallenges(context);
      searchBarText = value;
    });
  }

  void ppush(BuildContext context,
      {required Challenge challenge, required int index}) {
    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) => HomeChallenge(
            preTitle: widget.title,
            challenge: challenge,
            initialChalleneIndex: index),
      ),
    ).then((_) => setState(() {}));
  }

  tapOnNewChallenge() {
    AcceptanceCriteria acceptanceCriteria = AcceptanceCriteria(
        id: null,
        activity: Activity(title: '', amount: 0, unit: ''),
        frequence: 'once',
        tracking: 'camera',
        progress: 0,
        evidences: []);
    final Challenge challenge = Challenge(
        status: ChallengeStatus.inProgress,
        title: '',
        description: '',
        thumbnailPath: '',
        startDate: null,
        endDate: null,
        acceptanceCriteria: [acceptanceCriteria],
        media: []);

    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) => EditChallenge(
          title: widget.title,
          challenge: challenge,
          homeListSetState: homeListSetState,
          isNewChallenge: true,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  homeListSetState() {
    setState(() {});
  }
}
