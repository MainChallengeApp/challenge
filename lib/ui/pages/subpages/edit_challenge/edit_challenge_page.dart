import 'dart:developer';

import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_options_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/challenge/reminder_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/error_text_service.dart';
import 'package:challenge/services/local_push_notification_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_dropdown.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_child_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_text_error_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/app_icon_component.dart';
import 'package:challenge/ui/components/simple_components/bottom_buttons_component.dart';
import 'package:challenge/ui/components/simple_components/image_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/dialogs/error_occurred_dialog.dart';
import 'package:challenge/ui/pages/home/home_challenge_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_dates_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_description_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_frequency_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_goal_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_participants_page.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_reminder_page.dart';
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
  final _groupChallengesProvider = getIt<GroupChallengesProvider>();
  final _usersProvider = getIt<UsersProvider>();
  final _tabProvider = getIt<TabProvider>();
  final _localPushNotificationService = LocalPushNotificationService();

  late final ChallengeModel _editChallenge =
      widget.challenge.copy(isTryAgain: widget.isTryAgain, withId: true);

  List<UserModel> _editParticipants = [];
  AttemptModel? _selectedAttempt;
  late final ParticipantModel _participant = _getParticipant();

  bool _isScopeExpanded = false;
  bool _isUserAbleToEditChallenge = false;
  bool _isLoading = false;

  String? _tempTitleErrorText;
  final String _titleErrorTextKey = 'title';
  late final Map<String, String?> _errorTexts = {
    _titleErrorTextKey: null,
  };

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
            title: widget.isNewChallenge ? 'New Challenge' : 'Edit Challenge',
          ),
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
                    _reminder(),
                    _participants(),
                  ],
                ),
              ),
              const SpaceComponent(),
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

  _reminder() {
    ReminderModel? reminder = _participant.reminder;

    return Visibility(
      visible: _selectedAttempt == null,
      child: SpaceColumnComponent(
          heightMultiplier: 2,
          child: ListItemIconTextTextComponent(
              onTap: _onTapReminder,
              icon: IconEnum.notification.icon,
              text: 'Daily Reminder',
              text2: reminder == null || !reminder.isActive
                  ? 'Off'
                  : reminder.timeToString())),
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
              errorText: _errorTexts[_titleErrorTextKey],
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
    return BottomButtonsComponent(buttons: [
      ListItemButtonComponent(
        onTap: _onTapCancel,
        isMainButton: false,
        text: 'Cancel',
        margin: EdgeInsets.zero,
      ),
      widget.isNewChallenge || widget.isTryAgain
          ? ListItemButtonComponent(
              onTap: _onTapAccept,
              text: 'Accept',
              isMainButton: _areInputsCorrect(),
              isLoading: _isLoading,
              margin: EdgeInsets.zero,
            )
          : ListItemButtonComponent(
              onTap: _onTapSave,
              text: 'Save',
              isMainButton: _areInputsCorrect(),
              isLoading: _isLoading,
              margin: EdgeInsets.zero,
            ),
    ]);
  }

  void _onTapCancel() {
    Navigator.pop(context);
  }

  void _onTapAccept() async {
    if (_showErrorTexts() == true) {
      return;
    }

    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    ChallengeModel challengeCopy = _editChallenge.copy();
    try {
      challengeCopy.id = await _groupChallengesProvider.create(
          challenge: challengeCopy,
          participantUsers: _editParticipants,
          currentUser: _usersProvider.user,
          groupChallengeOptions: GroupChallengeOptionsModel(),
          reminder: _participant.reminder);

      if (_participant.reminder != null && _participant.reminder!.isActive) {
        await _localPushNotificationService.setUpChallengeReminder(
            challengeTitle: challengeCopy.title,
            reminder: _participant.reminder!);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        ErrorOccurredDialog.show(
            errorText: 'Error while creating challenge', context: context);
      });
      log(e.toString());
      return;
    }

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
    if (_showErrorTexts() == true) {
      return;
    }
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    if (_selectedAttempt == null) {
      if (_isUserAbleToEditChallenge) {
        GroupChallengeModel groupChallengeCopy =
            _editChallenge.copy(withId: true) as GroupChallengeModel;

        groupChallengeCopy.setGoals(_editChallenge.acceptanceCriteria.amount);

        await _groupChallengesProvider.update(groupChallengeCopy);
        await _updateParticipants(groupChallengeCopy);
      }
      await _groupChallengesProvider.updateParticipant(
          _editChallenge as GroupChallengeModel, _participant);
    } else {
      ParticipantModel participant = (_editChallenge as GroupChallengeModel)
          .getParticipant(_usersProvider.user.id);
      await _groupChallengesProvider.updateAttempt(
          _editChallenge as GroupChallengeModel,
          participant,
          _selectedAttempt!);
    }
    if (_participant.reminder != null) {
      if (_participant.reminder!.isActive) {
        await _localPushNotificationService.setUpChallengeReminder(
            challengeTitle: _editChallenge.title,
            reminder: _participant.reminder!);
      } else {
        await _localPushNotificationService
            .cancelNotificationById(_participant.reminder!.id);
      }
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
    if (_editChallenge is GroupChallengeModel) {
      _selectedAttempt = (_editChallenge as GroupChallengeModel)
          .getParticipant(_usersProvider.user.id)
          .getLatestAttempt();
    }
  }

  _getStartAndEndDateString({required bool isStartDate}) {
    DateTime? startDate = _selectedAttempt == null
        ? _editChallenge.startDate
        : _selectedAttempt!.getStartDate(_editChallenge as GroupChallengeModel);
    DateTime? endDate = _selectedAttempt == null
        ? _editChallenge.endDate
        : _selectedAttempt!.getEndDate(_editChallenge as GroupChallengeModel);

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
    return '${UtilService.dateFormat(date)} ${dateWithTime ? UtilService.timeFormat(date) : ''}';
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
        _errorTexts[_titleErrorTextKey] = null;
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

  void _onTapReminder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditReminderPage(
          participant: _participant,
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
        builder: (context) => EditParticipantsPage(
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

  bool _areInputsCorrect() {
    _tempTitleErrorText = null;
    if (_editChallenge.title.isEmpty) {
      _tempTitleErrorText = 'Title is required';
    }
    return _tempTitleErrorText == null;
  }

  _showErrorTexts() {
    if (_areInputsCorrect()) {
      return false;
    }
    ErrorTextService.showErrorText(
        setState, _errorTexts, _titleErrorTextKey, _tempTitleErrorText);
    return true;
  }

  ParticipantModel _getParticipant() {
    return widget.challenge is GroupChallengeModel
        ? (_editChallenge as GroupChallengeModel)
            .getParticipant(_usersProvider.user.id)
        : ParticipantModel.empty();
  }
}
