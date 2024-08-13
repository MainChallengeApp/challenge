import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/ui/components/challenge/acceptance_criteria_component.dart';
import 'package:challenge/ui/components/challenge/action_button_component.dart';
import 'package:challenge/ui/components/challenge/description_component.dart';
import 'package:challenge/ui/components/challenge/documentation_button_component.dart';
import 'package:challenge/ui/components/challenge/start_and_end_date_component.dart';
import 'package:challenge/ui/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/ui/components/challenge/title_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/slider_component.dart';
import 'package:challenge/ui/components/simple_components/snack_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/dialogs/end_challenge_dialog.dart';
import 'package:challenge/ui/pages/home/repetition/progress_media_list_page.dart';
import 'package:challenge/ui/pages/home/repetition/repetition_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:challenge/ui/pages/subpages/media/media_camera_page.dart';
import 'package:challenge/ui/pages/subpages/media/media_list_page.dart';
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

  late PageController pageController = PageController(
      initialPage: max(
          filteredUserChallenges.indexWhere((userChallenge) =>
              userChallenge.id == widget.initialUserChallengeId),
          0));

  late int currentChallengeIndex = max(
      filteredUserChallenges.indexWhere(
          (userChallenge) => userChallenge.id == widget.initialUserChallengeId),
      0);

  Timer? setStateTimer;

  late final userChallengesProvider =
      Provider.of<UserChallengesProvider>(context, listen: false);

  late final listeningProvider =
      Provider.of<UserChallengesProvider>(context, listen: true);

  late List<UserChallengeModel> filteredUserChallenges = userChallengesProvider
      .getAllOfUser()
      .where((challenge) => challenge.searchInChallenge(widget.filterOptions))
      .toList();

  @override
  void initState() {
    super.initState();
    setStateTimer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    setStateTimer?.cancel(); // Step 4: Cancel the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    filteredUserChallenges = listeningProvider.userChallenges
        .where((challenge) => challenge.searchInChallenge(widget.filterOptions))
        .toList();

    return Scaffold(
      appBar: AppBarComponent(preTitle: widget.preTitle),
      backgroundColor: Colors.white,
      body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          scrollDirection: Axis.vertical,
          children: filteredUserChallenges.map((userChallenge) {
            userChallenge.checkChallengeStatus();
            return Slidable(
              closeOnScroll: true,
              key: ObjectKey(userChallenge),
              endActionPane: endActionPane(userChallenge),
              child: Builder(builder: (context) {
                return CardComponent(
                  scrollPhysics: filteredUserChallenges.length == 1
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  children: [
                    thumbnail(userChallenge),
                    title(userChallenge),
                    description(userChallenge),
                    startAndEndDate(userChallenge),
                    acceptanceCriteria(userChallenge),
                    expandedSpace(),
                    documentationButtons(context, userChallenge),
                    startEndTryAcceptAgainButton(userChallenge)
                  ],
                );
              }),
            );
          }).toList()),
      bottomNavigationBar: const BottomNavigationComponent(),
    );
  }

  endActionPane(UserChallengeModel userChallenge) {
    return ActionPane(
      extentRatio: (userChallenge.isEditable()) ? 0.5 : 0.25,
      motion: const ScrollMotion(),
      children: [
        editSlider(userChallenge),
        separator(userChallenge),
        deleteSlider(userChallenge),
        const SpaceComponent(
          width: 20,
        ),
      ],
    );
  }

  separator(ChallengeModel challenge) {
    return SpaceComponent(
      width: 20,
      isVisible: challenge.isEditable(),
    );
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

  thumbnail(UserChallengeModel userChallenge) {
    return Column(
      children: [
        ThumbnailMaxComponent(
            challenge: userChallenge,
            onTapOpenMediaPage: () => onTapOpenMediaPage(userChallenge)),
        const SpaceComponent(
          height: 11,
        )
      ],
    );
  }

  deleteSlider(UserChallengeModel userChallenge) {
    return SliderComponent(
        icon: IconEnum.delete.icon,
        label: 'Delete',
        foregroundColor: red,
        onTap: () => onTapDeleteChallenge(userChallenge));
  }

  editSlider(UserChallengeModel userChallenge) {
    return Visibility(
      visible: userChallenge.isEditable(),
      child: SliderComponent(
          icon: IconEnum.edit.icon,
          label: 'Edit',
          onTap: () {
            onTapEditChallenge(userChallenge);
          }),
    );
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

  documentationButtons(BuildContext context, UserChallengeModel userChallenge) {
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
                    onTap: () => onTapCamera(userChallenge)),
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
            onTapNewProgress: () => onTapNewProgress(userChallenge),
            challenge: userChallenge);
  }

  void onTapEditChallenge(UserChallengeModel userChallenge) {
    if (userChallenge.isEditable()) {
      // currentChallengeIndex = widget.challenges.indexOf(challenge);
      Navigator.push(
        context,
        NoAnimationPageRouteComponent(
          builder: (context) => EditChallengePage(
            preTitle: '${widget.preTitle}/${userChallenge.title}',
            challenge: userChallenge,
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

  void onTapOpenMediaPage(UserChallengeModel userChallenge) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => MediaListPage(
          preTitle: '${widget.preTitle}/${userChallenge.title}',
          userChallenge: userChallenge,
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

  onTapAcceptanceCriteria(UserChallengeModel userChallenge) {
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
        filteredUserChallenges = userChallengesProvider.userChallenges
            .where((challenge) =>
                challenge.searchInChallenge(widget.filterOptions))
            .toList();

        int index =
            filteredUserChallenges.indexWhere((c) => c.id == userChallenge.id);
        pageController.jumpToPage(index);
      });
    });
  }

  onTapCamera(UserChallengeModel userChallenge) async {
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
          preTitle: '${widget.preTitle}/${userChallenge.title}',
          mediaList: userChallenge.media,
          userChallenge: userChallenge,
        ),
      ),
    ).then((_) => setState(() {
          int index = filteredUserChallenges
              .indexWhere((c) => c.id == userChallenge.id);
          pageController.jumpToPage(index);
        }));
  }

  onTapStart(UserChallengeModel userChallenge) {
    setState(() {
      userChallenge.start();
      updateFilteredUserChallenges(userChallenge);
      int index = getLocalIndex(userChallenge.id);
      pageController.jumpToPage(index);
    });
    userChallengesProvider.update(userChallenge);
  }

  onTapEnd(UserChallengeModel userChallenge) {
    if (userChallenge.canEndRepetition()) {
      setState(() {
        userChallenge.endRepetition();
        updateFilteredUserChallenges(userChallenge);
        int index = getLocalIndex(userChallenge.id);
        pageController.jumpToPage(index);
      });
      userChallengesProvider.update(userChallenge);
      return;
    }

    EndChallengeDialog.show(
        context: context,
        onTapYes: () {
          userChallenge.end();
          updateFilteredUserChallenges(userChallenge);
          int index = getLocalIndex(userChallenge.id);
          pageController.jumpToPage(index);
          userChallengesProvider.update(userChallenge);
        });
  }

  onTapAgain(ChallengeModel challenge) {
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
    );
  }

  onTapNext(UserChallengeModel userChallenge) {
    setState(() {
      userChallenge.endRepetition();
      updateFilteredUserChallenges(userChallenge);
      int index = getLocalIndex(userChallenge.id);
      pageController.jumpToPage(index);
    });
    userChallengesProvider.update(userChallenge);
  }

  int getLocalIndex(String userChallengeId) {
    return filteredUserChallenges.indexWhere((uc) => uc.id == userChallengeId);
  }

  void updateFilteredUserChallenges(UserChallengeModel userChallenge) {
    userChallengesProvider.updateLocalList(userChallenge);
    filteredUserChallenges = userChallengesProvider.userChallenges
        .where((challenge) => challenge.searchInChallenge(widget.filterOptions))
        .toList();
    filteredUserChallenges[getLocalIndex(userChallenge.id)] = userChallenge;
    filteredUserChallenges =
        ChallengeModel.sortChallengeList(challenges: filteredUserChallenges)
            as List<UserChallengeModel>;
  }

  void onTapNewProgress(UserChallengeModel userChallenge) {
    if (userChallenge.getCurrentRepetition() == null) {
      return;
    }

    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => ProgressMediaListPage(
          preTitle:
              '${widget.preTitle}/${userChallenge.title}/Repetitions/${userChallenge.getCurrentRepetition()!.repetitionNumber}',
          repetition: userChallenge.getCurrentRepetition()!,
          userChallenge: userChallenge,
          isSaveInsteadOfEditButtonVisible: true,
        ),
      ),
    ).then((_) => setState(() {
          // context.read<DesignProvider>().setIsBottomNavBarVisible(true);
        }));
  }
}
