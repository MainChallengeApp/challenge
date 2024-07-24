import 'package:challenge/components/challenge/amount_and_unit_component.dart';
import 'package:challenge/components/challenge/description_component.dart';
import 'package:challenge/components/challenge/frequency_component.dart';
import 'package:challenge/components/challenge/start_and_end_date_component.dart';
import 'package:challenge/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/components/challenge/title_component.dart';
import 'package:challenge/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/components/simple_components/custom_card_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/components/simple_components/snack_bar_component.dart';
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:challenge/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:challenge/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/pages/home/home_challenge_page.dart';
import 'package:provider/provider.dart';

class SearchChallengePage extends StatefulWidget {
  const SearchChallengePage(
      {super.key,
      required this.title,
      required this.initChallenge,
      required this.challenges,
      required this.initChallengeIndex});
  final String title;
  final ChallengeModel initChallenge;
  final List<ChallengeModel> challenges;
  final int initChallengeIndex;

  @override
  State<SearchChallengePage> createState() => _SearchChallengePageState();
}

class _SearchChallengePageState extends State<SearchChallengePage> {
  bool isDescriptionExpanded = false;
  late PageController pageController =
      PageController(initialPage: widget.initChallengeIndex);
  Map<ChallengeModel, BuildContext> challengeSlidableContextMap = {};

  bool isKeyboardUp = false;

  late int currentChallengeIndex = widget.initChallengeIndex;

  @override
  Widget build(BuildContext context) {
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
                    endActionPane: endActionPane(challenge),
                    child: Builder(builder: (context) {
                      challengeSlidableContextMap[challenge] = context;
                      return CardComponent(
                        scrollPhysics: isKeyboardUp
                            ? const AlwaysScrollableScrollPhysics()
                            : widget.challenges.length == 1
                                ? const AlwaysScrollableScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                        children: [
                          thumbnail(challenge, context),
                          title(challenge),
                          description(challenge),
                          amountAndUnit(challenge),
                          frequency(challenge),
                          startAndEndDate(challenge),
                          expandedSpace(),
                          acceptButton(challenge)
                        ],
                      );
                    }),
                  );
                },
              ).toList()),
        ),
        bottomNavigationBar: const BottomNavigationComponent(),
      ),
    );
  }

  ActionPane endActionPane(ChallengeModel challenge) {
    return ActionPane(
      extentRatio: 0.25,
      motion: const ScrollMotion(),
      children: [
        editSlider(challenge),
        const SpaceComponent(
          width: 20,
        ),
      ],
    );
  }

  Expanded editSlider(ChallengeModel challenge) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => onTapEditChallenge(challenge),
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

  acceptButton(ChallengeModel challenge) {
    return isDescriptionExpanded
        ? Container()
        : GestureDetector(
            onTap: () => onTapAccept(challenge),
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
          challenge: challenge,
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
              StartAndEndDateComponent(
                editChallenge: challenge,
                reloadSearchChallengePage: () => setState2(),
              ),
              const SpaceComponent()
            ],
          );
  }

  void onTapAccept(ChallengeModel challenge) async {
    ChallengeModel challengeCopy =
        ChallengeModel.copyChallenge(challenge: challenge);

    ChallengeController challengeController = ChallengeController();
    allChallengesList.insert(0, challengeCopy);
    challengeList.insert(0, challengeCopy);
    await challengeController.writeFile(allChallengesList);

    // ignore: use_build_context_synchronously
    context.read<TabProvider>().selectTab(TabItemEnum.Home);

    // ignore: use_build_context_synchronously
    var homeNavigator = navigatorKeys[TabItemEnum.Home]!.currentState!;

    homeNavigator.popUntil((route) => route.isFirst);
    // // ignore: use_build_context_synchronously
    // while (await homeNavigator.maybePop(context)) {
    //   // ignore: use_build_context_synchronously
    //   homeNavigator.pop(context);
    // }

    /**
     * somehow does the home list page not refresh
     * when completing a challenge
     * with frequency.amount = 0
     */
    homeNavigator
        .push(
      NoAnimationPageRouteComponent(
        builder: (context) => const HomeChallengePage(
          preTitle: 'Home',
          initialChallengeIndex: 0,
        ),
      ),
    )
        .then((value) {
      homeNavigator.setState(() {});
    });
  }

  void onPageChanged(int value) {
    setState(() {
      currentChallengeIndex = value;
      pageController = PageController(initialPage: value);
      isDescriptionExpanded = false;
    });
  }

  void onTapEditChallenge(ChallengeModel challenge) {
    setState(() {
      if (challengeSlidableContextMap[challenge] != null) {
        Slidable.of(challengeSlidableContextMap[challenge]!)!
            .close(duration: Duration.zero);
      }
    });
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => EditChallengePage(
          preTitle: '${widget.title}/${challenge.title}',
          challenge: challenge,
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
                  acceptanceCriteria: challenge.acceptanceCriteria,
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
                  reloadSearchChallengePage: setState2),
              const SpaceComponent()
            ],
          );
  }

  title(ChallengeModel challenge) {
    return Column(
      children: [
        TitleComponent(
          challenge: challenge,
          isSearch: true,
        ),
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
