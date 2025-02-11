import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/challenge/progress_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_info_component.dart';
import 'package:challenge/ui/components/list_items/list_item_participant_expanded_component.dart';
import 'package:challenge/ui/components/list_items/list_item_progress_component.dart';
import 'package:challenge/ui/components/list_items/list_item_repetition_component.dart';
import 'package:challenge/ui/components/list_items/list_item_repetition_expanded_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/link_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/dialogs/delete_attempt_dialog.dart';
import 'package:challenge/ui/dialogs/end_challenge_dialog.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'progress_media_list_page.dart';

class RepetitionPage extends StatefulWidget {
  final AttemptModel attempt;
  final GroupChallengeModel groupChallenge;
  final ParticipantModel participant;

  const RepetitionPage(
      {super.key,
      required this.attempt,
      required this.groupChallenge,
      required this.participant});

  @override
  State<RepetitionPage> createState() => _RepetitionPageState();
}

class _RepetitionPageState extends State<RepetitionPage> {
  final String _title = 'Repetitions';
  ScrollController scrollController = ScrollController();

  late var expandedRepetitionIndexList = [
    if (_attempt.isInProgress(widget.groupChallenge))
      _attempt.getCurrentRepetitionNumber(widget.groupChallenge)
  ];

  late final _groupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context, listen: false);

  late final _listeningGroupChallengeProvider =
      Provider.of<GroupChallengesProvider>(context, listen: true);

  late final _usersProvider =
      Provider.of<UsersProvider>(context, listen: false);

  final mediaService = MediaService();

  late final bool _isEditableByUser =
      widget.participant.user.id == _usersProvider.user.id;

  late GroupChallengeModel _groupChallenge = widget.groupChallenge;
  late ParticipantModel _participant = widget.participant;
  late AttemptModel _attempt = widget.attempt;

  late bool _isChallengeNotStarted =
      _attempt.getAllRepetitions(_groupChallenge).isEmpty && !_isEditableByUser;
  bool _isActionButtonLoading = false;

  List<RepetitionModel> _visibleRepetitions = [];

  @override
  initState() {
    super.initState();
    _groupChallengesProvider.getById(widget.groupChallenge.id).then((value) {
      if (mounted) {
        _groupChallenge = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _groupChallenge = _listeningGroupChallengeProvider.groupChallenges
        .firstWhere((groupChallenge) => groupChallenge.id == _groupChallenge.id,
            orElse: () => _groupChallenge);

    _participant = _groupChallenge.participants.firstWhere(
        (participant) => participant.user.id == widget.participant.user.id,
        orElse: () => widget.participant);

    _attempt = _participant.attempts.firstWhere(
        (attempt) => attempt.number == _attempt.number,
        orElse: () => widget.attempt);

    _visibleRepetitions = calcVisibleRepetitions();

    _isChallengeNotStarted =
        _attempt.getAllRepetitions(_groupChallenge).isEmpty &&
            !_isEditableByUser;

    return ScaffoldComponent(
        appBar: AppBarComponent(
          title: _title,
        ),
        isBottomNavigationVisible: false,
        body: Column(
          children: [
            _buildList(),
            _isEditableByUser ? actionButton() : Container()
          ],
        ));
  }

  Widget _buildList() {
    return Expanded(
      child: RefreshIndicatorComponent(
        onRefresh: () async {
          _groupChallenge =
              await _groupChallengesProvider.getById(_groupChallenge.id);
          setState(() {});
        },
        scrollController: scrollController,
        child: CupertinoScrollbar(
          controller: scrollController,
          child: ListView.builder(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _calcItemCount(),
              itemBuilder: (BuildContext content, int index) {
                if (index == 0) {
                  return _listItemParticipantExpanded();
                }

                if (_isChallengeNotStarted) {
                  return _userDidNotStartChallenge();
                }

                return _listItemRepetition(index);
              }),
        ),
      ),
    );
  }

  _listItemRepetition(int index) {
    int newIndex = index - 1;
    RepetitionModel repetition = _visibleRepetitions[newIndex];
    repetition.evaluateRepetitionStatus();
    return repetitionListItem(repetition);
  }

  SpaceColumnComponent _listItemParticipantExpanded() {
    return SpaceColumnComponent(
      child: ListItemParticipantExpandedComponent(
        groupChallenge: _groupChallenge,
        participant: _participant,
        attempt: _attempt,
        isEditableByUser: _isEditableByUser,
        reloadSearchChallengePage: (AttemptModel attempt) => setState(() {
          _attempt = attempt;
          expandedRepetitionIndexList = [
            _attempt.getCurrentRepetitionNumber(widget.groupChallenge)
          ];
        }),
      ),
    );
  }

  int _calcItemCount() {
    return 1 + // +1 for participant list item
        (_isChallengeNotStarted ? 1 : _visibleRepetitions.length);
  }

  List<Widget> progressList(RepetitionModel repetition) {
    var progressListItems = (_attempt.isInProgress(widget.groupChallenge) ||
                _attempt.isInBacklog(widget.groupChallenge)) &&
            _isEditableByUser
        ? <Widget>[
            LinkListItemComponent(
                child: ListItemIconTextComponent(
              icon: Icons.add_rounded,
              title: 'New Progress',
              onTap: () => onTapNewProgress(repetition),
            ))
          ]
        : List<Widget>.empty(growable: true);
    for (var progress in repetition.progressList.reversed) {
      progressListItems.add(LinkListItemComponent(
          child: ListItemProgressComponent(
        isFailed: repetition.repetitionStatus == RepetitionStatusEnum.failed,
        onTap: () => onTapProgress(repetition, progress),
        isSlidable: _isEditableByUser,
        onTapDeleteProgress: () => onTapDeleteProgress(repetition, progress),
        progress: progress,
        attempt: _attempt,
        groupChallenge: _groupChallenge,
        unit: _attempt.getAcceptanceCriteria(_groupChallenge).unit,
      )));
    }
    progressListItems.add(const SpaceComponent(
      heightMultiplier: 2,
    ));
    return progressListItems;
  }

  repetitionListItem(RepetitionModel repetition) {
    bool isRepetitionExpanded =
        expandedRepetitionIndexList.contains(repetition.repetitionNumber);

    Column item = Column(
      children: [
        isRepetitionExpanded
            ? ListItemRepetitionExpandedComponent(
                onTap: () => onTapRepetition(repetition),
                repetition: repetition,
                attempt: _attempt,
                groupChallenge: _groupChallenge,
                participant: _participant,
                isEditableByUser: _isEditableByUser,
                onTapNextRepetition: (int repetitionNumber) {
                  setState(() {
                    expandedRepetitionIndexList = [repetitionNumber];
                  });
                },
              )
            : SpaceColumnComponent(
                child: ListItemRepetitionComponent(
                  onTap: () => onTapRepetition(repetition),
                  repetition: repetition,
                  attempt: _attempt,
                  groupChallenge: _groupChallenge,
                ),
              )
      ],
    );

    if (isRepetitionExpanded) {
      item.children.addAll(progressList(repetition));
    }

    return item;
  }

  onTapProgress(RepetitionModel repetition, ProgressModel progress) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProgressMediaListPage(
          initialMediaList: _attempt.media
              .where((element) => progress.mediaIds.contains(element.id))
              .toList(),
          attempt: _attempt,
          groupChallenge: _groupChallenge,
          participant: _participant,
          repetition: repetition,
          progress: progress,
          isSaveInsteadOfEditButtonVisible: false,
          isEditableByUser: _isEditableByUser,
          amountOfPops: 0,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  String splitTitle(String title) {
    // Find the index of the last '/' in the string
    int lastIndex = title.lastIndexOf('/');

    if (lastIndex != -1 && lastIndex > 0) {
      // Extract the portion of the string up to the last '/'
      String result = title.substring(0, lastIndex);
      return result;
    } else {
      return title;
    }
  }

  void onTapNewProgress(RepetitionModel repetition) async {
    // ignore: use_build_context_synchronously
    var initialMediaList = List<MediaModel>.empty(growable: true);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProgressMediaListPage(
          repetition: repetition,
          initialMediaList: initialMediaList,
          attempt: _attempt,
          groupChallenge: _groupChallenge,
          participant: _participant,
          isSaveInsteadOfEditButtonVisible: true,
          isEditableByUser: _isEditableByUser,
        ),
      ),
    ).then((_) => setState(() {
          // context.read<DesignProvider>().setIsBottomNavBarVisible(true);
        }));
  }

  onTapRepetition(RepetitionModel repetition) {
    setState(() {
      // expandedRepetitionIndexList.clear();
      if (expandedRepetitionIndexList.contains(repetition.repetitionNumber)) {
        expandedRepetitionIndexList
            .removeWhere((value) => value == repetition.repetitionNumber);
      } else {
        expandedRepetitionIndexList.add(repetition.repetitionNumber);
      }
    });
  }

  onTapDeleteProgress(RepetitionModel repetition, ProgressModel progress) {
    mediaService.deleteMediaInChallengeByIds(
        MediaModel.copyMediaIdList(progress.mediaIds), _attempt);
    setState(() {
      repetition.deleteProgress(progress);
    });
    _attempt.replaceRepetition(repetition);
    _groupChallengesProvider.updateAttempt(
        _groupChallenge, _participant, _attempt);
  }

  actionButton() {
    void onTapStartChallenge() async {
      setState(() {
        _isActionButtonLoading = true;
      });
      await _groupChallengesProvider.startAttemptOrChallenge(
          _groupChallenge, _participant, _attempt);
      setState(() {
        _isActionButtonLoading = false;
        expandedRepetitionIndexList = [
          _attempt.getCurrentRepetitionNumber(widget.groupChallenge)
        ];
      });
    }

    void onTapEndChallenge() {
      EndChallengeDialog.show(
          context: context,
          challengeTitle: _groupChallenge.title,
          onTapYes: () {
            _groupChallengesProvider.endAttempt(
                _groupChallenge, _participant, _attempt);
            setState(() {
              expandedRepetitionIndexList = [];
            });
          });
    }

    void onTapDeleteAttempt() async {
      DeleteAttemptDialog.show(
          context: context,
          onTapYes: () async {
            await _groupChallengesProvider.deleteAttempt(
                _groupChallenge, _participant, _attempt);
            setState(() {
              _attempt = _participant.getLatestAttempt();
            });
          });
    }

    void onTapTryAgain() async {
      setState(() {
        _isActionButtonLoading = true;
      });
      AttemptModel? addedAttempt = await _groupChallengesProvider.tryAgain(
          _groupChallenge, _participant);
      if (addedAttempt != null) {
        _attempt = addedAttempt;
      }
      setState(() {
        _isActionButtonLoading = false;
      });
    }

    ListItemButtonComponent deleteAttemptButton = ListItemButtonComponent(
      onTap: onTapDeleteAttempt,
      text: 'Delete Attempt',
      textColor: Theme.of(context).colorScheme.red,
      isMainButton: false,
      margin: EdgeInsets.zero,
    );

    return Padding(
      padding: const EdgeInsets.only(
          bottom: BottomNavigationComponent.standardMargin,
          top: SpaceComponent.standardHeight),
      child: _attempt.isInBacklog(widget.groupChallenge)
          ? Row(
              children: [
                const SpaceComponent(
                  width: ListItemContainerComponent.standardMargin,
                ),
                Visibility(
                    visible: _participant.attempts.length > 1,
                    child: Expanded(child: deleteAttemptButton)),
                Visibility(
                    visible: _participant.attempts.length > 1,
                    child: const SpaceComponent(
                      width: ListItemContainerComponent.standardMargin,
                    )),
                Expanded(
                  child: ListItemButtonComponent(
                    onTap: onTapStartChallenge,
                    text: 'Start',
                    isLoading: _isActionButtonLoading,
                    margin: EdgeInsets.zero,
                    isMainButton: _groupChallenge.startDate == null ||
                        _groupChallenge.startDate!.isBefore(TimeService.now()),
                  ),
                ),
                const SpaceComponent(
                  width: ListItemContainerComponent.standardMargin,
                ),
              ],
            )
          : _attempt.isInProgress(widget.groupChallenge)
              ? ListItemButtonComponent(
                  onTap: onTapEndChallenge,
                  text: 'End',
                  isLoading: _isActionButtonLoading,
                  isMainButton: _attempt.isCompleted(_groupChallenge),
                )
              : _attempt.number == _participant.getLatestAttempt().number &&
                      (_attempt.isFailed(widget.groupChallenge) ||
                          _attempt.isSucceeded(widget.groupChallenge))
                  ? Row(
                      children: [
                        const SpaceComponent(
                          width: ListItemContainerComponent.standardMargin,
                        ),
                        Visibility(
                            visible: _participant.attempts.length > 1,
                            child: Expanded(child: deleteAttemptButton)),
                        Visibility(
                            visible: _participant.attempts.length > 1,
                            child: const SpaceComponent(
                              width: ListItemContainerComponent.standardMargin,
                            )),
                        Expanded(
                          child: ListItemButtonComponent(
                            onTap: onTapTryAgain,
                            text: _attempt.isFailed(widget.groupChallenge)
                                ? 'Try Again'
                                : 'Accept Again',
                            isLoading: _isActionButtonLoading,
                            margin: EdgeInsets.zero,
                          ),
                        ),
                        const SpaceComponent(
                          width: ListItemContainerComponent.standardMargin,
                        ),
                      ],
                    )
                  : ListItemButtonComponent(
                      onTap: onTapDeleteAttempt,
                      text: 'Delete Attempt',
                      textColor: Theme.of(context).colorScheme.red,
                      isMainButton: false,
                    ),
    );
  }

  _userDidNotStartChallenge() {
    return SpaceColumnComponent(
      child: ListItemInfoComponent(
          text:
              '${_participant.user.username} did not ${_participant.isAccepted() ? 'start this attempt yet.' : 'accept the challenge yet.'}'),
    );
  }

  List<RepetitionModel> calcVisibleRepetitions() {
    int currentRepetitionNumber =
        _attempt.getCurrentRepetitionNumber(_groupChallenge);
    List<RepetitionModel> visibleRepetitions = _attempt
        .getAllRepetitions(_groupChallenge)
        .where((repetitionEntry) =>
            repetitionEntry.repetitionNumber <= currentRepetitionNumber)
        .toList();
    visibleRepetitions
        .sort((a, b) => b.repetitionNumber.compareTo(a.repetitionNumber));
    return visibleRepetitions;
  }
}
