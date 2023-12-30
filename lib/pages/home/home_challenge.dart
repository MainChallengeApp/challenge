// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:challenge/components/edit_challenge/edit_challenge.dart';
import 'package:challenge/components/media/media_camera.dart';
import 'package:challenge/components/media/media_list.dart';
import 'package:challenge/components/navigation/custom_app_bar.dart';
import 'package:challenge/components/my_snack_bar/my_snack_bar.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/media/acceptance_criteria_evidence_list.dart';
import '../../components/navigation/no_animation_page_route.dart';
import '../../enums/challenge_status.dart';
import '../../models/acceptance_criteria.dart';

class HomeChallenge extends StatefulWidget {
  // Function homeListSetState;

  HomeChallenge(
      {super.key,
      required this.preTitle,
      required this.challenge,
      required this.initialChalleneIndex});
  final String preTitle;
  Challenge challenge;
  final int initialChalleneIndex;

  @override
  State<HomeChallenge> createState() => _HomeChallengeState();
}

class _HomeChallengeState extends State<HomeChallenge> {
  bool isDescriptionExpanded = false;

  late BuildContext context2;
  late BuildContext context3;

  late String currentTitle = widget.challenge.title;

  late PageController pageController =
      PageController(initialPage: widget.initialChalleneIndex);

  late int currentChallengeIndex = widget.initialChalleneIndex;

