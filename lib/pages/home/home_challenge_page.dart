// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:challenge/pages/components/challenge/description_component.dart';
import 'package:challenge/pages/components/challenge/start_and_end_date_component.dart';
import 'package:challenge/pages/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/pages/components/challenge/title_component.dart';
import 'package:challenge/pages/components/simple_components/custom_card_component.dart';
import 'package:challenge/pages/components/simple_components/space_column_component.dart';
import 'package:challenge/pages/components/simple_components/space_component.dart';
import 'package:challenge/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:challenge/pages/subpages/media/media_camera_page.dart';
import 'package:challenge/pages/subpages/media/media_list_page.dart';
import 'package:challenge/pages/components/navigation/app_bar_component.dart';
import 'package:challenge/pages/components/simple_components/snack_bar_component.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:challenge/pages/home/progress/progress_page.dart';
import 'package:challenge/pages/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';

class HomeChallengePage extends StatefulWidget {
  const HomeChallengePage(
      {super.key,
      required this.preTitle,
      required this.initChallenge,
      required this.initialChalleneIndex});
  final String preTitle;
  final ChallengeModel initChallenge;
  final int initialChalleneIndex;

  @override
  State<HomeChallengePage> createState() => _HomeChallengePageState();
}

class _HomeChallengePageState extends State<HomeChallengePage> {
  bool isDescriptionExpanded = false;

  late BuildContext context2;
  late BuildContext context3;

  late ChallengeModel currentChallenge = widget.initChallenge;

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
    currentChallenge.checkChallengeStatus();

