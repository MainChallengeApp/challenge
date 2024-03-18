import 'package:challenge/pages/components/navigation/app_bar_component.dart';
import 'package:challenge/pages/components/simple_components/space_column_component.dart';
import 'package:challenge/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/pages/home/home_challenge_page.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/pages/components/list_items/list_item_challenge_small_component.dart';
import 'package:challenge/pages/components/list_items/list_item_icon_small_component.dart';
import 'package:challenge/pages/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/models/challenge_model.dart';

import 'package:challenge/pages/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:provider/provider.dart';

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
    context.watch<DesignProvider>().triggeredSetStateHomeList();
    return Scaffold(
        appBar: AppBarComponent(
          preTitle: widget.title,
          isFirstPageInRoute: true,
        ),
        backgroundColor: Colors.white,
        body: _buildList());
  }

  Widget _buildList() {
    return FutureBuilder(
        future: challengesFutures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                  itemBuilder: (BuildContext content, int index) {
                    if (index == 0) {
                      return searchBar();
                    }
                    if (index == 1) {
                      return newChallenge();
                    }
                    ChallengeModel challenge = challengeList[index -
                        1 -
                        1]; // -1 for new Challenge listitem - 1 for searchbar
                    return SpaceColumnComponent(
                      child: ListItemChallengeSmallComponent(
                        onTap: () => ppush(context,
                            challenge: challenge, index: index - 1 - 1),
                        challenge: challenge,
                      ),
                    );
                  }),
            );
          } else {
            return const Center(child: Text('Error with loading data...'));
          }
        });
  }

  SpaceColumnComponent newChallenge() {
    return SpaceColumnComponent(
      child: ListItemIconSmallComponent(
        onTap: () => tapOnNewChallenge(),
        icon: Icons.add_rounded,
        title: "New Challenge",
      ),
    );
  }

  SpaceColumnComponent searchBar() {
    return SpaceColumnComponent(
      child: ListItemSearchbarComponent(
        changeList: changeList,
        textEditingController: TextEditingController(text: searchBarText),
        hintText: 'Search in your Challenges...',
      ),
    );
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
            initChallenge: challenge,
            initialChalleneIndex: index),
      ),
    ).then((_) => setState(() {}));
  }

  tapOnNewChallenge() {
    final ChallengeModel challenge = ChallengeModel(
        status: ChallengeStatusEnum.inProgress,
        title: '',
        description: '',
        thumbnailPath: '',
        startDate: null,
        endDate: null,
        acceptanceCriteria: AcceptanceCriteriaModel.emptyAcceptanceCriteria(),
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
