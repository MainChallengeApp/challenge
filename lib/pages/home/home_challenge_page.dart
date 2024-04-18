import 'package:camera/camera.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/pages/components/challenge/acceptance_criteria_component.dart';
import 'package:challenge/pages/components/challenge/description_component.dart';
import 'package:challenge/pages/components/challenge/documentation_button_component.dart';
import 'package:challenge/pages/components/challenge/start_and_end_date_component.dart';
import 'package:challenge/pages/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/pages/components/challenge/title_component.dart';
import 'package:challenge/pages/components/simple_components/custom_button_component.dart';
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
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:challenge/pages/home/repetition/repetition_page.dart';
import 'package:challenge/pages/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/enums/challenge_status_enum.dart';

class HomeChallengePage extends StatefulWidget {
  const HomeChallengePage(
      {super.key,
      required this.preTitle,
      required this.initialChalleneIndex,
      required this.challenges});
  final String preTitle;
  final int initialChalleneIndex;
  final List<ChallengeModel> challenges;

  @override
  State<HomeChallengePage> createState() => _HomeChallengePageState();
}

class _HomeChallengePageState extends State<HomeChallengePage> {
  bool isDescriptionExpanded = false;

  Map<ChallengeModel, BuildContext> challengeSlidableContextMap = {};
  late BuildContext context3;

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
    return Scaffold(
      appBar: AppBarComponent(preTitle: widget.preTitle),
      backgroundColor: Colors.white,
      body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          scrollDirection: Axis.vertical,
          children: widget.challenges.map((challenge) {
            return Slidable(
              closeOnScroll: true,
              // The end action pane is the one at the right or the bottom side.
              key: ObjectKey(challenge),
              endActionPane: endActionPane(challenge),
              child: Builder(builder: (context) {
                challengeSlidableContextMap[challenge] = context;
                challenge.checkChallengeStatus();
                return CardComponent(
                  scrollPhysics: widget.challenges.length == 1
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  children: [
                    thumbnail(challenge),
                    title(challenge),
                    description(challenge),
                    startAndEndDate(challenge),
                    acceptanceCriteria(challenge),
                    expandedSpace(),
                    documentationButtons(context, challenge),
                    startEndTryAcceptAgainButton(challenge)
                  ],
                );
              }),
            );
          }).toList()),
    );
  }

  endActionPane(ChallengeModel challenge) {
    BuildContext? slidableContext = challengeSlidableContextMap[challenge];
    return ActionPane(
      extentRatio: (challenge.isEditable()) ? 0.5 : 0.25,
      motion: const ScrollMotion(),
      children: [
        editSlider(challenge, slidableContext),
        seperator(challenge),
        deleteSlider(challenge),
        const SpaceComponent(
          width: 20,
        ),
      ],
    );
  }

  seperator(ChallengeModel challenge) {
    return (challenge.isEditable())
        ? const SpaceComponent(
            width: 20,
          )
        : Container();
  }

  expandedSpace() {
    return isDescriptionExpanded ? Container() : Expanded(child: Container());
  }

  title(ChallengeModel challenge) {
    return Column(
      children: [
        TitleComponent(challenge: challenge),
        const SpaceComponent(
          height: 11,
        )
      ],
    );
  }

  thumbnail(ChallengeModel challenge) {
    return Column(
      children: [
        ThumbnailMaxComponent(
            challenge: challenge,
            onTapOpenMediaPage: () => onTapOpenMediaPage(challenge)),
        const SpaceComponent(
          height: 11,
        )
      ],
    );
  }

  deleteSlider(ChallengeModel challenge) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: GestureDetector(
          onTap: () => deleteChallenge(challenge),
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
                  color: red,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Delete",
                  style: TextStyle(color: red),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }

  editSlider(ChallengeModel challenge, BuildContext? slidableContext) {
    return (challenge.isEditable())
        ? Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () => onTapEditChallenge(challenge, slidableContext),
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

  startEndTryAcceptAgainButton(ChallengeModel challenge) {
    if (isDescriptionExpanded) {
      return Container();
    }

    if (challenge.status == ChallengeStatusEnum.backlog) {
      return CustomButtonComponent(
        onTap: () => onTapStart(challenge),
        text: "Start",
        isPrimaryButton: true,
      );
    }

    if ((challenge.frequency.amount == 1 ||
            challenge.getCurrentRepetition() == null ||
            challenge.getCurrentRepetition()!.progressList.isEmpty ||
            challenge.getCurrentRepetitionNumber() ==
                challenge.frequency.getMaxAmoutOfRepetitions()) &&
        challenge.isInProgress()) {
      return CustomButtonComponent(
        onTap: () => onTapEnd(challenge),
        text: "End",
        isPrimaryButton:
            challenge.getCurrentRepetitionProgressPercentageProgess() >= 1,
      );
    }

    if (challenge.status == ChallengeStatusEnum.success) {
      return CustomButtonComponent(
        onTap: () => onTapAgain(challenge),
        text: "Accept Again",
        isPrimaryButton: true,
      );
    }
    if (challenge.status == ChallengeStatusEnum.failed) {
      return CustomButtonComponent(
        onTap: () => onTapAgain(challenge),
        text: "Try Again",
        isPrimaryButton: true,
      );
    }

    if (challenge.frequency.type == FrequencyTypeEnum.daily) {
      return CustomButtonComponent(
          onTap: () => onTapNext(challenge),
          text: "Next in ${challenge.frequency.nextIn()}");
    }

    return CustomButtonComponent(
        onTap: () => onTapNext(challenge),
        isPrimaryButton: challenge.getLastRepetition()!.isComplete(),
        text: "Next");
  }

  documentationButtons(BuildContext context, ChallengeModel challenge) {
    return isDescriptionExpanded
        ? Container()
        : SpaceColumnComponent(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DocumentationButtonComponent(
                  iconData: Icons.numbers_rounded,
                  onTap: () => SnackBarComponent.showSnackBar(
                      context, 'The Numbers feature will be added soon.'),
                  isGrayedOut: true,
                ),
                DocumentationButtonComponent(
                  iconData: Icons.notes_rounded,
                  onTap: () => SnackBarComponent.showSnackBar(
                      context, 'The Notes feature will be added soon.'),
                  isGrayedOut: true,
                ),
                DocumentationButtonComponent(
                  iconData: Icons.gps_not_fixed_rounded,
                  onTap: () => SnackBarComponent.showSnackBar(
                      context, 'The GPS feature will be added soon.'),
                  isGrayedOut: true,
                ),
                DocumentationButtonComponent(
                    iconData: Icons.camera_alt_outlined,
                    onTap: () => onTapCamera(challenge)),
              ],
            ),
          );
  }

  startAndEndDate(ChallengeModel challenge) {
    return isDescriptionExpanded
        ? Container()
        : SpaceColumnComponent(
            child: StartAndEndDateComponent(
              editChallenge: challenge,
              isLocked: true,
            ),
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

  acceptanceCriteria(ChallengeModel challenge) {
    return isDescriptionExpanded
        ? Container()
        : AcceptanceCriteriaComponent(
            onTap: () => onTapAcceptanceCriteria(challenge),
            challenge: challenge);
  }

  void onTapEditChallenge(
      ChallengeModel challenge, BuildContext? slidableContext) {
    setState(() {
      if (slidableContext != null) {
        Slidable.of(slidableContext)!.close(duration: Duration.zero);
      }
    });
    if (challenge.isEditable()) {
      // currentChallengeIndex = widget.challenges.indexOf(challenge);
      Navigator.push(
        context,
        NoAnimationPageRouteComponent(
          builder: (context) => EditChallengePage(
            preTitle: '${widget.preTitle}/${challenge.title}',
            challenge: challenge,
          ),
        ),
      ).then((_) => {setState(() {})});
    }
  }

  void deleteChallenge(ChallengeModel challenge) {
    // if (slidableContext != null) {
    Slidable.of(context)?.close(duration: Duration.zero);
    // }

    allChallengesList.removeWhere((element) => element.id == challenge.id);
    widget.challenges.removeWhere((element) => element.id == challenge.id);
    challengeList.removeWhere((element) => element.id == challenge.id);
    challengeController.writeFile(allChallengesList);

    setState(() {
      if (currentChallengeIndex >= widget.challenges.length) {
        currentChallengeIndex = widget.challenges.length - 1;
      }
    });
    if (widget.challenges.isEmpty) {
      context.read<DesignProvider>().triggerSetStateHomeList();
      Navigator.pop(context);
    }
  }

  void onTapOpenMediaPage(ChallengeModel challenge) {
    context.read<DesignProvider>().setIsBottomNavBarVisible(false);
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => MediaListPage(
          preTitle: '${widget.preTitle}/${challenge.title}',
          challenge: challenge,
        ),
      ),
    ).then((_) => setState(() {
          context.read<DesignProvider>().setIsBottomNavBarVisible(true);
        }));
  }

  void onPageChanged(int value) {
    setState(() {
      currentChallengeIndex = value;
      pageController = PageController(initialPage: value);
      isDescriptionExpanded = false;
    });
  }

  onTapAcceptanceCriteria(ChallengeModel challenge) async {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => RepetitionPage(
            preTitle: '${widget.preTitle}/${challenge.title}',
            challenge: challenge),
      ),
    ).then((_) => setState(() {
          context.read<DesignProvider>().setIsBottomNavBarVisible(true);
        }));
  }

  onTapCamera(ChallengeModel challenge) async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // ignore: use_build_context_synchronously
    context.read<DesignProvider>().setIsBottomNavBarVisible(false);

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => MediaCameraPage(
          cameras: cameras,
          preTitle: '${widget.preTitle}/${challenge.title}',
          mediaList: challenge.media,
          challenge: challenge,
        ),
      ),
    ).then((_) => setState(() {
          context.read<DesignProvider>().setIsBottomNavBarVisible(true);
        }));
  }

  dialogYesButton(ChallengeModel challenge) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context3);
        context.read<DesignProvider>().triggerSetStateHomeList();
        setState(() {
          challenge.end();
        });

        allChallengesList = allChallengesList
            .map((oldChallenge) =>
                oldChallenge.id == challenge.id ? challenge : oldChallenge)
            .toList();

        challengeList = challengeList
            .map((oldChallenge) =>
                oldChallenge.id == challenge.id ? challenge : oldChallenge)
            .toList();

        widget.challenges
            .map((oldChallenge) =>
                oldChallenge.id == challenge.id ? challenge : oldChallenge)
            .toList();

        challengeController.writeFile(allChallengesList);
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

  onTapStart(ChallengeModel challenge) {
    setState(() {
      challenge.start();
      allChallengesList = allChallengesList.map((e) {
        return e.id == challenge.id ? challenge : e;
      }).toList();
      challengeList = challengeList
          .map((e) => e.id == challenge.id ? challenge : e)
          .toList();
      widget.challenges.map((e) => e.id == challenge.id ? challenge : e);
      challengeController.writeFile(allChallengesList);
    });
  }

  onTapEnd(ChallengeModel challenge) {
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
                        Expanded(child: dialogYesButton(challenge)),
                        const SpaceComponent(),
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
  }

  onTapAgain(ChallengeModel challenge) {
    // Try Again Button and Accept Again
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) {
          ChallengeModel challengeCopy = ChallengeModel.copyChallenge(
              challenge: challenge, isTryAgain: true);
          return EditChallengePage(
            preTitle: '${widget.preTitle}/${challengeCopy.title}',
            challenge: challengeCopy,
            isTryAgain: true,
          );
        },
      ),
    ).then((_) => setState(() {}));
  }

  onTapNext(ChallengeModel challenge) {
    setState(() {
      challenge.nextRepetition();
      allChallengesList = allChallengesList.map((e) {
        return e.id == challenge.id ? challenge : e;
      }).toList();
      challengeList = challengeList
          .map((e) => e.id == challenge.id ? challenge : e)
          .toList();
      widget.challenges.map((e) => e.id == challenge.id ? challenge : e);
      challengeController.writeFile(allChallengesList);
    });
  }
}
