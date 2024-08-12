import 'dart:async';
import 'dart:math';

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
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/pages/dialogs/end_challenge_dialog.dart';
import 'package:challenge/pages/home/repetition/repetition_page.dart';
import 'package:challenge/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:challenge/pages/subpages/media/media_camera_page.dart';
import 'package:challenge/pages/subpages/media/media_list_page.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/services/challenge_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class HomeChallengePage extends StatefulWidget {
  const HomeChallengePage({
    super.key,
    required this.preTitle,
    required this.initialUserChallengeId,
    this.filterOptions = '',
  });
  final String preTitle;
  final String initialUserChallengeId;
  final String filterOptions;

  @override
  State<HomeChallengePage> createState() => _HomeChallengePageState();
}

class _HomeChallengePageState extends State<HomeChallengePage> {
  bool isDescriptionExpanded = false;

  Map<ChallengeModel, BuildContext> challengeSlidableContextMap = {};
  late BuildContext context3;

  late PageController pageController = PageController(
      initialPage: max(
          filteredChallenges.indexWhere((userChallenge) =>
              userChallenge.id == widget.initialUserChallengeId),
          0));

  late int currentChallengeIndex = max(
      filteredChallenges.indexWhere(
          (userChallenge) => userChallenge.id == widget.initialUserChallengeId),
      0);

  ChallengeController challengeController = ChallengeController();

  ChallengeService challengeService = ChallengeService();

  Timer? timer;

  late final userChallengesProvider =
      Provider.of<UserChallengesProvider>(context, listen: false);

  late final listeningProvider =
      Provider.of<UserChallengesProvider>(context, listen: true);

  List<UserChallengeModel> filteredChallenges = [];

  @override
  void initState() {
    super.initState();
    filteredChallenges = userChallengesProvider.userChallenges
        .where((challenge) => challenge.searchInChallenge(widget.filterOptions))
        .toList();
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
    filteredChallenges = listeningProvider.userChallenges
        .where((challenge) => challenge.searchInChallenge(widget.filterOptions))
        .toList();
    return Scaffold(
      appBar: AppBarComponent(preTitle: widget.preTitle),
      backgroundColor: Colors.white,
      body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          scrollDirection: Axis.vertical,
          children: filteredChallenges.map((challenge) {
            challenge.checkChallengeStatus();
            return Slidable(
              closeOnScroll: true,
              // The end action pane is the one at the right or the bottom side.
              key: ObjectKey(challenge),
              endActionPane: endActionPane(challenge),
              child: Builder(builder: (context) {
                challengeSlidableContextMap[challenge] = context;
                return CardComponent(
                  scrollPhysics: filteredChallenges.length == 1
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

  endActionPane(UserChallengeModel userChallenge) {
    BuildContext? slidableContext = challengeSlidableContextMap[userChallenge];
    return ActionPane(
      extentRatio: (userChallenge.isEditable()) ? 0.5 : 0.25,
      motion: const ScrollMotion(),
      children: [
        editSlider(userChallenge, slidableContext),
        separator(userChallenge),
        deleteSlider(userChallenge),
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

  deleteSlider(UserChallengeModel userChallenge) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TapContainerComponent(
          onTap: () => onTapDeleteChallenge(userChallenge),
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

  startEndTryAcceptAgainButton(UserChallengeModel userChallenge) {
    if (isDescriptionExpanded) {
      return Container();
    }
    return ActionButtonComponent(
      userChallenge: userChallenge,
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

  acceptanceCriteria(UserChallengeModel userChallenge) {
    return isDescriptionExpanded
        ? Container()
        : AcceptanceCriteriaComponent(
            onTap: () => onTapAcceptanceCriteria(userChallenge),
            challenge: userChallenge);
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

  void onTapDeleteChallenge(UserChallengeModel userChallenge) async {
    Slidable.of(context)?.close(duration: Duration.zero);
    await userChallengesProvider.delete(userChallenge);

    setState(() {
      if (currentChallengeIndex >=
          userChallengesProvider.userChallenges.length) {
        currentChallengeIndex =
            userChallengesProvider.userChallenges.length - 1;
      }
    });
    if (userChallengesProvider.userChallenges.isEmpty) {
      // ignore: use_build_context_synchronously
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

  onTapAcceptanceCriteria(UserChallengeModel userChallenge) async {
    if (userChallenge.frequency.amount != null &&
        userChallenge.frequency.amount! <= 0) {
      return;
    }
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => RepetitionPage(
            preTitle: '${widget.preTitle}/${userChallenge.title}',
            userChallenge: userChallenge),
      ),
    ).then((_) {
      setState(() {
        int index =
            filteredChallenges.indexWhere((c) => c.id == userChallenge.id);
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
          int index =
              filteredChallenges.indexWhere((c) => c.id == challenge.id);
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
              .toList() as List<UserChallengeModel>;

          challengeList =
              ChallengeModel.sortChallengeList(challenges: challengeList)
                  as List<UserChallengeModel>;

          int index = challengeList.indexWhere((c) => c.id == challenge.id);

          pageController.jumpToPage(index);
        });

        allChallengesList = allChallengesList
            .map((oldChallenge) =>
                oldChallenge.id == challenge.id ? challenge : oldChallenge)
            .toList() as List<UserChallengeModel>;

        challengeList = challengeList
            .map((oldChallenge) =>
                oldChallenge.id == challenge.id ? challenge : oldChallenge)
            .toList() as List<UserChallengeModel>;

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

  onTapStart(UserChallengeModel userChallenge) async {
    await userChallengesProvider.startChallenge(userChallenge);
    setState(() {
      // challengeService.startChallenge(challenge);
      // challengeList =
      //     ChallengeModel.sortChallengeList(challenges: challengeList)
      //         as List<UserChallengeModel>;
      // allChallengesList =
      //     ChallengeModel.sortChallengeList(challenges: allChallengesList)
      //         as List<UserChallengeModel>;
      int index = userChallengesProvider.userChallenges
          .indexWhere((c) => c.id == userChallenge.id);
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
              ChallengeModel.sortChallengeList(challenges: challengeList)
                  as List<UserChallengeModel>;
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
