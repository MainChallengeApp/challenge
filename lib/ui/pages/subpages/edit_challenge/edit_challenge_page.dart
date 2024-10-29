import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/ui/components/challenge/amount_and_unit_component.dart';
import 'package:challenge/ui/components/challenge/frequency_component.dart';
import 'package:challenge/ui/components/challenge/start_and_end_date_component.dart';
import 'package:challenge/ui/components/edit_challenge/edit_description_component.dart';
import 'package:challenge/ui/components/edit_challenge/expanded_text_field_component.dart';
import 'package:challenge/ui/components/edit_challenge/upload_thumbnail_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/home/home_challenge_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditChallengePage extends StatefulWidget {
  final String preTitle;
  final ChallengeModel challenge;
  final bool isNewChallenge;
  final bool isTryAgain;
  final bool isSearchEdit;
  final bool isSearchNewChallenge;

  const EditChallengePage(
      {super.key,
      required this.preTitle,
      required this.challenge,
      this.isSearchEdit = false,
      this.isNewChallenge = false,
      this.isTryAgain = false,
      this.isSearchNewChallenge = false});

  @override
  State<EditChallengePage> createState() => _EditChallengePageState();
}

class _EditChallengePageState extends State<EditChallengePage> {
  bool isDescriptionExpanded = false;

  late final userChallengesProvider =
      Provider.of<UserChallengesProvider>(context, listen: false);

  late final tabProvider = Provider.of<TabProvider>(context, listen: false);

  late ChallengeModel editChallenge = widget.challenge
      .copyChallenge(isTryAgain: widget.isTryAgain, withId: true);

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          isDescriptionExpanded = false;
        });
      },
      child: Scaffold(
          resizeToAvoidBottomInset: isDescriptionExpanded ? true : false,
          appBar: AppBarComponent(
              preTitle: widget.preTitle,
              titleText: widget.isNewChallenge ? 'New Challenge' : 'Edit'),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      dynamicCard(
                        children: [
                          thumbnailUploadAndTitle(),
                          description(),
                        ],
                      ),
                      Visibility(
                        visible: !isDescriptionExpanded,
                        child: dynamicCard(children: [
                          amountAndUnit(),
                          frequency(),
                          startAndEndDate(),
                        ]),
                      ),
                      Visibility(
                        visible: !isDescriptionExpanded,
                        child: dynamicCard(children: [
                          addMember(),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              cancelAndSaveOrAcceptButton()
            ],
          )),
    );
  }

  cancelAndSaveOrAcceptButton() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: SpaceColumnComponent(
        height: BottomNavigationComponent.standardMargin,
        child: Row(
          children: [
            Expanded(
              child: ListItemButtonComponent(
                onTap: onTapCancel,
                isMainButton: false,
                text: 'Cancel',
                margin: const EdgeInsets.only(
                    left: CardComponent.standardSideMargin,
                    right: CardComponent.standardSideMargin / 2),
              ),
            ),
            widget.isSearchEdit ||
                    widget.isSearchNewChallenge ||
                    widget.isNewChallenge ||
                    widget.isTryAgain
                ? Expanded(
                    child: ListItemButtonComponent(
                      onTap: onTapAccept,
                      text: 'Accept',
                      isMainButton: true,
                      isLoading: isLoading,
                      margin: const EdgeInsets.only(
                          left: CardComponent.standardSideMargin / 2,
                          right: CardComponent.standardSideMargin),
                    ),
                  )
                : Expanded(
                    child: ListItemButtonComponent(
                      onTap: onTapSave,
                      text: 'Save',
                      isMainButton: true,
                      isLoading: isLoading,
                      margin: const EdgeInsets.only(
                          left: CardComponent.standardSideMargin / 2,
                          right: CardComponent.standardSideMargin),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  startAndEndDate() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: StartAndEndDateComponent(
        editChallenge: editChallenge,
        reloadSearchChallengePage: () => setState(
          () {},
        ),
      ),
    );
  }

  description() {
    EditDescriptionComponent descriptionComponent = EditDescriptionComponent(
      challenge: editChallenge,
      isDescriptionExpanded: isDescriptionExpanded,
      onTap: () => setState(() {
        isDescriptionExpanded = !isDescriptionExpanded;
      }),
    );
    return isDescriptionExpanded
        ? Expanded(child: descriptionComponent)
        : descriptionComponent;
  }

  thumbnailUploadAndTitle() {
    return Column(
      children: [
        Row(
          children: [
            UploadThumbnailComponent(editChallenge: editChallenge),
            const SpaceComponent(),
            ExpandedTextFieldComponent(editChallenge: editChallenge)
          ],
        ),
        const SpaceComponent()
      ],
    );
  }

  void onTapCancel() {
    Navigator.pop(context);
  }

  void onTapAccept() async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    ChallengeModel challengeCopy = editChallenge.copyChallenge();
    challengeCopy.createdAt = DateTime.now();

    await userChallengesProvider.create(challengeCopy);

    setState(() {
      isLoading = false;
    });

    // ignore: use_build_context_synchronously
    context.read<TabProvider>().selectTab(TabItemEnum.search);
    // ignore: use_build_context_synchronously
    context.read<TabProvider>().selectTab(TabItemEnum.home);

    var homeNavigator =
        tabProvider.navigatorKeys[TabItemEnum.home]!.currentState!;

    homeNavigator.popUntil((route) => route.isFirst);

    homeNavigator.push(
      NoAnimationPageRouteComponent(
        builder: (context) => HomeChallengePage(
          preTitle: 'Home',
          initialUserChallengeId: challengeCopy.id,
        ),
      ),
    );
  }

  void onTapSave() async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    UserChallengeModel userChallengeCopy =
        editChallenge.copyChallenge(withId: true) as UserChallengeModel;

    userChallengeCopy.setGoals(editChallenge.acceptanceCriteria.amount);

    await userChallengesProvider.update(userChallengeCopy);
    setState(() {
      isLoading = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  amountAndUnit() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: SpaceColumnComponent(
        child: AmountAndUnitComponent(
            acceptanceCriteria: editChallenge.acceptanceCriteria),
      ),
    );
  }

  frequency() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: SpaceColumnComponent(
        child: FrequencyComponent(
          challenge: editChallenge,
          reloadSearchChallengePage: () => setState(
            () {},
          ),
        ),
      ),
    );
  }

  member() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: const SpaceColumnComponent(
        child: CustomContainerComponent(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Add Member'),
              Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      ),
    );
  }

  dynamicCard({required List<Widget> children}) {
    return SpaceColumnComponent(
      child: CustomContainerComponent(
        borderRadius: CardComponent.standardBorderRadius,
        margin: const EdgeInsets.only(
            left: CardComponent.standardSideMargin,
            right: CardComponent.standardSideMargin),
        padding: const EdgeInsets.all(CardComponent.standardPadding),
        isHeightDynamic: true,
        child: Column(
          children: children,
        ),
      ),
    );
  }

  addMember() {
    return const SpaceColumnComponent(
        child: CustomContainerComponent(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Add Member'),
          Icon(Icons.arrow_forward_ios_rounded),
        ],
      ),
    ));
  }
}
