import 'dart:async';

import 'package:camera/camera.dart';
import 'package:challenge/components/challenge/acceptance_criteria_component.dart';
import 'package:challenge/components/challenge/action_button_component.dart';
import 'package:challenge/components/challenge/description_component.dart';
import 'package:challenge/components/challenge/documentation_button_component.dart';
import 'package:challenge/components/challenge/start_and_end_date_component.dart';
import 'package:challenge/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/components/challenge/title_component.dart';
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:challenge/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/components/simple_components/custom_card_component.dart';
import 'package:challenge/components/simple_components/snack_bar_component.dart';
import 'package:challenge/components/simple_components/space_column_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/components/simple_components/tap_container_component.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/pages/dialogs/end_challenge_dialog.dart';
import 'package:challenge/pages/home/repetition/repetition_page.dart';
import 'package:challenge/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:challenge/pages/subpages/media/media_camera_page.dart';
import 'package:challenge/pages/subpages/media/media_list_page.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:challenge/services/challenge_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class HomeChallengePage extends StatefulWidget {
  const HomeChallengePage({
    super.key,
    required this.preTitle,
    required this.initialChallengeIndex,
  });
  final String preTitle;
  final int initialChallengeIndex;

  @override
  State<HomeChallengePage> createState() => _HomeChallengePageState();
}

class _HomeChallengePageState extends State<HomeChallengePage> {
  bool isDescriptionExpanded = false;

  Map<ChallengeModel, BuildContext> challengeSlidableContextMap = {};
  late BuildContext context3;

  late PageController pageController =
      PageController(initialPage: widget.initialChallengeIndex);

  late int currentChallengeIndex = widget.initialChallengeIndex;

  ChallengeController challengeController = ChallengeController();

