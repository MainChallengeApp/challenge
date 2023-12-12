// ignore_for_file: must_be_immutable

import 'package:challenge/components/edit_challenge/add_acceptance_criteria.dart';
import 'package:challenge/components/my_snack_bar/my_snack_bar.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/edit_challenge/edit_challenge.dart';
import '../../components/navigation/no_animation_page_route.dart';
import '../../enums/tab_item.dart';
import '../../models/acceptance_criteria.dart';
import '../../models/activity.dart';
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
  int initialChalleneIndex;

  @override
  State<SearchChallenge> createState() => _SearchChallengeState();
}

class _SearchChallengeState extends State<SearchChallenge> {
  bool isDescriptionExpanded = false;
  late PageController pageController =
      PageController(initialPage: widget.initialChalleneIndex);
  late BuildContext context2;

  late String currentTitle = widget.challenge.title;

  @override
  Widget build(BuildContext context) {
    widget.challenge = widget.challenges[widget.initialChalleneIndex];
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
                '${widget.title}/$currentTitle',
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
                        extentRatio: 0.25,
                        motion: const ScrollMotion(),
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () => onTapEditChallenge(),
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
                          )),
                          const SizedBox(
                            width: 20,
                          ),
                          // Expanded(
                          //   child: GestureDetector(
                          //     onTap: tapOnFavorite,
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //           color: Colors.white,
                          //           border: Border.all(
                          //               width: 1,
                          //               color: const Color.fromRGBO(
                          //                   226, 232, 240, 1)),
                          //           borderRadius: const BorderRadius.all(
                          //               Radius.circular(24))),
                          //       child: const Center(
                          //           child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Icon(
                          //             Icons.star_border_outlined,
                          //             color: Colors.yellow,
                          //           ),
                          //           SizedBox(
                          //             height: 5,
                          //           ),
                          //           Text(
                          //             "Favorite",
                          //             style: TextStyle(color: Colors.yellow),
                          //           )
                          //         ],
                          //       )),
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   width: 20,
                          // ),
                        ],
                      ),
                      child: Builder(builder: (context) {
                        context2 = context;
                        return Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
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
                              GestureDetector(
                                onTap: () => MySnackBar.showSnackBar(context,
                                    'The Video Trailer feature will be added soon'),
                                child: Container(
                                  width: double.infinity,
                                  height: 180,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          241, 245, 249, 1),
                                      image: DecorationImage(
                                        image: AssetImage(e.thumbnailPath),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12))),
                                ),
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
                                    height: isDescriptionExpanded ? 403 : 80,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: const Color.fromRGBO(
                                                226, 232, 240, 1)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16))),
                                    child: Linkify(
                                      onOpen: (link) {
                                        _launchURL(link.url);
                                      },
                                      options: const LinkifyOptions(
                                          removeWww: true, humanize: true),
                                      text: e.description,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: isDescriptionExpanded ? 999 : 4,
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                          fontSize: 12, color: themeColor3),
                                    )),
                              ),
                              isDescriptionExpanded
                                  ? Container()
                                  : const SizedBox(
                                      height: 16,
                                    ),
                              startAndEndDate(e),
                              isDescriptionExpanded
                                  ? Container()
                                  : addAcceptanceCriteriaButton(),
                              isDescriptionExpanded
                                  ? Container()
                                  : acceptanceCriteria(e.acceptanceCriteria),
                              isDescriptionExpanded
                                  ? Container()
                                  : dots(e.acceptanceCriteria),
                              isDescriptionExpanded
                                  ? Container()
                                  : Expanded(child: Container()),
                              isDescriptionExpanded
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Expanded(
                                        //   child: GestureDetector(
                                        //     onTap: onTapEditChallenge,
                                        //     child: Container(
                                        //       height: 55,
                                        //       width: double.infinity,
                                        //       decoration: BoxDecoration(
                                        //           border: Border.all(
                                        //               width: 1,
                                        //               color:
                                        //                   const Color.fromRGBO(
                                        //                       226,
                                        //                       232,
                                        //                       240,
                                        //                       1)),
                                        //           borderRadius:
                                        //               const BorderRadius.all(
                                        //                   Radius.circular(16))),
                                        //       child: const Center(
                                        //           child: Text(
                                        //         'Edit',
                                        //         style: TextStyle(
                                        //             fontWeight: FontWeight.w500,
                                        //             color: Colors.black),
                                        //       )),
                                        //     ),
                                        //   ),
                                        // ),
                                        // const SizedBox(
                                        //   width: 16,
                                        // ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: onTapAccept,
                                            child: Container(
                                              height: 55,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: themeColor2,
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                          const Color.fromRGBO(
                                                              226,
                                                              232,
                                                              240,
                                                              1)),
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
                                          ),
                                        ),
                                      ],
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

  Widget startAndEndDate(Challenge e) {
    return isDescriptionExpanded
        ? Container()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onTapStartOrEndDate('start'),
                  child: standardContainer(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Start',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        (e.startDate != null ? _dateFormat(e.startDate!) : '-'),
                        style: const TextStyle(color: themeColor3),
                      )
                    ],
                  )),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => onTapStartOrEndDate('end'),
                  child: standardContainer(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'End',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        (e.endDate != null ? _dateFormat(e.endDate!) : '-'),
                        style: const TextStyle(color: themeColor3),
                      )
                    ],
                  )),
                ),
              ),
            ],
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
  acceptanceCriteria(List<AcceptanceCriteria> acceptanceCriterias) {
    return SizedBox(
        // margin: EdgeInsets.only(top: 10),
        height: 55,
        // padding: const EdgeInsets.all(10),
        child: PageView.builder(
          itemCount: acceptanceCriterias.length,
          controller: PageController(viewportFraction: 1),
          onPageChanged: (int index) =>
              setState(() => selectedAcceptanceCriteria = index),
          itemBuilder: (_, i) {
            return Transform.scale(
              scale: i == selectedAcceptanceCriteria ? 1 : 0.9,
              child: singleAcceptanceCriteria(acceptanceCriterias[i]),
            );
          },
        ));
  }

  singleAcceptanceCriteria(AcceptanceCriteria acceptanceCriteria) {
    return GestureDetector(
      onTap: () => onTapAcceptanceCriteria(acceptanceCriteria),
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white.withAlpha(170),
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                // width: 59,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(241, 245, 249, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Text('${acceptanceCriteria.progress}%',
                    style: const TextStyle(fontSize: 12, color: themeColor3),
                    overflow: TextOverflow.ellipsis),
              ),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 88, // Set your desired maximum width
                ),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(241, 245, 249, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Text(
                    '${acceptanceCriteria.activity.title} ${acceptanceCriteria.activity.amount} ${acceptanceCriteria.activity.unit}',
                    style: const TextStyle(fontSize: 12, color: themeColor3),
                    overflow: TextOverflow.ellipsis),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(241, 245, 249, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Text(acceptanceCriteria.frequence,
                    style: const TextStyle(fontSize: 12, color: themeColor3),
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(child: Container()),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(241, 245, 249, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Icon(getIconData(acceptanceCriteria),
                    color: themeColor3, size: 14),
              ),
            ],
          )),
    );
  }

  IconData getIconData(AcceptanceCriteria acceptanceCriteria) {
    if (acceptanceCriteria.tracking == 'camera') {
      return Icons.camera_alt_outlined;
    } else if (acceptanceCriteria.tracking == 'gps') {
      return Icons.gps_not_fixed;
    } else if (acceptanceCriteria.tracking == 'notes') {
      return Icons.notes;
    } else if (acceptanceCriteria.tracking == 'numbers') {
      return Icons.numbers;
    } else {
      return Icons.not_accessible;
    }
  }

  dots(List<AcceptanceCriteria> acceptanceCriteria) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            acceptanceCriteria.length,
            (index) => Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 10, bottom: 23),
                  child: Icon(
                    Icons.fiber_manual_record,
                    size: 6,
                    color: index == selectedAcceptanceCriteria
                        ? themeColor3
                        : themeColor3.withAlpha(100),
                  ),
                )));
  }

  void onTapAccept() async {
    Challenge challengeCopy = Challenge.copyChallenge(widget.challenge);

    ChallengeController challengeController = ChallengeController();
    allChallengesList.insert(0, challengeCopy);
    challengeList.insert(0, challengeCopy);
    await challengeController.writeFile(context, allChallengesList);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    widget.selectTab(TabItem.Home);

    // ignore: use_build_context_synchronously
    var homeNavigator = navigatorKeys[TabItem.Home]!.currentState!;

    homeNavigator.popUntil((route) => route.isFirst);
    // // ignore: use_build_context_synchronously
    // while (await homeNavigator.maybePop(context)) {
    //   // ignore: use_build_context_synchronously
    //   homeNavigator.pop(context);
    // }
    homeNavigator.push(
      NoAnimationPageRoute(
        builder: (context) => HomeChallenge(
          preTitle: 'Home',
          challenge: challengeCopy,
          initialChalleneIndex: 0,
        ), // Todo: change initalChallengeIndex when id is known from backend
      ),
    );
  }

  void onPageChanged(int value) {
    setState(() {
      widget.challenge = widget.challenges[value];
      currentTitle = widget.challenge.title;
      widget.initialChalleneIndex = value;
      pageController = PageController(initialPage: value);
      selectedAcceptanceCriteria = 0;
    });
  }

  void onTapEditChallenge() {
    // Slidable.of(context2)?.close(); // doesnt work flawless...
    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) => EditChallenge(
          title: widget.title,
          challenge: widget.challenge,
          selectTab: widget.selectTab,
          isSearchEdit: true,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  standardContainer({required Widget child, double heightFactor = 1}) {
    return Container(
      // width: double.infinity,
      height: 55 * heightFactor,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: child,
    );
  }

  void onTapStartOrEndDate(String startOrEnd) async {
    DateTime? initialDateTime = startOrEnd == 'start'
        ? widget.challenge.startDate
        : widget.challenge.endDate;
    setState(() {
      if (startOrEnd == 'start') {
        widget.challenge.startDate = null;
      } else {
        widget.challenge.endDate = null;
      }
    });

    bool isDateTimeChanged = false;

    await showCupertinoModalPopup(
      context: context,
      builder: (_) {
        final size = MediaQuery.of(context).size;
        return GestureDetector(
          onTap: () {
            if (startOrEnd == 'start') {
              setState(() {
                if (initialDateTime == null && !isDateTimeChanged) {
                  widget.challenge.startDate = DateTime.now();
                } else {
                  widget.challenge.startDate = initialDateTime;
                }
              });
            } else {
              setState(() {
                if (initialDateTime == null && !isDateTimeChanged) {
                  widget.challenge.endDate = DateTime.now();
                } else {
                  widget.challenge.endDate = initialDateTime;
                }
              });
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            height: size.height * 0.27,
            child: CupertinoDatePicker(
              initialDateTime: initialDateTime,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                isDateTimeChanged = true;
                setState(() {
                  if (startOrEnd == 'start') {
                    widget.challenge.startDate = value;
                  } else if (startOrEnd == 'end') {
                    widget.challenge.endDate = value;
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }

  void onTapAcceptanceCriteria(AcceptanceCriteria acceptanceCriteria) {
    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) => AddAcceptanceCriteria(
            preTitle: '${widget.title}/${widget.challenge.title}',
            challenge: widget.challenge,
            acceptanceCriteria: acceptanceCriteria,
            acceptanceCriteriaIndex: widget.challenge.acceptanceCriteria
                .indexOf(acceptanceCriteria)),
      ),
    ).then((_) => setState(() {}));
  }

  addAcceptanceCriteriaButton() {
    return GestureDetector(
      onTap: onTapAddAcceptanceCriteriaButton,
      child: standardContainer(
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(241, 245, 249, 1),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: const Center(
                  child: Icon(
                Icons.add,
                color: themeColor3,
              )),
            ),
            const SizedBox(
              width: 200,
              height: 40,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Add Acceptance Criteria')),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            const Icon(
              Icons.chevron_right_outlined,
              color: themeColor3,
            )
          ],
        ),
      ),
    );
  }

  void onTapAddAcceptanceCriteriaButton() {
    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) => AddAcceptanceCriteria(
          preTitle: '${widget.title}/${widget.challenge.title}/',
          challenge: widget.challenge,
          acceptanceCriteria: AcceptanceCriteria(
              id: widget.challenge.acceptanceCriteria.length,
              activity: Activity(title: '', amount: 0, unit: ''),
              frequence: '',
              tracking: '',
              progress: 0,
              evidences: []),
          acceptanceCriteriaIndex: null,
        ),
      ),
  _launchURL(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
