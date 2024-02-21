// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:challenge/components/challenge/description_component.dart';
import 'package:challenge/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/components/simple_components/custom_card_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:challenge/pages/subpages/media/media_camera_page.dart';
import 'package:challenge/pages/subpages/media/media_list_page.dart';
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:challenge/components/simple_components/snack_bar_component.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'package:challenge/pages/home/progress/progress_page.dart';
import 'package:challenge/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';

class HomeChallengePage extends StatefulWidget {
  // Function homeListSetState;

  HomeChallengePage(
      {super.key,
      required this.preTitle,
      required this.challenge,
      required this.initialChalleneIndex});
  final String preTitle;
  ChallengeModel challenge;
  final int initialChalleneIndex;

  @override
  State<HomeChallengePage> createState() => _HomeChallengePageState();
}

class _HomeChallengePageState extends State<HomeChallengePage> {
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
    widget.challenge.checkChallengeStatus();

    return Scaffold(
      appBar:
          AppBarComponent(preTitle: widget.preTitle, titleText: currentTitle),
      backgroundColor: Colors.white,
      body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          scrollDirection: Axis.vertical,
          children: challengeList.map((e) {
            return Slidable(
              closeOnScroll: true,
              // The end action pane is the one at the right or the bottom side.
              endActionPane: ActionPane(
                extentRatio: (e.status == ChallengeStatusEnum.inProgress ||
                        e.status == ChallengeStatusEnum.backlog)
                    ? 0.5
                    : 0.25,
                motion: const ScrollMotion(),
                children: [
                  editSlider(e),
                  (e.status == ChallengeStatusEnum.inProgress ||
                          e.status == ChallengeStatusEnum.backlog)
                      ? const SizedBox(
                          width: 20,
                        )
                      : Container(),
                  deleteSlider(),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              child: Builder(builder: (context) {
                context2 = context;
                return CardComponent(
                  scrollPhysics: challengeList.length == 1
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  children: [
                    thumbnail(e),
                    description(e),
                    startAndEndDate(e),
                    acceptanceCriteria(e.acceptanceCriterias),
                    isDescriptionExpanded
                        ? Container()
                        : Expanded(child: Container()),
                    documentationButtons(context),
                    isDescriptionExpanded
                        ? Container()
                        : const SizedBox(
                            height: 16,
                          ),
                    startEndTryAcceptAgainButton(e)
                  ],
                );
              }),
            );
          }).toList()),
    );
  }

  thumbnail(ChallengeModel e) {
    return Column(
      children: [
        ThumbnailMaxComponent(
            challengeModel: e, onTapOpenMediaPage: onTapOpenMediaPage),
        const SpaceComponent()
      ],
    );
  }

