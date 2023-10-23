// ignore_for_file: must_be_immutable

import 'package:challenge/jsonFileController/challenge_controller.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../components/edit_challenge/edit_challenge.dart';
import '../../models/tab_item.dart';
import '../home/home_challenge.dart';

class SearchChallenge extends StatefulWidget {
  SearchChallenge(
      {super.key,
      required this.title,
      required this.challenge,
      required this.selectTab,
      required this.challenges,
      required this.initialChalleneIndex});
  final String title;
  Challenge challenge;
  final Function selectTab;
  final List<Challenge> challenges;
  final int initialChalleneIndex;

  @override
  State<SearchChallenge> createState() => _SearchChallengeState();
}

class _SearchChallengeState extends State<SearchChallenge> {
  bool isDescriptionExpanded = false;
  late PageController pageController =
      PageController(initialPage: widget.initialChalleneIndex);
  late BuildContext context2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleSpacing: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                '${widget.title}/${widget.challenge.title}',
                style: const TextStyle(
                    color: Colors.black, fontSize: appBarFontSize),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            scrollDirection: Axis.vertical,
            children: widget.challenges.map(
              (e) {
                return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Slidable(
                      key: const ValueKey(0),
                      closeOnScroll: true,
                      // The end action pane is the one at the right or the bottom side.
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: editChallenge,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1,
                                        color: const Color.fromRGBO(
                                            226, 232, 240, 1)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24))),
                                child: const Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Edit")
                                  ],
                                )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: tapOnFavorite,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1,
                                        color: const Color.fromRGBO(
                                            226, 232, 240, 1)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24))),
                                child: const Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star_border_outlined,
                                      color: Colors.yellow,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Favorite",
                                      style: TextStyle(
                                          color: Colors.yellow),
                                    )
                                  ],
                                )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      child: Builder(builder: (context) {
                        context2 = context;
                        return Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20),
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          height: 120 + 8 * 64 + 2,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color:
                                      const Color.fromRGBO(226, 232, 240, 1)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24))),
                          // margin: EdgeInsets.only(bottom:16),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 180,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(241, 245, 249, 1),
                                    image: DecorationImage(
                                      image: AssetImage(e.thumbnailPath),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              GestureDetector(
                                onTap: () => setState(() {
                                  isDescriptionExpanded =
                                      !isDescriptionExpanded;
                                }),
                                child: Container(
                                    width: double.infinity,
                                    height: isDescriptionExpanded ? 399 : 80,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: const Color.fromRGBO(
                                                226, 232, 240, 1)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16))),
                                    child: Text(
                                      e.description,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: isDescriptionExpanded ? 999 : 4,
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                          fontSize: 12, color: themeColor3),
                                    )),
                              ),
                              // isDescriptionExpanded
                              //     ? Container()
                              //     : const SizedBox(
                              //         height: 11,
                              //       ),
                              // isDescriptionExpanded
                              //     ? Container()
                              //     : const Align(
                              //         alignment: Alignment.centerLeft,
                              //         child: Text(
                              //           'Acceptance Criteria',
                              //           style: TextStyle(fontWeight: FontWeight.w500),
                              //         ),
                              //       ),
                              isDescriptionExpanded
                                  ? Container()
                                  : const SizedBox(
                                      height: 16,
                                    ),
                              isDescriptionExpanded
                                  ? Container()
                                  : acceptanceCriteria(),
                              isDescriptionExpanded
                                  ? Container()
                                  : Expanded(child: Container()),
                              isDescriptionExpanded
                                  ? Container()
                                  : GestureDetector(
                                      onTap: onTapAccept,
                                      child: Container(
                                        height: 55,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: themeColor2,
                                            border: Border.all(
                                                width: 1,
                                                color: const Color.fromRGBO(
                                                    226, 232, 240, 1)),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(16))),
                                        child: const Center(
                                            child: Text(
                                          'Accept',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        )),
                                      ),
                                    )
                            ],
                          ),
                        );
                      }),
                    ));
              },
            ).toList()),
      ),
    );
  }

  String _dateFormat(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  documentationButton(IconData iconData) {
    return Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Center(child: Icon(iconData)),
    );
  }

  int selectedAcceptanceCriteria = 0;
  acceptanceCriteria() {
    return Container(
      height: 200,
      child: ListView.separated(
        itemCount: widget.challenge.acceptanceCriteria.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: 16,
        ),
        itemBuilder: (_, i) {
          return singleAcceptanceCriteria(i);
        },
      ),
    );
  }

  singleAcceptanceCriteria(int index) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(241, 245, 249, 1),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Text(
                '${widget.challenge.acceptanceCriteria[index].activity.title} ${widget.challenge.acceptanceCriteria[index].activity.amount} ${widget.challenge.acceptanceCriteria[index].activity.unit}',
                style: const TextStyle(fontSize: 12, color: themeColor3),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(241, 245, 249, 1),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Text(
                widget.challenge.acceptanceCriteria[index].frequence,
                style: const TextStyle(fontSize: 12, color: themeColor3),
              ),
            ),
            Expanded(child: Container()),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(241, 245, 249, 1),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Icon(getIconData(index), color: themeColor3, size: 14),
            ),
          ],
        ));
  }

  IconData getIconData(int index) {
    if (widget.challenge.acceptanceCriteria[index].tracking == 'camera') {
      return Icons.camera_alt_outlined;
    } else if (widget.challenge.acceptanceCriteria[index].tracking == 'gps') {
      return Icons.gps_not_fixed;
    } else if (widget.challenge.acceptanceCriteria[index].tracking == 'notes') {
      return Icons.notes;
    } else if (widget.challenge.acceptanceCriteria[index].tracking ==
        'numbers') {
      return Icons.numbers;
    } else {
      return Icons.not_accessible;
    }
  }

  void onTapAccept() async {

    ChallengeController challengeController = ChallengeController();
    allChallengesList.insert(0, widget.challenge);
    await challengeController.writeFile(context, allChallengesList);

    widget.selectTab(TabItem.Home);
    Navigator.pop(context);

    // ignore: use_build_context_synchronously
    var homeNavigator = navigatorKeys[TabItem.Home]!.currentState!;
    // ignore: use_build_context_synchronously
    while (await homeNavigator.maybePop(context)) {
      // ignore: use_build_context_synchronously
      homeNavigator.pop(context);
    }
    homeNavigator.push(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) => HomeChallenge(
          preTitle: 'Home',
          challenge: widget.challenge,
          initialChalleneIndex: 0,
        ), // Todo: change initalChallengeIndex when id is known from backend
      ),
    );
  }

  void onPageChanged(int value) {
    setState(() {
      widget.challenge = widget.challenges[value];
    });
  }

  void editChallenge() {
    Slidable.of(context2)?.close();
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) => EditChallenge(
            title: widget.title,
            challenge: widget.challenge,
            selectTab: widget.selectTab),
      ),
    ).then((_) => setState(() {}));
  }

  void tapOnFavorite() {}
}
