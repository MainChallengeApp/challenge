import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/challenge/acceptance_criteria_component.dart';
import 'package:challenge/ui/components/challenge/action_button_component.dart';
import 'package:challenge/ui/components/challenge/attempt_start_and_end_date_component.dart';
import 'package:challenge/ui/components/challenge/description_component.dart';
import 'package:challenge/ui/components/challenge/documentation_button_component.dart';
import 'package:challenge/ui/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/ui/components/challenge/title_with_percentage_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/slider_component.dart';
import 'package:challenge/ui/components/simple_components/snack_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
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

class GroupChallengeCardComponent extends StatefulWidget {
  final GroupChallengeModel groupChallenge;

  const GroupChallengeCardComponent({super.key, required this.groupChallenge});

  @override
  State<GroupChallengeCardComponent> createState() =>
      _GroupChallengeCardComponentState();
}

class _GroupChallengeCardComponentState
    extends State<GroupChallengeCardComponent> {
  // providers
  late final _usersProvider =
      Provider.of<UsersProvider>(context, listen: false);

  late final _groupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context, listen: false);

  // state variables
  late ParticipantModel _participant =
      widget.groupChallenge.getParticipant(_usersProvider.user.id);
  late AttemptModel _latestAttempt = _participant.getLatestAttempt();

  late GroupChallengeModel _groupChallenge = widget.groupChallenge;

  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    _groupChallenge = _groupChallengesProvider.groupChallenges.firstWhere(
        (element) => element.id == widget.groupChallenge.id,
        orElse: () => widget.groupChallenge);
    _participant = _groupChallenge.getParticipant(_usersProvider.user.id);
    _latestAttempt = _participant.getLatestAttempt();
    return Slidable(
      closeOnScroll: true,
      key: ObjectKey(_groupChallenge),
      endActionPane: _endActionPane(),
      child: Builder(builder: (context) {
        return CardComponent(
          children: [
            _thumbnail(),
            _title(),
            _description(),
            _startAndEndDate(),
            _acceptanceCriteria(),
            _expandedSpace(),
            _documentationButtons(),
            _actionButton()
          ],
        );
      }),
    );
  }

  _endActionPane() {
    return ActionPane(
      extentRatio: (_groupChallenge.isEditable()) ? 0.5 : 0.25,
      motion: const ScrollMotion(),
      children: [
        _editSlider(),
        _separator(),
        _deleteSlider(),
        const SpaceComponent(
          width: BottomNavigationComponent.standardMargin,
        ),
      ],
    );
  }

  _editSlider() {
    return Visibility(
      visible: _groupChallenge.isEditable(),
      child: SliderComponent(
          icon: IconEnum.edit.icon,
          foregroundColor: Theme.of(context).colorScheme.tertiary,
          label: 'Edit',
          onTap: _onTapEditChallenge),
    );
  }

  _separator() {
    return SpaceComponent(
      width: BottomNavigationComponent.standardMargin,
      isVisible: _groupChallenge.isEditable(),
    );
  }

  _deleteSlider() {
    return SliderComponent(
        icon: IconEnum.delete.icon,
        label: 'Delete',
        foregroundColor: Theme.of(context).colorScheme.red,
        duration: Durations.short1,
        onTap: _onTapDeleteChallenge);
  }

  _thumbnail() {
    return SpaceColumnComponent(
      height: 11,
      child: ThumbnailMaxComponent(
        challenge: _groupChallenge,
        onTapOpenMediaPage: _onTapOpenMediaPage,
        attempt: _latestAttempt,
      ),
    );
  }

  _title() {
    return SpaceColumnComponent(
      height: 11,
      child: TitleWithPercentageComponent(
        groupChallenge: _groupChallenge,
        participant: _participant,
        attempt: _latestAttempt,
      ),
    );
  }

  _description() {
    DescriptionComponent descriptionComponent = DescriptionComponent(
      challenge: _groupChallenge,
      isDescriptionExpanded: _isDescriptionExpanded,
      onTap: () => setState(() {
        _isDescriptionExpanded = !_isDescriptionExpanded;
      }),
    );
    return _isDescriptionExpanded
        ? Expanded(
            child: Column(
            children: [
              Expanded(child: descriptionComponent),
              _groupChallenge.description.isNotEmpty
                  ? const SpaceComponent()
                  : Container()
            ],
          ))
        : Column(
            children: [
              descriptionComponent,
              _groupChallenge.description.isNotEmpty
                  ? const SpaceComponent()
                  : Container()
            ],
          );
  }

  _startAndEndDate() {
    return _isDescriptionExpanded
        ? Container()
        : SpaceColumnComponent(
            child: AttemptStartAndEndDateComponent(
              attempt: _latestAttempt,
              groupChallenge: _groupChallenge,
              isLocked: true,
            ),
          );
  }

  _acceptanceCriteria() {
    return _isDescriptionExpanded
        ? Container()
        : AcceptanceCriteriaComponent(
            onTap: _onTapAcceptanceCriteria,
            onTapNewProgress: _onTapNewProgress,
            attempt: _latestAttempt,
            groupChallenge: _groupChallenge,
          );
  }

  _expandedSpace() {
    return _isDescriptionExpanded ? Container() : Expanded(child: Container());
  }

  _documentationButtons() {
    return Visibility(
      visible: !_isDescriptionExpanded && _latestAttempt.isInProgress(),
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
                iconData: IconEnum.camera.icon, onTap: _onTapCamera),
          ],
        ),
      ),
    );
  }

  _actionButton() {
    return ActionButtonComponent(
      groupChallenge: _groupChallenge,
      attempt: _latestAttempt,
      onTapStart: _onTapStart,
      onTapEnd: _onTapEnd,
      onTapAgain: _onTapAgain,
      onTapNext: _onTapNext,
    );
  }

  Future<void> _onTapStart(AttemptModel attempt) async {
    RepetitionModel? currentRepetition =
        attempt.getCurrentRepetition(widget.groupChallenge);
    if (currentRepetition != null) {
      currentRepetition.start();
      await _groupChallengesProvider.updateAttempt(
          _groupChallenge, _participant, attempt);
      return;
    }

    await _groupChallengesProvider.startAttemptOrChallenge(
        _groupChallenge, _participant, attempt, context);
  }

  Future<void> _onTapEnd(AttemptModel attempt) async {
    if (attempt.canEndRepetition(_groupChallenge)) {
      attempt.endRepetition(_groupChallenge);
      await _groupChallengesProvider.updateAttempt(
          _groupChallenge, _participant, attempt);
      return;
    }

    EndChallengeDialog.show(
        // ignore: use_build_context_synchronously
        context: context,
        challengeTitle: _groupChallenge.title,
        onTapYes: () {
          _groupChallengesProvider.endAttempt(
              _groupChallenge, _participant, attempt);
        });
  }

  Future<void> _onTapAgain() async {
    await _groupChallengesProvider.tryAgain(
        _groupChallenge, _participant, context);
  }

  void _onTapNext(AttemptModel attempt) async {
    attempt.endRepetition(_groupChallenge);
    _groupChallengesProvider.updateAttempt(
        _groupChallenge, _participant, attempt);
  }

  void _onTapOpenMediaPage() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => MediaListPage(
          attempt: _latestAttempt,
          groupChallenge: _groupChallenge,
          participant: _participant,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void _onTapEditChallenge() {
    if (_groupChallenge.isEditable()) {
      // currentChallengeIndex = widget.challenges.indexOf(challenge);
      Navigator.push(
        context,
        NoAnimationPageRouteComponent(
          builder: (context) => EditChallengePage(
            challenge: _groupChallenge,
          ),
        ),
      ).then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  void _onTapDeleteChallenge() async {
    DeleteChallengeDialog.show(
        context: context,
        challengeTitle: _groupChallenge.title,
        onTapYes: () async {
          await _groupChallengesProvider.deleteParticipant(_groupChallenge);
        });
  }

  _onTapAcceptanceCriteria() {
    if (_groupChallenge.isGroupChallenge()) {
      Navigator.push(
          context,
          NoAnimationPageRouteComponent(
              builder: (context) => RepetitionPage(
                    groupChallenge: _groupChallenge,
                    participant: _participant,
                    attempt: _latestAttempt,
                  ))).then((_) {
        if (mounted) {
          setState(() {});
        }
      });
      return;
    }
    if (_latestAttempt.getFrequency(_groupChallenge).amount != null &&
        _latestAttempt.getFrequency(_groupChallenge).amount! <= 0) {
      return;
    }
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => RepetitionPage(
          groupChallenge: _groupChallenge,
          participant: _participant,
          attempt: _latestAttempt,
        ),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _onTapNewProgress() async {
    if (_latestAttempt.getCurrentRepetition(_groupChallenge) == null) {
      return;
    }

    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => ProgressMediaListPage(
          repetition: _latestAttempt.getCurrentRepetition(_groupChallenge)!,
          initialMediaList: List.empty(growable: true),
          attempt: _latestAttempt,
          groupChallenge: _groupChallenge,
          participant: _participant,
          isEditableByUser: _participant.user.id == _usersProvider.user.id,
          isSaveInsteadOfEditButtonVisible: true,
        ),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _onTapCamera() async {
    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => MediaCameraPage(
          mediaList: _latestAttempt.media,
          attempt: _latestAttempt,
          groupChallenge: _groupChallenge,
          participant: _participant,
        ),
      ),
    );
  }
}
