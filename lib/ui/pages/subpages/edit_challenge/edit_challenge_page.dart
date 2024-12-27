import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
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
import 'package:challenge/ui/components/challenge/frequency_component.dart';
import 'package:challenge/ui/components/challenge/start_and_end_date_component.dart';
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
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/home/home_challenge_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/add_participants_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditChallengePage extends StatefulWidget {
  final ChallengeModel challenge;
  final bool isNewChallenge;
  final bool isTryAgain;
  final bool isSearchEdit;
  final bool isSearchNewChallenge;

  const EditChallengePage(
      {super.key,
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
  late String title =
      widget.isNewChallenge ? 'New Challenge' : 'Edit Challenge';

  late final _groupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context, listen: false);

  late final _tabProvider = Provider.of<TabProvider>(context, listen: false);

  late final ChallengeModel _editChallenge =
      widget.challenge.copy(isTryAgain: widget.isTryAgain, withId: true);

  late final _usersProvider =
      Provider.of<UsersProvider>(context, listen: false);

  bool isLoading = false;

  List<UserModel> _editParticipants = [];

  int? _selectedAttemptNumber;
  AttemptModel? _selectedAttempt;

  late bool _isUserAbleToEditChallenge;

  @override
  void initState() {
    super.initState();
    _setEditParticipants();
    _setIsUserAbleToEditChallenge();
    _setSelectedAttempt();
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
          appBar: AppBarComponent(title: title),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: [
                          _challengeOrAttemptDropdown(),
                          if (!_isUserAbleToEditChallenge &&
                              _selectedAttemptNumber == null)
                            _notAbleToEdit()
                          else ...[
                            _header(),
                            _details(),
                            _participants(),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              cancelAndSaveOrAcceptButton(),
            ],
          )),
    );
  }

  bool _setIsUserAbleToEditChallenge() {
    if (widget.challenge is GroupChallengeModel) {
      GroupChallengeModel groupChallenge =
          widget.challenge as GroupChallengeModel;
      _isUserAbleToEditChallenge =
          groupChallenge.userId == _usersProvider.user.id ||
              groupChallenge.groupChallengeOptions.isProgressIndividuell;
      return _isUserAbleToEditChallenge;
    }
    _isUserAbleToEditChallenge = true;
    return _isUserAbleToEditChallenge;
  }

  void _setEditParticipants() {
    if (widget.challenge is GroupChallengeModel &&
        (widget.challenge as GroupChallengeModel).participants.length > 1) {
      _editParticipants = (widget.challenge as GroupChallengeModel)
          .participants
          .map((participant) => participant.user)
          .toList();

      // Sort the list to put the current user first
      _editParticipants.sort((a, b) {
        if (a.id == _usersProvider.user.id) return -1;
        if (b.id == _usersProvider.user.id) return 1;
        return 0;
      });
    } else {
      _editParticipants = [_usersProvider.user];
    }
  }

  Visibility _participants() {
    return Visibility(
      visible: !isDescriptionExpanded && _selectedAttemptNumber == null,
      child: addOrEditParticipants(),
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

  _header() {
    return Visibility(
      visible: _selectedAttemptNumber == null && _isUserAbleToEditChallenge,
      child: Flexible(
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
                  children: [_thumbnailUploadAndTitle(), _description()],
                ),
              ),
            ),
            const SpaceComponent()
          ],
        ),
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
      child: _selectedAttempt == null
          ? StartAndEndDateComponent.challenge(
              editChallenge: _editChallenge,
              reloadParentPage: () => setState(
                () {},
              ),
            )
          : StartAndEndDateComponent.attempt(
              editAttempt: _selectedAttempt,
              groupChallenge: _editChallenge as GroupChallengeModel),
    );
  }

  _description() {
    EditDescriptionComponent descriptionComponent = EditDescriptionComponent(
      challenge: _editChallenge,
      isDescriptionExpanded: isDescriptionExpanded,
      onTap: () {
        setState(() {
          isDescriptionExpanded = !isDescriptionExpanded;
        });
      },
    );
    return isDescriptionExpanded
        ? Expanded(child: descriptionComponent)
        : descriptionComponent;
  }

  _thumbnailUploadAndTitle() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UploadThumbnailComponent(
              editChallenge: _editChallenge,
            ),
            const SpaceComponent(),
            ExpandedTextFieldComponent(
              editChallenge: _editChallenge,
            ),
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
    ChallengeModel challengeCopy = _editChallenge.copy();

    challengeCopy.id = await _groupChallengesProvider.create(challengeCopy,
        _editParticipants, _usersProvider.user, GroupChallengeOptionsModel());

    setState(() {
      isLoading = false;
    });

    // ignore: use_build_context_synchronously
    context.read<TabProvider>().selectTab(TabItemEnum.search);
    // ignore: use_build_context_synchronously
    context.read<TabProvider>().selectTab(TabItemEnum.home);

    var homeNavigator =
        _tabProvider.navigatorKeys[TabItemEnum.home]!.currentState!;

    homeNavigator.popUntil((route) => route.isFirst);

    homeNavigator.push(
      NoAnimationPageRouteComponent(
        builder: (context) => HomeChallengePage(
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
    if (_selectedAttempt == null) {
      GroupChallengeModel groupChallengeCopy =
          _editChallenge.copy(withId: true) as GroupChallengeModel;

      groupChallengeCopy.setGoals(_editChallenge.acceptanceCriteria.amount);

      await _groupChallengesProvider.update(groupChallengeCopy);
      await updateParticipants(groupChallengeCopy);
    } else {
      ParticipantModel participant = (_editChallenge as GroupChallengeModel)
          .getParticipant(_usersProvider.user.id);
      // _selectedAttempt!
      //     .changeRepetitionDates(_editChallenge as GroupChallengeModel);
      await _groupChallengesProvider.updateAttempt(
          _editChallenge as GroupChallengeModel,
          participant,
          _selectedAttempt!);
    }
    setState(() {
      isLoading = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  amountAndUnit() {
    return Visibility(
      visible: !isDescriptionExpanded && _selectedAttempt == null,
      child: SpaceColumnComponent(
        child: AmountAndUnitComponent(
          acceptanceCriteria: _editChallenge.acceptanceCriteria,
        ),
      ),
    );
  }

  frequency() {
    return Visibility(
      visible: !isDescriptionExpanded && _selectedAttempt == null,
      child: SpaceColumnComponent(
        child: FrequencyComponent(
          challenge: _editChallenge,
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

  addOrEditParticipants() {
    return _editParticipants.length <= 1
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
                    child: AddMemberOverviewComponent(
                        userId: _usersProvider.user.id,
                        members: _editParticipants)),
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
          participants: _editParticipants,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  _notAbleToEdit() {
    return const ListItemInfoComponent(
        text: 'Only the admin can edit the group challenge settings.');
  }

  updateParticipants(GroupChallengeModel groupChallengeCopy) async {
    Set<String> oldParticipantIds = groupChallengeCopy.participants
        .map((participant) => participant.user.id)
        .toSet();
    Set<String> editParticipantIds =
        _editParticipants.map((user) => user.id).toSet();

    List<UserModel> newParticipants = _editParticipants
        .where((user) => !oldParticipantIds.contains(user.id))
        .toList();
    List<UserModel> deleteParticipants = groupChallengeCopy.participants
        .where(
            (participant) => !editParticipantIds.contains(participant.user.id))
        .map((participant) => participant.user)
        .toList();

    for (var deleteParticipant in deleteParticipants) {
      await _groupChallengesProvider.deleteParticipant(groupChallengeCopy,
          participantId: deleteParticipant.id);
    }

    for (var newParticipant in newParticipants) {
      await _groupChallengesProvider.addParticipant(
          groupChallengeCopy, _usersProvider.user, newParticipant);
    }
  }

  _challengeOrAttemptDropdown() {
    if (_editChallenge is GroupChallengeModel) {
      try {
        ParticipantModel participant = (_editChallenge as GroupChallengeModel)
            .getParticipant(_usersProvider.user.id);

        return Visibility(
          visible: participant.attempts.isNotEmpty,
          child: SpaceColumnComponent(
            child: ListItemContainerComponent(
              padding: const EdgeInsets.all(CardComponent.standardPadding),
              isHeightDynamic: true,
              child: Column(
                children: [
                  CustomContainerComponent(
                    child: DropdownButton<int?>(
                      borderRadius: BorderRadius.circular(
                          CustomContainerComponent.standardRadius),
                      isExpanded: true,
                      underline: Container(),
                      value: _selectedAttemptNumber,
                      onChanged: (int? selectedAttemptNumber) {
                        setState(() {
                          _selectedAttemptNumber = selectedAttemptNumber;
                          _selectedAttempt = _selectedAttemptNumber == null
                              ? null
                              : participant.attempts.firstWhere((attempt) =>
                                  attempt.number == selectedAttemptNumber);
                        });
                      },
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: Text(
                            'Challenge',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        ...participant.attempts.map(
                          (attempt) {
                            return DropdownMenuItem<int>(
                              value: attempt.number,
                              child: Text(
                                'Attempt ${attempt.number}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } on Exception catch (_) {
        return const SizedBox();
      }
    }
    return const SizedBox();
  }

  void _setSelectedAttempt() {
    if (_isUserAbleToEditChallenge) {
      return;
    }

    if (_editChallenge is GroupChallengeModel) {
      _selectedAttempt = (_editChallenge as GroupChallengeModel)
          .getParticipant(_usersProvider.user.id)
          .getLatestAttempt();
      _selectedAttemptNumber = _selectedAttempt!.number;
    }
  }
}