  ChallengeController challengeController = ChallengeController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        context.read<DesignProvider>().setIsBottomNavBarVisible(true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.challenge = challengeList[
        currentChallengeIndex]; // dirty workaround - the problem is related to the feature to unvisible the BottomNavBar
    currentTitle = widget.challenge.title;
    checkChallengeStatus();

    return Scaffold(
      appBar:
          CustomeAppBar.build(preTitle: widget.preTitle, title: currentTitle),
      backgroundColor: Colors.white,
      body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          scrollDirection: Axis.vertical,
          children: challengeList.map((e) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Slidable(
                key: const ValueKey(0),
                closeOnScroll: true,
                // The end action pane is the one at the right or the bottom side.
                endActionPane: ActionPane(
                  extentRatio: (e.status == ChallengeStatus.inProgress ||
                          e.status == ChallengeStatus.backlog)
                      ? 0.5
                      : 0.25,
                  motion: const ScrollMotion(),
                  children: [
                    (e.status == ChallengeStatus.inProgress ||
                            e.status == ChallengeStatus.backlog)
                        ? Expanded(
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
                          )
                        : Container(),
                    (e.status == ChallengeStatus.inProgress ||
                            e.status == ChallengeStatus.backlog)
                        ? const SizedBox(
                            width: 20,
                          )
                        : Container(),
                    Expanded(
                      child: GestureDetector(
                        onTap: deleteChallenge,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color:
                                      const Color.fromRGBO(226, 232, 240, 1)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24))),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.red.withAlpha(150),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Delete",
                                style:
                                    TextStyle(color: Colors.red.withAlpha(150)),
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
                  return Center(
                    child: SingleChildScrollView(
                      physics: challengeList.length == 1
                          ? const AlwaysScrollableScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        height: 120 + 8 * 64,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 1,
                                color: const Color.fromRGBO(226, 232, 240, 1)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24))),
                        // margin: EdgeInsets.only(bottom:16),
                        child: Column(
                          children: [
                            thumbnail(e),
                            const SizedBox(
                              height: 16,
                            ),
                            description(e),
                            isDescriptionExpanded
                                ? Container()
                                : const SizedBox(
                                    height: 16,
                                  ),
                            startAndEndDate(e),
                            // isDescriptionExpanded
                            //     ? Container()
                            //     : const SizedBox(
                            //         height: 16,
                            //       ),
                            acceptanceCriteria(e.acceptanceCriteria),
                            // isDescriptionExpanded
                            //     ? Container()
                            //     : const SizedBox(
                            //         height: 12,
                            //       ),
                            isDescriptionExpanded
                                ? Container()
                                : Expanded(child: Container()),
                            isDescriptionExpanded
                                ? Container()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      documentationButton(
                                          iconData: Icons.numbers_rounded,
                                          onTap: () => MySnackBar.showSnackBar(
                                              context,
                                              'The Numbers feature will be added soon.'),
                                          color: Colors.grey[200]),
                                      documentationButton(
                                          iconData: Icons.notes_rounded,
                                          onTap: () => MySnackBar.showSnackBar(
                                              context,
                                              'The Notes feature will be added soon.'),
                                          color: Colors.grey[200]),
                                      documentationButton(
                                          iconData: Icons.gps_not_fixed_rounded,
                                          onTap: () => MySnackBar.showSnackBar(
                                              context,
                                              'The GPS feature will be added soon.'),
                                          color: Colors.grey[200]),
                                      documentationButton(
                                          iconData: Icons.camera_alt_outlined,
                                          onTap: onTapCamera),
                                    ],
                                  ),
                            isDescriptionExpanded
                                ? Container()
                                : const SizedBox(
                                    height: 16,
                                  ),
                            isDescriptionExpanded
                                ? Container()
                                : GestureDetector(
                                    onTap: () =>
                                        onTapEndTryAgainAcceptAgainStartButton(
                                            e),
                                    child: Container(
                                      height: 55,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: e.status ==
                                                  ChallengeStatus.backlog
                                              ? themeColor2
                                              : Colors.white,
                                          border: Border.all(
                                              width: 1,
                                              color: const Color.fromRGBO(
                                                  226, 232, 240, 1)),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16))),
                                      child: Center(
                                          child: Text(
                                        e.status == ChallengeStatus.inProgress
                                            ? 'End'
                                            : e.status ==
                                                    ChallengeStatus.success
                                                ? 'Accept Again'
                                                : e.status ==
                                                        ChallengeStatus.backlog
                                                    ? 'Start'
                                                    : 'Try Again', // ChallengeStatus.failed
                                        style: TextStyle(
                                            color: e.status ==
                                                    ChallengeStatus.backlog
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w500),
                                      )),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }).toList()),
    );
  }

  Widget startAndEndDate(Challenge e) {
    return isDescriptionExpanded
        ? Container()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
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
              ))),
              const SizedBox(width: 16),
              Expanded(
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
              ))),
            ],
          );
  }

  GestureDetector description(Challenge e) {
    return GestureDetector(
      onTap: () => setState(() {
        isDescriptionExpanded = !isDescriptionExpanded;
      }),
      child: Container(
          width: double.infinity,
          height: isDescriptionExpanded ? 402 : 80,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: Linkify(
            onOpen: (link) {
              _launchURL(link.url);
            },
            options: const LinkifyOptions(removeWww: true, humanize: true),
            text: e.description,
            overflow: TextOverflow.ellipsis,
            maxLines: isDescriptionExpanded ? 999 : 4,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 12, color: themeColor3),
          )),
    );
  }

  GestureDetector thumbnail(Challenge e) {
    return GestureDetector(
      onTap: onTapOpenMediaPage,
      child: Container(
        decoration: const BoxDecoration(
            color: Color.fromRGBO(241, 245, 249, 1),
            borderRadius: BorderRadius.all(Radius.circular(12))),
        height: 180,
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: e.thumbnailPath != ''
                      ? Image.asset(e.thumbnailPath, fit: BoxFit.contain)
                      : e.media.isNotEmpty
                          ? Image.asset(e.media.first.source,
                              fit: BoxFit.contain)
                          : Icon(Icons.question_mark, color: themeColor3)),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                clipBehavior: Clip.none,
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: themeColor2.withAlpha(120)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      e.media.length.toString(),
                      textAlign: TextAlign.end,
                    ),
                    Icon(
                      Icons.image_outlined,
                      size: 15,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkChallengeStatus() {
    if (widget.challenge.acceptanceCriteria.isNotEmpty) {
      if (widget.challenge.endDate != null) {
        // if (widget.challenge.status != ChallengStatus.failed) {
        if (DateTime.now()
            .isAfter(widget.challenge.endDate!.add(const Duration(days: 1)))) {
          if (!checkAcceptanceCriteria()) {
            widget.challenge.status = ChallengeStatus.failed;
          }
        }
        // else {
        //   if (checkAcceptanceCriteria()) {
        //     widget.challenge.status = ChallengeStatus.success;
        //   } else if (widget.challenge.status != ChallengeStatus.failed) {
        //     widget.challenge.status = ChallengeStatus.inProgress;
        //   }
        // }
        // } else {

        // }
      }
    }

    if (widget.challenge.startDate == null ||
        DateTime.now().microsecondsSinceEpoch <
            widget.challenge.startDate!.microsecondsSinceEpoch) {
      widget.challenge.status = ChallengeStatus.backlog;
    }
  }

  bool checkAcceptanceCriteria() {
    for (var element in widget.challenge.acceptanceCriteria) {
      if (element.calcProgressRatio() < 1) {
        return false; // Return false if any element doesn't meet the condition.
      }
    }
    return true; // Return true only if all elements meet the condition.
  }

  String _dateFormat(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  documentationButton(
      {required IconData iconData, required onTap, Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        height: 55,
        margin: const EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: color),
        child: Center(child: Icon(iconData)),
      ),
    );
  }

  int selectedAcceptanceCriteria = 0;
  acceptanceCriteria(List<AcceptanceCriteria> acceptanceCriterias) {
    return isDescriptionExpanded
        ? Container()
        : Column(
            children: [
              SizedBox(
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
                  )),
              const SizedBox(
                height: 16,
              )
            ],
          );
  }

  singleAcceptanceCriteria(AcceptanceCriteria acceptanceCriteria) {
    return GestureDetector(
      onTap: () => onTapSingleAcceptanceCriteria(acceptanceCriteria),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: acceptanceCriteria.calcProgressRatio() > 1
                ? 1
                : acceptanceCriteria.calcProgressRatio(),
            heightFactor: 1,
            child: Container(
              // width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: widget.challenge.status == ChallengeStatus.failed
                      ? Colors.red
                      : Colors.green,
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white,
                    width: 10,
                    strokeAlign: BorderSide.strokeAlignOutside),
                borderRadius: const BorderRadius.all(Radius.circular(16))),
          ),
          Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white.withAlpha(170),
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(10),
                      // width: 59,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(241, 245, 249, 1),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Text(
                          '${(acceptanceCriteria.calcProgressRatio() * 100).toInt()}%',
                          style:
                              const TextStyle(fontSize: 12, color: themeColor3),
                          overflow: TextOverflow.ellipsis),
                    ),
                    acceptanceCriteria.activity.unit != '' ||
                            acceptanceCriteria.activity.amount != 0
                        ? Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(241, 245, 249, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Text(
                                '${doubleAsInt(acceptanceCriteria.progress)}/${doubleAsInt(acceptanceCriteria.activity.amount)} ${acceptanceCriteria.activity.unit}',
                                style: const TextStyle(
                                    fontSize: 12, color: themeColor3),
                                overflow: TextOverflow.ellipsis),
                          )
                        : Container()
                  ],
                ),
              ))
        ],
      ),
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

  dots(Challenge challenge) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            challenge.acceptanceCriteria.length,
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

  void editChallenge() {
    setState(() {
      Slidable.of(context2)?.close(duration: Duration.zero);
    });
    if (widget.challenge.status == ChallengeStatus.inProgress ||
        widget.challenge.status == ChallengeStatus.backlog) {
      Navigator.push(
        context,
        NoAnimationPageRoute(
          builder: (context) => EditChallenge(
            title: widget.preTitle,
            challenge: widget.challenge,
          ),
        ),
      ).then((_) => setState(() {
            context.read<DesignProvider>().setIsBottomNavBarVisible(true);
          }));
    }
  }

  void deleteChallenge() {
    allChallengesList
        .removeWhere((element) => element.id == widget.challenge.id);
    challengeList.removeWhere((element) => element.id == widget.challenge.id);
    challengeController.writeFile(context, allChallengesList);

    setState(() {
      if (currentChallengeIndex >= challengeList.length) {
        currentChallengeIndex = challengeList.length - 1;
      }
      Slidable.of(context2)?.close(duration: Duration.zero);
    });
    if (challengeList.isEmpty) {
      Navigator.pop(context);
    }
  }

  void onTapOpenMediaPage() {
    context.read<DesignProvider>().setIsBottomNavBarVisible(false);
    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) => MediaList(
          preTitle: '${widget.preTitle}/${widget.challenge.title}',
          challenge: widget.challenge,
        ),
      ),
    ).then((_) => setState(() {
          context.read<DesignProvider>().setIsBottomNavBarVisible(true);
        }));
  }

  void onPageChanged(int value) {
    setState(() {
      currentTitle = challengeList[value].title;
      widget.challenge = challengeList[value];
      currentChallengeIndex = value;
      pageController = PageController(initialPage: value);
      selectedAcceptanceCriteria = 0;
    });
  }

  onTapSingleAcceptanceCriteria(AcceptanceCriteria acceptanceCriteria) async {
    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) => AcceptanceCriteriaEvidenceList(
            preTitle: '${widget.preTitle}/${widget.challenge.title}',
            challenge: widget.challenge,
            acceptanceCriteria: acceptanceCriteria),
      ),
    ).then((_) => setState(() {
          context.read<DesignProvider>().setIsBottomNavBarVisible(true);
        }));
  }

  onTapCamera() async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    context.read<DesignProvider>().setIsBottomNavBarVisible(false);
    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) => MediaCamera(
          cameras: cameras,
          preTitle: '${widget.preTitle}/${widget.challenge.title}',
          mediaList: widget.challenge.media,
          acceptanceCriteria: widget.challenge.acceptanceCriteria[0],
          challenge: widget.challenge,
        ),
      ),
    ).then((_) => setState(() {
          context.read<DesignProvider>().setIsBottomNavBarVisible(true);
        }));
  }

  dialogYesButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context3);
        if (checkAcceptanceCriteria()) {
          widget.challenge.status = ChallengeStatus.success;
        } else {
          widget.challenge.status = ChallengeStatus.failed;
        }
        setState(() {
          widget.challenge.endDate = DateTime.now();
          challengeList
              .map((e) => e.id == widget.challenge.id ? widget.challenge : e);
          allChallengesList
              .map((e) => e.id == widget.challenge.id ? widget.challenge : e);
          challengeController.writeFile(context, allChallengesList);
        });
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 55,
          margin: const EdgeInsets.only(bottom: 16, left: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: Center(
              child: Text(
            'Yes',
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black),
          )),
        ),
      ),
    );
  }

  dialogNoButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context3);
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 55,
          margin: const EdgeInsets.only(bottom: 16, right: 16),
          decoration: BoxDecoration(
              color: themeColor2,
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: Center(
              child: Text(
            'No',
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white),
          )),
        ),
      ),
    );
  }

  void onTapEndTryAgainAcceptAgainStartButton(Challenge challenge) {
    if (widget.challenge.status == ChallengeStatus.inProgress) {
      // End button
      showDialog(
        context: context,
        builder: (context) {
          context3 = context;
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Dialog(
              insetPadding: const EdgeInsets.only(
                  top: 150, bottom: 200, left: 50, right: 50),
              alignment: Alignment.center,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Do you really want to end this Challenge?\n\nThis action can not be undo.\n',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(child: dialogYesButton()),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(child: dialogNoButton())
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else if (widget.challenge.status == ChallengeStatus.failed ||
        widget.challenge.status == ChallengeStatus.success) {
      // Try Again Button and Accept Again
      Navigator.pop(context);
      Navigator.push(
        context,
        NoAnimationPageRoute(
          builder: (context) {
            Challenge challenge =
                Challenge.copyChallenge(widget.challenge, isTryAgain: true);
            return EditChallenge(
              title: widget.preTitle,
              challenge: challenge,
              isTryAgain: true,
            );
          },
        ),
      );
    } else if (widget.challenge.status == ChallengeStatus.backlog) {
      setState(() {
        widget.challenge.startDate = DateTime.now();
        widget.challenge.status = ChallengeStatus.inProgress;
      });
      allChallengesList
          .firstWhere((element) => element.id == widget.challenge.id)
          .startDate = widget.challenge.startDate;
      allChallengesList
          .firstWhere((element) => element.id == widget.challenge.id)
          .status = widget.challenge.status;
      challengeController.writeFile(context, allChallengesList);
    }
  }

  _launchURL(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  String doubleAsInt(double number) {
    if (number.toString().endsWith('.0'))
      return number.toString().split('.')[0];
    return number.toString();
  }
}
