// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:challenge/components/edit_challenge/edit_challenge.dart';
import 'package:challenge/components/media/media_camera.dart';
import 'package:challenge/components/media/media_list.dart';
import 'package:challenge/components/navigation/custom_app_bar.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../enums/challenge_status.dart';
import '../../models/acceptance_criteria.dart';

class HomeChallenge extends StatefulWidget {
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

  late String currentTitle = widget.challenge.title;

  late PageController pageController =
      PageController(initialPage: widget.initialChalleneIndex);

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
    // setIsBottomBarVisibleToTrue(context);

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
                                  color:
                                      const Color.fromRGBO(226, 232, 240, 1)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24))),
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
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      height: 120 + 8 * 64 + 2,
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
                          GestureDetector(
                            onTap: onTapOpenMediaPage,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(241, 245, 249, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              height: 180,
                              width: double.infinity,
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  child: e.thumbnailPath != ''
                                      ? Image.asset(e.thumbnailPath,
                                          fit: BoxFit.cover)
                                      : e.media.isNotEmpty
                                          ? Image.asset(e.media.first.source,
                                              fit: BoxFit.cover)
                                          : const Center(
                                              child: Icon(Icons.question_mark,
                                                  color: themeColor3),
                                            )),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            onTap: () => setState(() {
                              isDescriptionExpanded = !isDescriptionExpanded;
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
                                child: Text(
                                  e.description,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: isDescriptionExpanded ? 9999 : 4,
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
                          isDescriptionExpanded
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: standardContainer(
                                            child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Start',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          (e.startDate != null
                                              ? _dateFormat(e.startDate!)
                                              : '-'),
                                          style: const TextStyle(
                                              color: themeColor3),
                                        )
                                      ],
                                    ))),
                                    const SizedBox(width: 16),
                                    Expanded(
                                        child: standardContainer(
                                            child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'End',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          (e.endDate != null
                                              ? _dateFormat(e.endDate!)
                                              : '-'),
                                          style: const TextStyle(
                                              color: themeColor3),
                                        )
                                      ],
                                    ))),
                                  ],
                                ),
                          // isDescriptionExpanded
                          //     ? Container()
                          //     : const SizedBox(
                          //         height: 16,
                          //       ),
                          isDescriptionExpanded
                              ? Container()
                              : acceptanceCriteria(e.acceptanceCriteria),
                          isDescriptionExpanded ? Container() : dots(),
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
                                        iconData: Icons.numbers, onTap: null),
                                    documentationButton(
                                        iconData: Icons.notes, onTap: null),
                                    documentationButton(
                                        iconData: Icons.gps_not_fixed,
                                        onTap: null),
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
                                      onTapEndTryAgainAcceptAgainButton(e),
                                  child: Container(
                                    height: 55,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: const Color.fromRGBO(
                                                226, 232, 240, 1)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16))),
                                    child: Center(
                                        child: Text(
                                      widget.challenge.status ==
                                              ChallengeStatus.inProgress
                                          ? 'End'
                                          : widget.challenge.status ==
                                                  ChallengeStatus.success
                                              ? 'Accept Again'
                                              : 'Try Again',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )),
                                  ),
                                )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
          }).toList()),
    );
  }

  void setIsBottomBarVisibleToTrue(BuildContext context) {
    Future.delayed(Duration.zero, () {
      //   setState(() {
      context.read<DesignProvider>().setIsBottomNavBarVisible(true);
      //   });
    });
  }

  void checkChallengeStatus() {
    if (widget.challenge.acceptanceCriteria.isNotEmpty) {
      if (widget.challenge.endDate != null) {
        // if (widget.challenge.status != ChallengStatus.failed) {
        if (DateTime.now().isAfter(widget.challenge.endDate!)) {
          if (!checkAcceptanceCriteria()) {
            widget.challenge.status = ChallengeStatus.failed;
          } else {
            widget.challenge.status = ChallengeStatus.success;
          }
        } else {
          if (checkAcceptanceCriteria()) {
            widget.challenge.status = ChallengeStatus.success;
          } else {
            widget.challenge.status = ChallengeStatus.inProgress;
          }
        }
        // } else {

        // }
      }
    }
  }

  bool checkAcceptanceCriteria() {
    for (var element in widget.challenge.acceptanceCriteria) {
      if (element.progress != 100) {
        return false; // Return false if any element doesn't meet the condition.
      }
    }
    return true; // Return true only if all elements meet the condition.
  }

  String _dateFormat(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  documentationButton({required IconData iconData, required onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        height: 55,
        margin: const EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Center(child: Icon(iconData)),
      ),
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
      onTap: () => onTapSingleAcceptanceCriteria(acceptanceCriteria),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: acceptanceCriteria.progress / 100,
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white.withAlpha(170),
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
              child: SingleChildScrollView(
                // scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(10),
                      width: 59,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(241, 245, 249, 1),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Text(
                        '${acceptanceCriteria.progress}%',
                        style:
                            const TextStyle(fontSize: 12, color: themeColor3),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(241, 245, 249, 1),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Text(
                        '${acceptanceCriteria.activity.title} ${acceptanceCriteria.activity.amount} ${acceptanceCriteria.activity.unit}',
                        style:
                            const TextStyle(fontSize: 12, color: themeColor3),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(241, 245, 249, 1),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Text(
                        acceptanceCriteria.frequence,
                        style:
                            const TextStyle(fontSize: 12, color: themeColor3),
                      ),
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

  dots() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            widget.challenge.acceptanceCriteria.length,
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
    Slidable.of(context2)?.close();
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) =>
            EditChallenge(title: widget.preTitle, challenge: widget.challenge),
      ),
    ).then((_) => setState(() {
          context.read<DesignProvider>().setIsBottomNavBarVisible(true);
        }));
  }

  void deleteChallenge() {
    allChallengesList
        .removeWhere((element) => element.id == widget.challenge.id);
    challengeList.removeWhere((element) => element.id == widget.challenge.id);
    challengeController.writeFile(context, allChallengesList);

    // Slidable.of(context2)?.close();
    Navigator.pop(context);
  }

  void onTapOpenMediaPage() {
    context.read<DesignProvider>().setIsBottomNavBarVisible(false);
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) => MediaList(
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
    });
  }

  onTapSingleAcceptanceCriteria(AcceptanceCriteria acceptanceCriteria) async {
    // Ensure that plugin services are initialized so that `availableCameras()`
// can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
    final firstCamera = cameras.isNotEmpty ? cameras[0] : null;

    context.read<DesignProvider>().setIsBottomNavBarVisible(false);
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) => MediaCamera(
          camera: firstCamera,
          preTitle: '${widget.preTitle}/${widget.challenge.title}',
          mediaList: widget.challenge.media,
          acceptanceCriteria: acceptanceCriteria,
          challenge: widget.challenge,
        ),
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