  ChallengeService challengeService = ChallengeService();

  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    timer?.cancel(); // Step 4: Cancel the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChallengeModel? challenge = challengeList.length > currentChallengeIndex
        ? challengeList[currentChallengeIndex]
        : null;
    challengeList = ChallengeModel.sortChallengeList(challenges: challengeList);
    allChallengesList =
        ChallengeModel.sortChallengeList(challenges: allChallengesList);
    int oldChallengeIndex = currentChallengeIndex;
    currentChallengeIndex =
        challengeList.indexWhere((c) => c.id == challenge?.id);
    if (pageController.hasClients &&
        oldChallengeIndex != currentChallengeIndex) {
      pageController.jumpToPage(currentChallengeIndex);
    }
    return Scaffold(
      appBar: AppBarComponent(preTitle: widget.preTitle),
      backgroundColor: Colors.white,
      body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          scrollDirection: Axis.vertical,
          children: challengeList.map((challenge) {
            challenge.checkChallengeStatus();
            return Slidable(
              closeOnScroll: true,
              // The end action pane is the one at the right or the bottom side.
              key: ObjectKey(challenge),
              endActionPane: endActionPane(challenge),
              child: Builder(builder: (context) {
                challengeSlidableContextMap[challenge] = context;
                return CardComponent(
                  scrollPhysics: challengeList.length == 1
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
      bottomNavigationBar: const BottomNavigationComponent(),
    );
  }

  endActionPane(ChallengeModel challenge) {
    BuildContext? slidableContext = challengeSlidableContextMap[challenge];
    return ActionPane(
      extentRatio: (challenge.isEditable()) ? 0.5 : 0.25,
      motion: const ScrollMotion(),
      children: [
        editSlider(challenge, slidableContext),
        separator(challenge),
        deleteSlider(challenge),
        const SpaceComponent(
          width: 20,
        ),
      ],
    );
  }

  separator(ChallengeModel challenge) {
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
        child: TapContainerComponent(
          onTap: () => onTapDeleteChallenge(challenge),
          borderRadius: 24,
          height: double.infinity,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                IconEnum.delete.icon,
                color: red,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Delete',
                style: TextStyle(color: red),
              )
            ],
          )),
        ),
      ),
    );
  }

  editSlider(ChallengeModel challenge, BuildContext? slidableContext) {
    return (challenge.isEditable())
        ? Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TapContainerComponent(
                onTap: () => onTapEditChallenge(challenge, slidableContext),
                borderRadius: 24,
                height: double.infinity,
                child: const Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Edit')
                  ],
                )),
              ),
            ),
          )
        : Container();
  }

  startEndTryAcceptAgainButton(ChallengeModel challenge) {
    if (isDescriptionExpanded) {
      return Container();
    }
    return ActionButtonComponent(
      challenge: challenge,
      onTapStart: onTapStart,
      onTapEnd: onTapEnd,
      onTapAgain: onTapAgain,
      onTapNext: onTapNext,
    );
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
      onTap: () => setState(() {
        isDescriptionExpanded = !isDescriptionExpanded;
      }),
    );
    return isDescriptionExpanded
        ? Expanded(child: descriptionComponent)
        : Column(
            children: [
              descriptionComponent,
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

  void onTapDeleteChallenge(ChallengeModel challenge) {
    // if (slidableContext != null) {
    Slidable.of(context)?.close(duration: Duration.zero);
    // }

    allChallengesList.removeWhere((element) => element.id == challenge.id);
    challengeList.removeWhere((element) => element.id == challenge.id);
    challengeController.writeFile(allChallengesList);

    setState(() {
      if (currentChallengeIndex >= challengeList.length) {
        currentChallengeIndex = challengeList.length - 1;
      }
    });
    if (challengeList.isEmpty) {
      context.read<DesignProvider>().triggerSetStateHomeList();
      Navigator.pop(context);
    }
  }

  void onTapOpenMediaPage(ChallengeModel challenge) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => MediaListPage(
          preTitle: '${widget.preTitle}/${challenge.title}',
          challenge: challenge,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void onPageChanged(int value) {
    setState(() {
      currentChallengeIndex = value;
      pageController = PageController(initialPage: value);
      isDescriptionExpanded = false;
    });
  }

  onTapAcceptanceCriteria(ChallengeModel challenge) async {
    if (challenge.frequency.amount != null &&
        challenge.frequency.amount! <= 0) {
      return;
    }
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => RepetitionPage(
            preTitle: '${widget.preTitle}/${challenge.title}',
            challenge: challenge),
      ),
    ).then((_) {
      setState(() {
        challengeList =
            ChallengeModel.sortChallengeList(challenges: challengeList);

        int index = challengeList.indexWhere((c) => c.id == challenge.id);

        pageController.jumpToPage(index);
      });
    });
  }

  onTapCamera(ChallengeModel challenge) async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // ignore: use_build_context_synchronously
    Navigator.push(
      // ignore: use_build_context_synchronously
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
          challengeList =
              ChallengeModel.sortChallengeList(challenges: challengeList);

          int index = challengeList.indexWhere((c) => c.id == challenge.id);

          pageController.jumpToPage(index);
        }));
  }

  dialogYesButton(ChallengeModel challenge) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context3);
        context.read<DesignProvider>().triggerSetStateHomeList();
        setState(() {
          challenge.end();

          challengeList = challengeList
              .map((oldChallenge) =>
                  oldChallenge.id == challenge.id ? challenge : oldChallenge)
              .toList();

          challengeList =
              ChallengeModel.sortChallengeList(challenges: challengeList);

          int index = challengeList.indexWhere((c) => c.id == challenge.id);

          pageController.jumpToPage(index);
        });

        allChallengesList = allChallengesList
            .map((oldChallenge) =>
                oldChallenge.id == challenge.id ? challenge : oldChallenge)
            .toList();

        challengeList = challengeList
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
      challengeService.startChallenge(challenge);
      challengeList =
          ChallengeModel.sortChallengeList(challenges: challengeList);
      allChallengesList =
          ChallengeModel.sortChallengeList(challenges: allChallengesList);
      int index = challengeList.indexWhere((c) => c.id == challenge.id);
      pageController.jumpToPage(index);
    });
  }

  onTapEnd(ChallengeModel challenge) {
    if (challenge.canEndRepetition()) {
      setState(() {
        challengeService.nextRepetition(challenge);
      });
      return;
    }

    EndChallengeDialog.show(context, challenge,
        onTapNo: () => Navigator.pop(context),
        onTapYes: (challenge) {
          Navigator.pop(EndChallengeDialog.context3);
          setState(() {
            challengeService.endChallenge(challenge);
          });
          challengeList =
              ChallengeModel.sortChallengeList(challenges: challengeList);
          pageController.jumpToPage(challengeList
              .indexWhere(((element) => element.id == challenge.id)));
        });
  }

  onTapAgain(ChallengeModel challenge) {
    // Try Again Button and Accept Again
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) {
          ChallengeModel challengeCopy =
              challenge.copyChallenge(isTryAgain: true);
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
      challengeService.nextRepetition(challenge);
    });
  }
}
