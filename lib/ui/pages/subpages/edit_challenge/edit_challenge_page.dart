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
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_dropdown.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_child_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_text_error_component.dart';
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

  const EditChallengePage({
    super.key,
    required this.challenge,
    this.isNewChallenge = false,
    this.isTryAgain = false,
  });

  @override
  State<EditChallengePage> createState() => _EditChallengePageState();
}

class _EditChallengePageState extends State<EditChallengePage> {
  late final _groupChallengesProvider = getIt<GroupChallengesProvider>();
  late final _usersProvider = getIt<UsersProvider>();
  late final _tabProvider = getIt<TabProvider>();

  late final ChallengeModel _editChallenge =
      widget.challenge.copy(isTryAgain: widget.isTryAgain, withId: true);

  List<UserModel> _editParticipants = [];
  AttemptModel? _selectedAttempt;

  bool _isScopeExpanded = false;
  bool _isUserAbleToEditChallenge = false;
  bool _isLoading = false;
  String? _titleErrorText;

  @override
  void initState() {
    super.initState();
    _setEditParticipants();
    _setIsUserAbleToEditChallenge();
    _setInitialSelectedAttempt();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          _isScopeExpanded = false;
        });
      },
      child: ScaffoldComponent(
          appBar: AppBarComponent(
              title:
                  widget.isNewChallenge ? 'New Challenge' : 'Edit Challenge'),
          isBottomNavigationVisible: false,
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _scope(),
                    _thumbnail(),
                    _title(),
                    _description(),
                    _goal(),
                    _repetitions(),
                    _dates(),
                    _participants(),
                  ],
                ),
              ),
              _cancelAndSaveOrAcceptButton(),
            ],
          )),
    );
  }

  Visibility _participants() {
    return Visibility(
      visible: _selectedAttempt == null,
      child: SpaceColumnComponent(
          child: ListItemIconTextTextComponent(
        isEnabled: _isUserAbleToEditChallenge,
        onTap: _onTapParticipants,
        text: 'Participants',
        icon: IconEnum.groupChallenge.icon,
        text2:
            '(${_editParticipants.length}) ${_editParticipants.map((user) => user.id == _usersProvider.user.id ? 'you' : user.username).join(', ')}',
      )),
    );
  }

  SpaceColumnComponent _dates() {
    return SpaceColumnComponent(
        heightMultiplier: 2,
        child: ListItemIconTextChildComponent(
          isEnabled: _isUserAbleToEditChallenge || _selectedAttempt != null,
          onTap: _onTapDates,
          padding: const EdgeInsets.symmetric(
              horizontal: ListItemContainerComponent.standardPadding),
          icon: IconEnum.dates.icon,
          text: 'Dates',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _getStartAndEndDateString(isStartDate: true),
                style: Theme.of(context).textTheme.titleMediaNormalTertiary,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _getStartAndEndDateString(isStartDate: false),
                style: Theme.of(context).textTheme.titleMediaNormalTertiary,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ));
  }

  Visibility _repetitions() {
    return Visibility(
      visible: _selectedAttempt == null,
      child: SpaceColumnComponent(
          child: ListItemIconTextTextComponent(
              isEnabled: _isUserAbleToEditChallenge,
              onTap: _onTapRepetitions,
              icon: IconEnum.repetition.icon,
              text: 'Repetitions',
              text2:
                  '${_editChallenge.frequency.amount ?? 'max.'} ${_editChallenge.frequency.typeToString()}')),
    );
  }

  Visibility _goal() {
    return Visibility(
      visible: _selectedAttempt == null,
      child: SpaceColumnComponent(
          child: ListItemIconTextTextComponent(
              isEnabled: _isUserAbleToEditChallenge,
              onTap: _onTapGoal,
              icon: IconEnum.goal.icon,
              text: 'Goal',
              text2:
                  '${UtilService.doubleAsIntString(_editChallenge.acceptanceCriteria.amount)} ${_editChallenge.acceptanceCriteria.unit}')),
    );
  }

  Visibility _description() {
    return Visibility(
      visible: _selectedAttempt == null,
      child: SpaceColumnComponent(
          heightMultiplier: 2,
          child: ListItemIconTextTextComponent(
              isEnabled: _isUserAbleToEditChallenge,
              onTap: _onTapDescription,
              icon: IconEnum.description.icon,
              text: 'Description',
              text2: _editChallenge.description)),
    );
  }

  Visibility _title() {
    return Visibility(
      visible: _selectedAttempt == null,
      child: SpaceColumnComponent(
          child: ListItemIconTextTextErrorComponent(
              isEnabled: _isUserAbleToEditChallenge,
              onTap: _onTapTitle,
              icon: IconEnum.title.icon,
              text: 'Title',
              errorText: _titleErrorText,
              text2: _editChallenge.title)),
    );
  }

  Visibility _thumbnail() {
    return Visibility(
      visible: _selectedAttempt == null,
      child: SpaceColumnComponent(
          child: ListItemIconTextChildComponent(
        isEnabled: _isUserAbleToEditChallenge,
        onTap: _onTapThumbnail,
        icon: IconEnum.picture.icon,
        text: 'Thumbnail',
        child: ImageInListItemComponent(
          url: _editChallenge.thumbnail?.url ?? AppIconComponent.path,
          scale: _editChallenge.thumbnail?.scale ?? AppIconComponent.scale,
          fit: _editChallenge.thumbnail?.fit.fit,
        ),
      )),
    );
  }

  StatelessWidget _scope() {
    return widget.isNewChallenge
        ? Container()
        : SpaceColumnComponent(
            heightMultiplier: 2,
            child: ListItemIconDropdown<AttemptModel?>(
                icon: IconEnum.settings.icon,
                isExpanded: _isScopeExpanded,
                initialEntry: _selectedAttempt,
                labelText: 'Scope',
                getText: (AttemptModel? attempt) =>
                    attempt != null ? 'Attempt ${attempt.number}' : 'Challenge',
                list: [
                  null,
                  ...(_editChallenge as GroupChallengeModel)
                      .getParticipant(_usersProvider.user.id)
                      .attempts
                ],
                onTapEntry: (attempt) => setState(() {
                      _selectedAttempt = attempt;
                    })),
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
    return Column(
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
              widget.isNewChallenge || widget.isTryAgain
                  ? Expanded(
                      child: ListItemButtonComponent(
                        onTap: _onTapAccept,
                        text: 'Accept',
                        isMainButton: true,
                        isLoading: _isLoading,
                        margin: EdgeInsets.zero,
                      ),
                    )
                  : Expanded(
                      child: ListItemButtonComponent(
                        onTap: _onTapSave,
                        text: 'Save',
                        isMainButton: true,
                        isLoading: _isLoading,
                        margin: EdgeInsets.zero,
                      ),
                    ),
              const SpaceComponent(width: CardComponent.standardSideMargin),
            ],
          ),
        ),
      ],
    );
  }

  void _onTapCancel() {
    Navigator.pop(context);
  }

  void _onTapAccept() async {
    if (_checkInputs() == false) {
      return;
    }

    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    ChallengeModel challengeCopy = _editChallenge.copy();

    challengeCopy.id = await _groupChallengesProvider.create(challengeCopy,
        _editParticipants, _usersProvider.user, GroupChallengeOptionsModel());

    setState(() {
      _isLoading = false;
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
    if (_checkInputs() == false) {
      return;
    }
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
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
      _isLoading = false;
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

  void _setInitialSelectedAttempt() {
    if (_isUserAbleToEditChallenge) {
      return;
    }

    if (_editChallenge is GroupChallengeModel) {
      _selectedAttempt = (_editChallenge as GroupChallengeModel)
          .getParticipant(_usersProvider.user.id)
          .getLatestAttempt();
    }
  }

  _getStartAndEndDateString({required bool isStartDate}) {
    DateTime? startDate = _selectedAttempt == null
        ? _editChallenge.startDate
        : _selectedAttempt!.startDate;
    DateTime? endDate = _selectedAttempt == null
        ? _editChallenge.endDate
        : _selectedAttempt!.endDate;

    bool dateWithTime = startDate != null &&
            startDate
                    .difference(UtilService.dateWithoutTime(startDate))
                    .inSeconds !=
                0 ||
        endDate != null &&
            endDate
                    .difference(UtilService.dateWithoutTime(endDate))
                    .inSeconds !=
                0;

    DateTime? date = isStartDate ? startDate : endDate;
    return '${UtilService.dateFormat(date)}${dateWithTime && (date) != null ? ',' : ''} ${dateWithTime ? UtilService.timeFormat(date) : ''}';
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
      setState(() {
        _titleErrorText = null;
      });
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
        builder: (context) {
          return _selectedAttempt == null
              ? EditDatesPage.challenge(
                  challenge: _editChallenge,
                )
              : EditDatesPage.attempt(
                  attempt: _selectedAttempt!,
                  groupChallenge: _editChallenge as GroupChallengeModel,
                );
        },
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

  _checkInputs() {
    if (_editChallenge.title.isEmpty) {
      setState(() {
        _titleErrorText = null;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _titleErrorText = 'Title is required';
          });
        }
      });
      return false;
    }
    return true;
  }
}