    return Scaffold(
      appBar: AppBarComponent(preTitle: widget.preTitle),
      backgroundColor: Colors.white,
      body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          scrollDirection: Axis.vertical,
          children: challengeList.map((challenge) {
            return Slidable(
              closeOnScroll: true,
              // The end action pane is the one at the right or the bottom side.
              endActionPane: endActionPane(challenge),
              child: Builder(builder: (context) {
                context2 = context;
                return CardComponent(
                  scrollPhysics: challengeList.length == 1
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  children: [
                    thumbnail(challenge),
                    title(challenge.title),
                    description(challenge),
                    startAndEndDate(challenge),
                    acceptanceCriteria(
                        challenge.acceptanceCriteria, challenge.startDate),
                    expandedSpace(),
                    documentationButtons(context),
                    startEndTryAcceptAgainButton(challenge)
                  ],
                );
              }),
            );
          }).toList()),
    );
  }

  endActionPane(ChallengeModel challenge) {
    return ActionPane(
      extentRatio: (challenge.status == ChallengeStatusEnum.inProgress ||
              challenge.status == ChallengeStatusEnum.backlog)
          ? 0.5
          : 0.25,
      motion: const ScrollMotion(),
      children: [
        editSlider(challenge),
        seperator(challenge),
        deleteSlider(),
        const SpaceComponent(),
      ],
    );
  }

  Widget seperator(ChallengeModel challenge) {
    return (challenge.status == ChallengeStatusEnum.inProgress ||
            challenge.status == ChallengeStatusEnum.backlog)
        ? const SpaceComponent(
            width: 20,
          )
        : Container();
  }

  Widget expandedSpace() {
    return isDescriptionExpanded ? Container() : Expanded(child: Container());
  }

  title(String challengeTitle) {
    return Column(
      children: [
        TitleComponent(challengeTitle: challengeTitle),
        const SpaceComponent(
          height: 11,
        )
      ],
    );
  }

  thumbnail(ChallengeModel e) {
    return Column(
      children: [
        ThumbnailMaxComponent(
            challengeModel: e, onTapOpenMediaPage: onTapOpenMediaPage),
        const SpaceComponent(
          height: 11,
        )
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
                onTap: onTapEditChallenge,
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
        : SpaceColumnComponent(
            child: Row(
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
            ),
          );
  }

  Widget startAndEndDate(ChallengeModel challenge) {
    return isDescriptionExpanded
        ? Container()
        : Column(
            children: [
              StartAndEndDateComponent(
                editChallenge: challenge,
                isLocked: true,
              ),
              const SpaceComponent()
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

  acceptanceCriteria(AcceptanceCriteriaModel acceptanceCriteria,
      DateTime? challengeStartDate) {
    return isDescriptionExpanded
        ? Container()
        : GestureDetector(
            onTap: () => onTapSingleAcceptanceCriteria(acceptanceCriteria),
            child: Center(
              child: SizedBox(
                height: 55,
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
                            color: currentChallenge.status ==
                                    ChallengeStatusEnum.failed
                                ? Colors.red
                                : Colors.green,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16))),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 10,
                              strokeAlign: BorderSide.strokeAlignOutside),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16))),
                    ),
                    Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white.withAlpha(170),
                            border: Border.all(
                                width: 1,
                                color: const Color.fromRGBO(226, 232, 240, 1)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16))),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // progressPercentage(acceptanceCriteria),
                              progressAbsolute(acceptanceCriteria),
                              progressRecurring(
                                  acceptanceCriteria, challengeStartDate)
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
  }

  progressAbsolute(AcceptanceCriteriaModel acceptanceCriteria) {
    return acceptanceCriteria.unit != '' || acceptanceCriteria.amount != 0
        ? Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: themeColor4,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Text(
                '${DesignUtil.doubleAsInt(acceptanceCriteria.currentProgress)}/${DesignUtil.doubleAsInt(acceptanceCriteria.amount)} ${acceptanceCriteria.unit}',
                style: const TextStyle(fontSize: 10, color: themeColor3),
                overflow: TextOverflow.ellipsis),
          )
        : Container();
  }

  progressPercentage(AcceptanceCriteriaModel acceptanceCriteria) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      // width: 59,
      decoration: const BoxDecoration(
          color: themeColor4,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Text('${(acceptanceCriteria.calcProgressRatio() * 100).toInt()}%',
          style: const TextStyle(fontSize: 10, color: themeColor3),
          overflow: TextOverflow.ellipsis),
    );
  }

  void onTapEditChallenge() {
    setState(() {
      Slidable.of(context2)?.close(duration: Duration.zero);
    });
    if (currentChallenge.status == ChallengeStatusEnum.inProgress ||
        currentChallenge.status == ChallengeStatusEnum.backlog) {
      Navigator.push(
        context,
        NoAnimationPageRouteComponent(
          builder: (context) => EditChallengePage(
            preTitle: '${widget.preTitle}/${currentChallenge.title}',
            challenge: currentChallenge,
          ),
        ),
      ).then((_) => setState(() {
            context.read<DesignProvider>().setIsBottomNavBarVisible(true);
          }));
    }
  }

  void deleteChallenge() {
    allChallengesList
        .removeWhere((element) => element.id == currentChallenge.id);
    challengeList.removeWhere((element) => element.id == currentChallenge.id);
    challengeController.writeFile(allChallengesList);

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
          preTitle: '${widget.preTitle}/${currentChallenge.title}',
          challenge: currentChallenge,
        ),
      ),
    ).then((_) => setState(() {
          context.read<DesignProvider>().setIsBottomNavBarVisible(true);
        }));
  }

  void onPageChanged(int value) {
    setState(() {
      currentChallenge = challengeList[value];
      currentChallengeIndex = value;
      pageController = PageController(initialPage: value);
      isDescriptionExpanded = false;
    });
  }

  onTapSingleAcceptanceCriteria(
      AcceptanceCriteriaModel acceptanceCriteria) async {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => ProgressPage(
            preTitle: '${widget.preTitle}/${currentChallenge.title}',
            challenge: currentChallenge,
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
          preTitle: '${widget.preTitle}/${currentChallenge.title}',
          mediaList: currentChallenge.media,
          acceptanceCriteria: currentChallenge.acceptanceCriteria,
          challenge: currentChallenge,
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
        if (currentChallenge.isChallengeCompleted()) {
          currentChallenge.status = ChallengeStatusEnum.success;
        } else {
          currentChallenge.status = ChallengeStatusEnum.failed;
        }
        context.read<DesignProvider>().triggerSetStateHomeList();
        setState(() {
          currentChallenge.endDate = DesignUtil.dateWithoutTime(DateTime.now());
          challengeList.map((challenge) => challenge.id == currentChallenge.id
              ? currentChallenge
              : challenge);
          allChallengesList.map((challenge) =>
              challenge.id == currentChallenge.id
                  ? currentChallenge
                  : challenge);
          challengeController.writeFile(allChallengesList);
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
    if (currentChallenge.status == ChallengeStatusEnum.inProgress) {
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
    } else if (currentChallenge.status == ChallengeStatusEnum.failed ||
        currentChallenge.status == ChallengeStatusEnum.success) {
      // Try Again Button and Accept Again
      Navigator.pop(context);
      Navigator.push(
        context,
        NoAnimationPageRouteComponent(
          builder: (context) {
            ChallengeModel challenge = ChallengeModel.copyChallenge(
                currentChallenge,
                isTryAgain: true);
            return EditChallengePage(
              preTitle: '${widget.preTitle}/${currentChallenge.title}',
              challenge: challenge,
              isTryAgain: true,
            );
          },
        ),
      );
    } else if (currentChallenge.status == ChallengeStatusEnum.backlog) {
      setState(() {
        currentChallenge.startDate = DesignUtil.dateWithoutTime(DateTime.now());
        currentChallenge.setEndDate();
        currentChallenge.status = ChallengeStatusEnum.inProgress;
        currentChallenge.acceptanceCriteria.frequency.currentAmount = 1;
      });
      allChallengesList
          .map((e) => e.id == currentChallenge.id ? currentChallenge : e);
      challengeController.writeFile(allChallengesList);
    }
  }

  progressRecurring(AcceptanceCriteriaModel acceptanceCriteria,
      DateTime? challengeStartDate) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: themeColor4,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Text(
          '${acceptanceCriteria.getCurrentFrequencyAmount(challengeStartDate)}/${acceptanceCriteria.frequency.amount ?? '∞'} ${DesignUtil.dayDaysTimeOrTimes(acceptanceCriteria.frequency)}',
          style: const TextStyle(fontSize: 10, color: themeColor3),
          overflow: TextOverflow.ellipsis),
    );
  }
}
