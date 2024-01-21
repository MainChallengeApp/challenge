import 'package:challenge/components/navigation/app_bar.component.dart';
import 'package:challenge/pages/subpages/edit_challenge/edit_challenge.page.dart';
import 'package:challenge/json_file_controller/challenge.controller.dart';
import 'package:challenge/models/acceptance_criteria.model.dart';
import 'package:challenge/pages/home/home_challenge.page.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/components/list_items/list_item_challenge_small.component.dart';
import 'package:challenge/components/list_items/list_item_icon_small.component.dart';
import 'package:challenge/components/list_items/list_item_search_bar.component.dart';
import 'package:challenge/models/challenge.model.dart';

import 'package:challenge/components/navigation/no_animation_page_route.component.dart';
import 'package:challenge/enums/challenge_status.enum.dart';
import 'package:challenge/models/activity.model.dart';

class HomeListPage extends StatefulWidget {
  const HomeListPage({super.key, required this.title, this.onPush});
  final String title;
  final ValueChanged<ChallengeModel>? onPush;

  @override
  State<HomeListPage> createState() => _HomeListPageState();
}

class _HomeListPageState extends State<HomeListPage> {
  late Future<List<ChallengeModel>> challengesFutures;
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
        appBar: AppBarComponent(
          preTitle: widget.title,
          isFirstPage: true,
        ),
        backgroundColor: Colors.white,
        body: _buildList());
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
                    if (index == 1) {
                      return Column(
                        children: [
                          ListItemIconSmallComponent(
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
                    ChallengeModel challenge = challengeList[index -
                        1 -
                        1]; // -1 for new Challenge listitem - 1 for searchbar
                    return Column(
                      children: [
                        ListItemChallengeSmallComponent(
                          onTap: () => ppush(context,
                              challenge: challenge, index: index - 1 - 1),
                          challenge: challenge,
                          isProgressVisible: true,
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
      {required ChallengeModel challenge, required int index}) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => HomeChallengePage(
            preTitle: widget.title,
            challenge: challenge,
            initialChalleneIndex: index),
      ),
    ).then((_) => setState(() {}));
  }

  tapOnNewChallenge() {
    AcceptanceCriteriaModel acceptanceCriteria = AcceptanceCriteriaModel(
        id: null,
        activity: ActivityModel(title: '', amount: 0, unit: ''),
        frequence: 'once',
        tracking: 'camera',
        progress: 0,
        evidences: []);
    final ChallengeModel challenge = ChallengeModel(
        status: ChallengeStatusEnum.inProgress,
        title: '',
        description: '',
        thumbnailPath: '',
        startDate: null,
        endDate: null,
        acceptanceCriteria: [acceptanceCriteria],
        media: []);

    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => EditChallengePage(
          preTitle: widget.title,
          challenge: challenge,
          isNewChallenge: true,
        ),
      ),
    ).then((_) => setState(() {}));
  }
}
