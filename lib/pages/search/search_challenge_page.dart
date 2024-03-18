import 'package:challenge/pages/components/challenge/amount_and_unit_component.dart';
import 'package:challenge/pages/components/challenge/description_component.dart';
import 'package:challenge/pages/components/challenge/frequency_component.dart';
import 'package:challenge/pages/components/challenge/start_and_end_date_component.dart';
import 'package:challenge/pages/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/pages/components/challenge/title_component.dart';
import 'package:challenge/pages/components/simple_components/custom_card_component.dart';
import 'package:challenge/pages/components/simple_components/space_component.dart';
import 'package:challenge/pages/components/simple_components/snack_bar_component.dart';
import 'package:challenge/pages/components/navigation/app_bar_component.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:challenge/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:challenge/pages/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/pages/home/home_challenge_page.dart';

class SearchChallengePage extends StatefulWidget {
  const SearchChallengePage(
      {super.key,
      required this.title,
      required this.initChallenge,
      required this.selectTab,
      required this.challenges,
      required this.initChalleneIndex});
  final String title;
  final ChallengeModel initChallenge;
  final Function selectTab;
  final List<ChallengeModel> challenges;
  final int initChalleneIndex;

  @override
  State<SearchChallengePage> createState() => _SearchChallengePageState();
}

class _SearchChallengePageState extends State<SearchChallengePage> {
  bool isDescriptionExpanded = false;
  late PageController pageController =
      PageController(initialPage: widget.initChalleneIndex);
  late BuildContext context2;

  bool isKeyboardUp = false;

  late int currentChallengeIndex = widget.initChalleneIndex;
  late ChallengeModel currentChallenge = widget.initChallenge;

  @override
  Widget build(BuildContext context) {
    currentChallenge = widget.challenges[currentChallengeIndex];
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setIsKeyboardUp(false);
      },
      child: Scaffold(
        appBar: AppBarComponent(preTitle: widget.title),
        backgroundColor: Colors.white,
        body: Center(
          child: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              scrollDirection: Axis.vertical,
              children: widget.challenges.map(
                (challenge) {
                  return Slidable(
                    closeOnScroll: true,
                    endActionPane: endActionPane(),
                    child: Builder(builder: (context) {
                      context2 = context;
                      return CardComponent(
                        scrollPhysics: isKeyboardUp
                            ? const AlwaysScrollableScrollPhysics()
                            : widget.challenges.length == 1
                                ? const AlwaysScrollableScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                        children: [
                          thumbnail(challenge, context),
                          title(challenge.title),
                          description(challenge),
                          startAndEndDate(challenge),
                          amountAndUnit(challenge),
                          frequency(challenge),
                          expandedSpace(),
                          acceptButton()
                        ],
                      );
                    }),
                  );
                },
              ).toList()),
        ),
      ),
    );
  }

  ActionPane endActionPane() {
    return ActionPane(
      extentRatio: 0.25,
      motion: const ScrollMotion(),
      children: [
        editSlider(),
        const SpaceComponent(
          width: 20,
        ),
      ],
    );
  }

  Expanded editSlider() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => onTapEditChallenge(),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(24))),
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
    ));
  }

  Widget expandedSpace() {
    return isDescriptionExpanded ? Container() : Expanded(child: Container());
  }

  acceptButton() {
    return isDescriptionExpanded
        ? Container()
        : GestureDetector(
            onTap: onTapAccept,
            child: Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: themeColor2,
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
              child: const Center(
                  child: Text(
                'Accept',
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              )),
            ),
          );
  }

  thumbnail(ChallengeModel challenge, BuildContext context) {
    return Column(
      children: [
        ThumbnailMaxComponent(
          challengeModel: challenge,
          isMediaListVisible: false,
          onTapOpenMediaPage: () => onTapOpenMediaPage(context),
        ),
        const SpaceComponent(
          height: 11,
        )
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

  onTapOpenMediaPage(BuildContext context) {
    SnackBarComponent.showSnackBar(
        context, 'The Video Trailer will be added soon');
  }

  Widget startAndEndDate(ChallengeModel challenge) {
    return isDescriptionExpanded
        ? Container()
        : Column(
            children: [
              StartAndEndDateComponent(editChallenge: challenge),
              const SpaceComponent()
            ],
          );
  }

  void onTapAccept() async {
    ChallengeModel challengeCopy =
        ChallengeModel.copyChallenge(currentChallenge);

    ChallengeController challengeController = ChallengeController();
    allChallengesList.insert(0, challengeCopy);
    challengeList.insert(0, challengeCopy);
    await challengeController.writeFile(context, allChallengesList);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    widget.selectTab(TabItemEnum.Home);

    // ignore: use_build_context_synchronously
    var homeNavigator = navigatorKeys[TabItemEnum.Home]!.currentState!;

    homeNavigator.popUntil((route) => route.isFirst);
    // // ignore: use_build_context_synchronously
    // while (await homeNavigator.maybePop(context)) {
    //   // ignore: use_build_context_synchronously
    //   homeNavigator.pop(context);
    // }
    homeNavigator.push(
      NoAnimationPageRouteComponent(
        builder: (context) => HomeChallengePage(
          preTitle: 'Home',
          initChallenge: challengeCopy,
          initialChalleneIndex: 0,
        ), // Todo: change initalChallengeIndex when id is known from backend
      ),
    );
  }

  void onPageChanged(int value) {
    setState(() {
      currentChallenge = widget.challenges[value];
      currentChallengeIndex = value;
      pageController = PageController(initialPage: value);
      isDescriptionExpanded = false;
    });
  }

  void onTapEditChallenge() {
    Slidable.of(context2)?.close(duration: Duration.zero);
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => EditChallengePage(
          preTitle: '${widget.title}/${currentChallenge.title}',
          challenge: currentChallenge,
          isSearchEdit: true,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  amountAndUnit(ChallengeModel challenge) {
    return isDescriptionExpanded
        ? Container()
        : Column(
            children: [
              AmountAndUnitComponent(
                  acceptanceCriteria: challenge.acceptanceCriterias.first,
                  setIsKeyboardUp: setIsKeyboardUp),
              const SpaceComponent()
            ],
          );
  }

  frequency(ChallengeModel challenge) {
    return isDescriptionExpanded
        ? Container()
        : Column(
            children: [
              FrequencyComponent(
                  challenge: challenge,
                  setIsKeyboardUp: setIsKeyboardUp,
                  reloadSeachChallengePage: setState2),
              const SpaceComponent()
            ],
          );
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

  setIsKeyboardUp(bool isKeyboardReallyUp) {
    setState(() {
      isKeyboardUp = isKeyboardReallyUp;
    });
  }

  setState2() {
    setState(() {});
  }
}
