import 'dart:math';

import 'package:camera/camera.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/challenge/acceptance_criteria_component.dart';
import 'package:challenge/ui/components/challenge/action_button_component.dart';
import 'package:challenge/ui/components/challenge/description_component.dart';
import 'package:challenge/ui/components/challenge/documentation_button_component.dart';
import 'package:challenge/ui/components/challenge/start_and_end_date_component.dart';
import 'package:challenge/ui/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/ui/components/challenge/title_with_percentage_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/slider_component.dart';
import 'package:challenge/ui/components/simple_components/snack_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/title_component.dart';
import 'package:challenge/ui/dialogs/delete_challenge_dialog.dart';
import 'package:challenge/ui/dialogs/end_challenge_dialog.dart';
import 'package:challenge/ui/pages/home/repetition/progress_media_list_page.dart';
import 'package:challenge/ui/pages/home/repetition/repetition_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:challenge/ui/pages/subpages/media/media_camera_page.dart';
import 'package:challenge/ui/pages/subpages/media/media_list_page.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
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
          filteredChallenges.indexWhere((userChallenge) =>
              userChallenge.id == widget.initialUserChallengeId),
          0));

  late int currentChallengeIndex = max(
      filteredChallenges.indexWhere(
          (userChallenge) => userChallenge.id == widget.initialUserChallengeId),
      0);

  late final userChallengesProvider =
      Provider.of<UserChallengesProvider>(context, listen: false);
  late final listeningUserChallengesProvider =
      Provider.of<UserChallengesProvider>(context, listen: true);

  late final groupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context, listen: false);
  late final listeningGroupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context, listen: true);

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  List<UserChallengeModel> filteredUserChallenges = [];
  List<GroupChallengeModel> filteredGroupChallenges = [];
  List<ChallengeModel> filteredChallenges = [];

  @override
  Widget build(BuildContext context) {
    filteredUserChallenges = listeningUserChallengesProvider.userChallenges
        .where((element) => element.searchInChallenge(widget.filterOptions))
        .toList();

    filteredGroupChallenges = listeningGroupChallengesProvider.groupChallenges
        .where((element) => element.searchInChallenge(widget.filterOptions))
        .toList();

    filteredChallenges = [];

    filteredChallenges.addAll(filteredUserChallenges);
    filteredChallenges.addAll(filteredGroupChallenges);
    filteredChallenges =
        ChallengeModel.sortChallengeList(challenges: filteredChallenges);

    // if (filteredUserChallenges.isEmpty) {
    //   filteredUserChallenges = listeningUserChallengesProvider.userChallenges
    //       .where(
    //           (challenge) => challenge.searchInChallenge(widget.filterOptions))
    //       .toList();
    // }
    // UserChallengeModel currentChallenge =
    //     filteredUserChallenges[currentChallengeIndex];

    // filteredUserChallenges = listeningUserChallengesProvider.userChallenges
    //     .where((challenge) => challenge.searchInChallenge(widget.filterOptions))
    //     .toList();

    // int index =
    //     filteredUserChallenges.indexWhere((c) => c.id == currentChallenge.id);

    // if (index != currentChallengeIndex && index != -1) {
    //   currentChallengeIndex = index;
    //   // setState(() {
    //   pageController.jumpToPage(index);
    //   // });
    // }

    return Scaffold(
      appBar: AppBarComponent(preTitle: widget.preTitle),
      backgroundColor: Colors.white,
      body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          children: filteredChallenges.map((challenge) {
            challenge.checkChallengeStatus();
            return Slidable(
              closeOnScroll: true,
              key: ObjectKey(challenge),
              endActionPane: endActionPane(challenge),
              child: Builder(builder: (context) {
                return CardComponent(
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
    return ActionPane(
      extentRatio: (challenge.isEditable()) ? 0.5 : 0.25,
      motion: const ScrollMotion(),
      children: [
        editSlider(challenge),
        separator(challenge),
        deleteSlider(challenge),
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
    return SpaceColumnComponent(
      height: 11,
      child: challenge is UserChallengeModel
          ? TitleWithPercentageComponent(userChallenge: challenge)
          : TitleComponent(title: challenge.title),
    );
  }

  thumbnail(ChallengeModel challenge) {
    return SpaceColumnComponent(
      height: 11,
      child: ThumbnailMaxComponent(
          challenge: challenge,
          onTapOpenMediaPage: () => onTapOpenMediaPage(challenge)),
    );
  }

  deleteSlider(ChallengeModel challenge) {
    return SliderComponent(
        icon: IconEnum.delete.icon,
        label: 'Delete',
        foregroundColor: Theme.of(context).colorScheme.red.withAlpha(150),
        duration: Durations.short1,
        onTap: () => onTapDeleteChallenge(challenge));
  }

  editSlider(ChallengeModel challenge) {
    return Visibility(
      visible: challenge.isEditable(),
      child: SliderComponent(
          icon: IconEnum.edit.icon,
          label: 'Edit',
          onTap: () {
            onTapEditChallenge(challenge);
          }),
    );
  }

  startEndTryAcceptAgainButton(ChallengeModel challenge) {
    if (challenge is GroupChallengeModel) {
      return Container();
    } else if (challenge is UserChallengeModel) {
      return ActionButtonComponent(
        userChallenge: challenge,
        onTapStart: onTapStart,
        onTapEnd: onTapEnd,
        onTapAgain: onTapAgain,
        onTapNext: onTapNext,
      );
    } else {
      throw Exception('Challenge type not supported');
    }
  }

  documentationButtons(BuildContext context, ChallengeModel challenge) {
    return Visibility(
      visible: !isDescriptionExpanded && challenge.isInProgress(),
      child: SpaceColumnComponent(
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
        ? Expanded(
            child: Column(
            children: [
              Expanded(child: descriptionComponent),
              challenge.description.isNotEmpty
                  ? const SpaceComponent()
                  : Container()
            ],
          ))
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
            onTapNewProgress: () => onTapNewProgress(challenge),
            challenge: challenge);
  }

  void onTapEditChallenge(ChallengeModel challenge) {
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

  void onTapDeleteChallenge(ChallengeModel challenge) async {
    DeleteChallengeDialog.show(
        context: context,
        challengeTitle: challenge.title,
        onTapYes: () async {
          if (challenge is UserChallengeModel) {
            await userChallengesProvider.delete(challenge);
          } else if (challenge is GroupChallengeModel) {
            await groupChallengesProvider.delete(challenge);
          }
          setState(() {
            if (currentChallengeIndex >= filteredChallenges.length) {
              currentChallengeIndex = filteredChallenges.length - 1;
            }
          });
          if (filteredChallenges.length == 1) {
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
        });
  }

  void onTapOpenMediaPage(ChallengeModel challenge) {
    if (challenge is GroupChallengeModel &&
        challenge.toUserChallengeModel(usersProvider.user.id) == null) {
      return;
    }

    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => MediaListPage(
          preTitle: '${widget.preTitle}/${challenge.title}',
          userChallenge: challenge is UserChallengeModel
              ? challenge
              : (challenge as GroupChallengeModel)
                  .toUserChallengeModel(usersProvider.user.id)!,
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

  onTapAcceptanceCriteria(ChallengeModel challenge) {
    if (challenge is GroupChallengeModel) {
      return;
    } else if (challenge is UserChallengeModel) {
      if (challenge.frequency.amount != null &&
          challenge.frequency.amount! <= 0) {
        return;
      }
      Navigator.push(
        context,
        NoAnimationPageRouteComponent(
          builder: (context) => RepetitionPage(
              preTitle: '${widget.preTitle}/${challenge.title}',
              userChallenge: challenge),
        ),
      );
    } else {
      throw Exception('Challenge type not supported');
    }
  }

  onTapCamera(ChallengeModel challenge) async {
    if (challenge is GroupChallengeModel &&
        challenge.toUserChallengeModel(usersProvider.user.id) == null) {
      return;
    }

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
          userChallenge: challenge is UserChallengeModel
              ? challenge
              : (challenge as GroupChallengeModel)
                  .toUserChallengeModel(usersProvider.user.id)!,
        ),
      ),
    );
  }

  onTapStart(UserChallengeModel userChallenge) {
    userChallengesProvider.start(userChallenge);
  }

  onTapEnd(UserChallengeModel userChallenge) {
    if (userChallenge.canEndRepetition()) {
      userChallenge.endRepetition();
      userChallengesProvider.update(userChallenge);
      return;
    }

    EndChallengeDialog.show(
        context: context,
        challengeTitle: userChallenge.title,
        onTapYes: () {
          userChallengesProvider.end(userChallenge);
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
    userChallenge.endRepetition();
    userChallengesProvider.update(userChallenge);
  }

  void onTapNewProgress(ChallengeModel challenge) {
    if (challenge is GroupChallengeModel) {
      return;
    } else if (challenge is UserChallengeModel) {
      if (challenge.getCurrentRepetition() == null) {
        return;
      }

      Navigator.push(
        context,
        NoAnimationPageRouteComponent(
          builder: (context) => ProgressMediaListPage(
            preTitle: '${widget.preTitle}/${challenge.title}',
            repetition: challenge.getCurrentRepetition()!,
            userChallenge: challenge,
            isSaveInsteadOfEditButtonVisible: true,
          ),
        ),
      ).then((_) => setState(() {}));
    }
  }
}
