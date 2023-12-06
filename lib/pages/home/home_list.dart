import 'package:challenge/components/edit_challenge/edit_challenge.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/pages/home/home_challenge.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/components/list_items/list_item_challenge_small.dart';
import 'package:challenge/components/list_items/list_item_icon_small.dart';
import 'package:challenge/components/list_items/list_item_search_bar.dart';
import 'package:challenge/models/challenge.dart';

import '../../enums/challenge_status.dart';

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
  ChallengeController challengeController = ChallengeController();

  String searchBarText = "";

  @override
  void initState() {
    super.initState();
    challengesFutures =
        challengeController.readFile(context); //getChallenges(context);
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

            return ListView.separated(
                itemCount: challengeList.length +
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
                      onTap: () => tapOnNewChallenge(),
                      icon: Icons.add,
                      title: "New Challenge",
                    );
                  }
                  if (index == challengeList.length + 1 + 1) {
                    return Container(); // +1 for new Challenge listitem + 1 for searchbar
                  }
                  Challenge challenge = challengeList[index -
                      1 -
                      1]; // -1 for new Challenge listitem - 1 for searchbar
                  return ListItemChallengeSmall(
                    onTap: () => ppush(context,
                        challenge: challenge, index: index - 1 - 1),
                    challenge: challenge,
                  );
                });
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
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) => HomeChallenge(
            preTitle: widget.title,
            challenge: challenge,
            initialChalleneIndex: index),
      ),
    ).then((_) => setState(() {}));
  }

  tapOnNewChallenge() {
    final Challenge challenge = Challenge(
        status: ChallengeStatus.inProgress,
        title: '',
        description: '',
        thumbnailPath: '',
        startDate: DateTime.now(),
        endDate: null,
        acceptanceCriteria: [],
        media: []);

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) => EditChallenge(
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