// Get a specific camera from the list of available cameras.
    final firstCamera = cameras.isNotEmpty ? cameras[0] : null;

    context.read<DesignProvider>().setIsBottomNavBarVisible(false);
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) => MediaCamera(
          camera: firstCamera,
          preTitle: '${widget.preTitle}/${widget.challenge.title}',
          mediaList: widget.challenge.media,
          acceptanceCriteria: null,
          challenge: widget.challenge,
        ),
      ),
    ).then((_) => setState(() {
          context.read<DesignProvider>().setIsBottomNavBarVisible(true);
        }));
  }

  void onTapEndTryAgainAcceptAgainButton(Challenge challenge) {
    if (widget.challenge.status == ChallengeStatus.inProgress) {
      // End button
      if (!checkAcceptanceCriteria()) {
        setState(() {
          widget.challenge.status = ChallengeStatus.failed;
          challengeList
              .firstWhere((element) => element.id == challenge.id)
              .status = ChallengeStatus.failed;
          allChallengesList
              .firstWhere((element) => element.id == challenge.id)
              .status = ChallengeStatus.failed;
          challengeController.writeFile(context, allChallengesList);
        });
      } else {
        setState(() {
          // widget.challenge.status = ChallengeStatus.success;
          // challengeList
          //     .firstWhere((element) => element.id == challenge.id)
          //     .status = ChallengeStatus.success;
          allChallengesList
              .firstWhere((element) => element.id == challenge.id)
              .status = ChallengeStatus.success;
          challengeController.writeFile(context, allChallengesList);
        });
      }
    } else if (widget.challenge.status == ChallengeStatus.failed) {
      // Try Again Button
      Navigator.pop(context);
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          pageBuilder: (context, animation1, animation2) {
            Challenge challenge = Challenge.copyChallenge(widget.challenge);
            return EditChallenge(title: widget.preTitle, challenge: challenge);
          },
        ),
      ).then((_) => setState(() {
            context.read<DesignProvider>().setIsBottomNavBarVisible(true);
          }));
    }
  }
}
