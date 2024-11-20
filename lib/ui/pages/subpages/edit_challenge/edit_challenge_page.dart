import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_options_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/challenge/amount_and_unit_component.dart';
import 'package:challenge/ui/components/challenge/challenge_start_and_end_date_component.dart';
import 'package:challenge/ui/components/challenge/frequency_component.dart';
import 'package:challenge/ui/components/edit_challenge/add_member_overview_component.dart';
import 'package:challenge/ui/components/edit_challenge/edit_description_component.dart';
import 'package:challenge/ui/components/edit_challenge/expanded_text_field_component.dart';
import 'package:challenge/ui/components/edit_challenge/upload_thumbnail_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_info_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/home/home_challenge_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/add_participants_page.dart';
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
  late String title = widget.isNewChallenge ? 'New Challenge' : 'Edit';

  late final groupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context, listen: false);

  late final tabProvider = Provider.of<TabProvider>(context, listen: false);

  late ChallengeModel editChallenge =
      widget.challenge.copy(isTryAgain: widget.isTryAgain, withId: true);

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  bool isLoading = false;

  List<UserModel> editParticipants = [];

  @override
  void initState() {
    super.initState();
    if (widget.challenge is GroupChallengeModel &&
        (widget.challenge as GroupChallengeModel).participants.length > 1) {
      _initializeParticipants();
    } else {
      editParticipants = [];
    }
  }

  Future<void> _initializeParticipants() async {
    final groupChallenge = widget.challenge as GroupChallengeModel;
    List<ParticipantModel> participants = groupChallenge.participants
        .where((participant) => participant.user.id != usersProvider.user.id)
        .toList();

    final futures = participants
        .map((participant) => usersProvider.getUserById(participant.user.id))
        .toList();

    editParticipants = await Future.wait(futures);
    setState(() {});
  }

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
          appBar: AppBarComponent(preTitle: widget.preTitle, titleText: title),
          backgroundColor: Colors.white,
          body: isUserAbleToEditChallenge()
              ? Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Column(
                              children: [
                                _header(),
                                _details(),
                                _participants(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    cancelAndSaveOrAcceptButton(),
                  ],
                )
              : notAbleToEdit()),
    );
  }

  bool isUserAbleToEditChallenge() {
    if (widget.challenge is GroupChallengeModel) {
      GroupChallengeModel groupChallenge =
          widget.challenge as GroupChallengeModel;
      return groupChallenge.userId == usersProvider.user.id ||
          groupChallenge.groupChallengeOptions.isProgressIndividuell;
    }
    return true;
  }

  Visibility _participants() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: addParticipants(),
    );
  }

  Visibility _details() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: dynamicCard(children: [
        amountAndUnit(),
        frequency(),
        startAndEndDate(),
      ]),
    );
  }

  Flexible _header() {
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: ListItemContainerComponent(
              padding: const EdgeInsets.all(CardComponent.standardPadding),
              isHeightDynamic: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [thumbnailUploadAndTitle(), description()],
              ),
            ),
          ),
          const SpaceComponent()
        ],
      ),
    );
  }

  cancelAndSaveOrAcceptButton() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: Column(
        children: [
          const SpaceComponent(),
          SpaceColumnComponent(
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
        ],
      ),
    );
  }

  startAndEndDate() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: ChallengeStartAndEndDateComponent(
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
    ChallengeModel challengeCopy = editChallenge.copy();

    challengeCopy.id = await groupChallengesProvider.create(
        challengeCopy,
        [...editParticipants, usersProvider.user],
        usersProvider.user,
        GroupChallengeOptionsModel());

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
          initialChallengeId: challengeCopy.id,
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
    GroupChallengeModel groupChallengeCopy =
        editChallenge.copy(withId: true) as GroupChallengeModel;

    groupChallengeCopy.setGoals(editChallenge.acceptanceCriteria.amount);

    await groupChallengesProvider.update(groupChallengeCopy);
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
          acceptanceCriteria: editChallenge.acceptanceCriteria,
        ),
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

  dynamicCard({required List<Widget> children}) {
    return SpaceColumnComponent(
      child: ListItemContainerComponent(
        isHeightDynamic: true,
        padding: const EdgeInsets.all(CardComponent.standardPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  addParticipants() {
    return editParticipants.isEmpty
        ? ListItemIconTextComponent(
            onTap: onTapAddParticipants,
            title: 'Add Participants',
            icon: IconEnum.add.icon,
          )
        : ListItemContainerComponent(
            isHeightDynamic: true,
            padding: const EdgeInsets.all(CardComponent.standardPadding),
            child: Column(
              children: [
                SpaceColumnComponent(
                    child:
                        AddMemberOverviewComponent(members: editParticipants)),
                CustomButtonComponent(
                  onTap: onTapAddParticipants,
                  text: 'Edit Participants',
                  isPrimaryButton: false,
                ),
              ],
            ),
          );
  }

  onTapAddParticipants() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => AddParticipantsPage(
          preTitle: '${widget.preTitle}/$title',
          participants: editParticipants,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  notAbleToEdit() {
    return ListView(
      children: const [
        ListItemInfoComponent(
            text: 'Only the admin of this challenge can edit it.')
      ],
    );
  }
}