  Expanded deleteSlider() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: GestureDetector(
          onTap: deleteChallenge,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                borderRadius: const BorderRadius.all(Radius.circular(24))),
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
                  style: TextStyle(color: Colors.red.withAlpha(150)),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }

  Widget editSlider(ChallengeModel e) {
    return (e.status == ChallengeStatusEnum.inProgress ||
            e.status == ChallengeStatusEnum.backlog)
        ? Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: editChallenge,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1,
                          color: const Color.fromRGBO(226, 232, 240, 1)),
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
          )
        : Container();
  }

  StatelessWidget startEndTryAcceptAgainButton(ChallengeModel e) {
    return isDescriptionExpanded
        ? Container()
        : GestureDetector(
            onTap: () => onTapStartEndTryAcceptAgainButton(e),
            child: Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: e.status == ChallengeStatusEnum.backlog
                      ? themeColor2
                      : Colors.white,
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
              child: Center(
                  child: Text(
                e.status == ChallengeStatusEnum.inProgress
                    ? 'End'
                    : e.status == ChallengeStatusEnum.success
                        ? 'Accept Again'
                        : e.status == ChallengeStatusEnum.backlog
                            ? 'Start'
                            : 'Try Again', // ChallengeStatus.failed
                style: TextStyle(
                    color: e.status == ChallengeStatusEnum.backlog
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w500),
              )),
            ),
          );
  }

  Widget documentationButtons(BuildContext context) {
    return isDescriptionExpanded
        ? Container()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              documentationButton(
                  iconData: Icons.numbers_rounded,
                  onTap: () => SnackBarComponent.showSnackBar(
                      context, 'The Numbers feature will be added soon.'),
                  color: Colors.grey[200]),
              documentationButton(
                  iconData: Icons.notes_rounded,
                  onTap: () => SnackBarComponent.showSnackBar(
                      context, 'The Notes feature will be added soon.'),
                  color: Colors.grey[200]),
              documentationButton(
                  iconData: Icons.gps_not_fixed_rounded,
                  onTap: () => SnackBarComponent.showSnackBar(
                      context, 'The GPS feature will be added soon.'),
                  color: Colors.grey[200]),
              documentationButton(
                  iconData: Icons.camera_alt_outlined, onTap: onTapCamera),
            ],
          );
  }

  Widget startAndEndDate(ChallengeModel e) {
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

  description(ChallengeModel challenge) {
    DescriptionComponent descriptionComponent = DescriptionComponent(
      challenge: challenge,
      isDescriptionExpanded: isDescriptionExpanded,
    );
    return isDescriptionExpanded
        ? Expanded(
            child: GestureDetector(
                onTap: () => setState(() {
                      isDescriptionExpanded = !isDescriptionExpanded;
                    }),
                child: descriptionComponent))
        : Column(
            children: [
              GestureDetector(
                  onTap: () => setState(() {
                        isDescriptionExpanded = !isDescriptionExpanded;
                      }),
                  child: descriptionComponent),
              challenge.description.isNotEmpty
                  ? const SpaceComponent()
                  : Container()
            ],
          );
  }

  void checkChallengeStatus() {
    if (widget.challenge.acceptanceCriterias.isNotEmpty) {
      if (widget.challenge.endDate != null) {
        // if (widget.challenge.status != ChallengStatus.failed) {
        if (DateTime.now()
            .isAfter(widget.challenge.endDate!.add(const Duration(days: 1)))) {
          if (!checkAcceptanceCriteria()) {
            widget.challenge.status = ChallengeStatusEnum.failed;
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
      widget.challenge.status = ChallengeStatusEnum.backlog;
    }
  }

  bool checkAcceptanceCriteria() {
    for (var acceptanceCriteria in widget.challenge.acceptanceCriterias) {
      if (acceptanceCriteria.calcProgressRatio() < 1) {
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
  acceptanceCriteria(List<AcceptanceCriteriaModel> acceptanceCriterias) {
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

  singleAcceptanceCriteria(AcceptanceCriteriaModel acceptanceCriteria) {
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
                  color: widget.challenge.status == ChallengeStatusEnum.failed
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
                          color: themeColor4,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Text(
                          '${(acceptanceCriteria.calcProgressRatio() * 100).toInt()}%',
                          style:
                              const TextStyle(fontSize: 10, color: themeColor3),
                          overflow: TextOverflow.ellipsis),
                    ),
                    acceptanceCriteria.unit != '' ||
                            acceptanceCriteria.amount != 0
                        ? Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: themeColor4,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Text(
                                '${DesignUtil.doubleAsInt(acceptanceCriteria.currentProgress)}/${DesignUtil.doubleAsInt(acceptanceCriteria.amount)} ${acceptanceCriteria.unit}',
                                style: const TextStyle(
                                    fontSize: 10, color: themeColor3),
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

  IconData getIconData(AcceptanceCriteriaModel acceptanceCriteria) {
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

  dots(ChallengeModel challenge) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            challenge.acceptanceCriterias.length,
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
    if (widget.challenge.status == ChallengeStatusEnum.inProgress ||
        widget.challenge.status == ChallengeStatusEnum.backlog) {
      Navigator.push(
        context,
        NoAnimationPageRouteComponent(
          builder: (context) => EditChallengePage(
            preTitle: '${widget.preTitle}/${widget.challenge.title}',
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
      context.read<DesignProvider>().triggerSetStateHomeList();
      Navigator.pop(context);
    }
  }

  void onTapOpenMediaPage() {
    context.read<DesignProvider>().setIsBottomNavBarVisible(false);
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => MediaListPage(
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
      isDescriptionExpanded = false;
    });
  }

  onTapSingleAcceptanceCriteria(
      AcceptanceCriteriaModel acceptanceCriteria) async {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => ProgressPage(
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
      NoAnimationPageRouteComponent(
        builder: (context) => MediaCameraPage(
          cameras: cameras,
          preTitle: '${widget.preTitle}/${widget.challenge.title}',
          mediaList: widget.challenge.media,
          acceptanceCriteria: widget.challenge.acceptanceCriterias[0],
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
          widget.challenge.status = ChallengeStatusEnum.success;
        } else {
          widget.challenge.status = ChallengeStatusEnum.failed;
        }
        context.read<DesignProvider>().triggerSetStateHomeList();
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
          child: const Center(
              child: Text(
            'Yes',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
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
          child: const Center(
              child: Text(
            'No',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          )),
        ),
      ),
    );
  }

  void onTapStartEndTryAcceptAgainButton(ChallengeModel challenge) {
    if (widget.challenge.status == ChallengeStatusEnum.inProgress) {
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
                          'Do you really want to end this Challenge?\n\nThis action can not be undone.\n',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(child: dialogYesButton()),
                          const SizedBox(
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
    } else if (widget.challenge.status == ChallengeStatusEnum.failed ||
        widget.challenge.status == ChallengeStatusEnum.success) {
      // Try Again Button and Accept Again
      Navigator.pop(context);
      Navigator.push(
        context,
        NoAnimationPageRouteComponent(
          builder: (context) {
            ChallengeModel challenge = ChallengeModel.copyChallenge(
                widget.challenge,
                isTryAgain: true);
            return EditChallengePage(
              preTitle: '${widget.preTitle}/${widget.challenge.title}',
              challenge: challenge,
              isTryAgain: true,
            );
          },
        ),
      );
    } else if (widget.challenge.status == ChallengeStatusEnum.backlog) {
      setState(() {
        widget.challenge.startDate = DateTime.now();
        widget.challenge.status = ChallengeStatusEnum.inProgress;
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
}
