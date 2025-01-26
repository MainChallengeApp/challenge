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
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_child_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_text_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/app_icon_component.dart';
import 'package:challenge/ui/components/simple_components/image_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/home/home_challenge_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/add_participants_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_dates_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_description_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_frequency_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_goal_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_thumbnail_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_title_page.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
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

  // ignore: unused_field
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
      child: ScaffoldComponent(
          resizeToAvoidBottomInset: isDescriptionExpanded ? true : false,
          appBar: AppBarComponent(title: title),
          isBottomNavigationVisible: false,
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SpaceColumnComponent(
                        child: ListItemIconTextChildComponent(
                      onTap: _onTapThumbnail,
                      icon: IconEnum.picture.icon,
                      text: 'Thumbnail',
                      child: ImageInListItemComponent(
                        url: _editChallenge.thumbnail?.url ??
                            AppIconComponent.path,
                        scale: _editChallenge.thumbnail?.scale ??
                            AppIconComponent.scale,
                        fit: _editChallenge.thumbnail?.fit.fit,
                      ),
                    )),
                    SpaceColumnComponent(
                        child: ListItemIconTextTextComponent(
                            onTap: _onTapTitle,
                            icon: IconEnum.title.icon,
                            text: 'Title',
                            text2: _editChallenge.title)),
                    SpaceColumnComponent(
                        heightMultiplier: 2,
                        child: ListItemIconTextTextComponent(
                            onTap: _onTapDescription,
                            icon: IconEnum.description.icon,
                            text: 'Description',
                            text2: _editChallenge.description)),
                    SpaceColumnComponent(
                        child: ListItemIconTextTextComponent(
                            onTap: _onTapGoal,
                            icon: IconEnum.goal.icon,
                            text: 'Goal',
                            text2:
                                '${UtilService.doubleAsIntString(_editChallenge.acceptanceCriteria.amount)} ${_editChallenge.acceptanceCriteria.unit}')),
                    SpaceColumnComponent(
                        child: ListItemIconTextTextComponent(
                            onTap: _onTapRepetitions,
                            icon: IconEnum.repetition.icon,
                            text: 'Repetitions',
                            text2:
                                '${_editChallenge.frequency.amount ?? 'max.'} ${_editChallenge.frequency.typeToString()}')),
                    SpaceColumnComponent(
                        heightMultiplier: 2,
                        child: ListItemIconTextChildComponent(
                          onTap: _onTapDates,
                          padding: const EdgeInsets.symmetric(
                              horizontal:
                                  ListItemContainerComponent.standardPadding),
                          icon: IconEnum.dates.icon,
                          text: 'Dates',
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _getStartAndEndDateString(
                                    _editChallenge.startDate),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMediaNormalTertiary,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                _getStartAndEndDateString(
                                    _editChallenge.endDate),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMediaNormalTertiary,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        )),
                    SpaceColumnComponent(
                        child: ListItemIconTextTextComponent(
                      onTap: _onTapParticipants,
                      text: 'Participants',
                      icon: IconEnum.groupChallenge.icon,
                      text2:
                          '(${_editParticipants.length}) ${_editParticipants.map((user) => user.id == _usersProvider.user.id ? 'you' : user.username).join(', ')}',
                    )),
                  ],
                ),
              ),
              _cancelAndSaveOrAcceptButton(),
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

  _cancelAndSaveOrAcceptButton() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: Column(
        children: [
          const SpaceComponent(),
          SpaceColumnComponent(
            height: BottomNavigationComponent.standardMargin,
            child: Row(
              children: [
                const SpaceComponent(width: CardComponent.standardSideMargin),
                Expanded(
                  child: ListItemButtonComponent(
                    onTap: _onTapCancel,
                    isMainButton: false,
                    text: 'Cancel',
                    margin: EdgeInsets.zero,
                  ),
                ),
                const SpaceComponent(),
                widget.isSearchEdit ||
                        widget.isSearchNewChallenge ||
                        widget.isNewChallenge ||
                        widget.isTryAgain
                    ? Expanded(
                        child: ListItemButtonComponent(
                          onTap: _onTapAccept,
                          text: 'Accept',
                          isMainButton: true,
                          isLoading: isLoading,
                          margin: EdgeInsets.zero,
                        ),
                      )
                    : Expanded(
                        child: ListItemButtonComponent(
                          onTap: _onTapSave,
                          text: 'Save',
                          isMainButton: true,
                          isLoading: isLoading,
                          margin: EdgeInsets.zero,
                        ),
                      ),
                const SpaceComponent(width: CardComponent.standardSideMargin),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onTapCancel() {
    Navigator.pop(context);
  }

  void _onTapAccept() async {
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

  void _onTapSave() async {
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
      await _updateParticipants(groupChallengeCopy);
    } else {
      ParticipantModel participant = (_editChallenge as GroupChallengeModel)
          .getParticipant(_usersProvider.user.id);
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

  _updateParticipants(GroupChallengeModel groupChallengeCopy) async {
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

  _getStartAndEndDateString(DateTime? date) {
    bool dateWithTime = _editChallenge.startDate != null &&
            _editChallenge.startDate!
                    .difference(
                        UtilService.dateWithoutTime(_editChallenge.startDate!))
                    .inSeconds !=
                0 ||
        _editChallenge.endDate != null &&
            _editChallenge.endDate!
                    .difference(
                        UtilService.dateWithoutTime(_editChallenge.endDate!))
                    .inSeconds !=
                0;
    return '${UtilService.dateFormat(date)}${dateWithTime && date != null ? ',' : ''} ${dateWithTime ? UtilService.timeFormat(date) : ''}';
  }

  void _onTapTitle() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTitlePage(
          challenge: _editChallenge,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _onTapDescription() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDescriptionPage(
          challenge: _editChallenge,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _onTapGoal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditGoalPage(
          challenge: _editChallenge,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _onTapRepetitions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFrequencyPage(
          challenge: _editChallenge,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _onTapDates() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDatesPage(
          challenge: _editChallenge,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _onTapParticipants() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddParticipantsPage(
          participants: _editParticipants,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _onTapThumbnail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditThumbnailPage(
          challenge: _editChallenge,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }
}
