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
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_info_component.dart';
import 'package:challenge/ui/components/list_items/list_item_participant_component.dart';
import 'package:challenge/ui/components/list_items/list_item_progress_component.dart';
import 'package:challenge/ui/components/list_items/list_item_repetition_component.dart';
import 'package:challenge/ui/components/list_items/list_item_repetition_expanded_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/dialogs/end_challenge_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'progress_media_list_page.dart';

class RepetitionPage extends StatefulWidget {
  final String preTitle;
  final AttemptModel attempt;
  final GroupChallengeModel groupChallenge;
  final ParticipantModel participant;

  const RepetitionPage(
      {super.key,
      required this.preTitle,
      required this.attempt,
      required this.groupChallenge,
      required this.participant});

  @override
  State<RepetitionPage> createState() => _RepetitionPageState();
}

class _RepetitionPageState extends State<RepetitionPage> {
  ScrollController scrollController = ScrollController();

  late final expandedRepetitionIndexList = [
    widget.attempt.getCurrentRepetitionNumber(widget.groupChallenge)
  ];

  late final groupChallengeProvider =
      Provider.of<GroupChallengesProvider>(context, listen: false);

  late final listeningGroupChallengeProvider =
      Provider.of<GroupChallengesProvider>(context, listen: true);

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  final mediaService = MediaService();

  late bool isEditableByUser =
      widget.participant.user.id == usersProvider.user.id;

  late GroupChallengeModel groupChallenge = widget.groupChallenge;
  late ParticipantModel _participant = widget.participant;
  late AttemptModel _attempt = widget.attempt;

  @override
  Widget build(BuildContext context) {
    _participant = groupChallenge.participants.firstWhere(
        (participant) => participant.user.id == widget.participant.user.id,
        orElse: () => widget.participant);
    _attempt = _participant.getLatestAttempt();

    return Scaffold(
        appBar: AppBarComponent(
          preTitle: widget.preTitle,
          titleText: 'Repetitions',
        ),
        backgroundColor: Colors.white,
        body: _attempt.getAllRepetitions(groupChallenge).isEmpty &&
                !isEditableByUser
            ? _userDidNotStartChallenge()
            : Column(
                children: [
                  _buildList(),
                  !(_attempt.isFailed() || _attempt.isSucceeded()) &&
                          isEditableByUser
                      ? actionButton()
                      : Container()
                ],
              ));
  }

  Widget _buildList() {
    return Expanded(
      child: RefreshIndicatorComponent(
        onRefresh: () async {
          groupChallenge =
              await groupChallengeProvider.getById(groupChallenge.id);
          setState(() {});
        },
        scrollController: scrollController,
        child: RawScrollbar(
          controller: scrollController,
          radius: const Radius.circular(4),
          thumbColor: Theme.of(context).colorScheme.tertiary,
          padding: const EdgeInsets.only(right: 4),
          child: ListView.builder(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _attempt.getCurrentRepetitionNumber(groupChallenge) +
                  1, // +1 for participant
              itemBuilder: (BuildContext content, int index) {
                if (index == 0) {
                  return SpaceColumnComponent(
                    child: ListItemParticipantComponent(
                      participant: _participant,
                      groupChallenge: groupChallenge,
                      position:
                          groupChallenge.getPositionOf(_participant.user.id),
                      onTap: () => {},
                    ),
                  );
                }
                int newIndex = index - 1;
                RepetitionModel repetition;
                int repetitionIndex =
                    _attempt.getCurrentRepetitionNumber(groupChallenge) -
                        1 -
                        newIndex;
                if (repetitionIndex < _attempt.repetitions.length &&
                    repetitionIndex >= 0) {
                  repetition = _attempt
                      .getAllRepetitions(groupChallenge)[repetitionIndex];
                  repetition.evaluateRepetitionStatus();
                } else {
                  repetition = _attempt.addRepetition(groupChallenge);
                }
                repetition.evaluateRepetitionStatus();
                return repetitionListItem(repetition);
              }),
        ),
      ),
    );
  }

  List<SpaceColumnComponent> progressList(RepetitionModel repetition) {
    var progressListItems = !(_attempt.isFailed() || _attempt.isSucceeded()) &&
            isEditableByUser
        ? [
            SpaceColumnComponent(
                heightMultiplier: repetition.progressList.isEmpty ? 4 : null,
                child: ListItemIconTextComponent(
                  margin: const EdgeInsets.only(left: 30, right: 20),
                  icon: Icons.add_rounded,
                  title: 'New Progress',
                  onTap: () => onTapNewProgress(repetition),
                ))
          ]
        : List<SpaceColumnComponent>.empty(growable: true);
    for (var progress in repetition.progressList.reversed) {
      progressListItems.add(SpaceColumnComponent(
          heightMultiplier:
              progress == repetition.progressList.first ? 5 : null,
          child: ListItemProgressComponent(
            margin: const EdgeInsets.only(left: 30, right: 20),
            isFailed:
                repetition.repetitionStatus == RepetitionStatusEnum.failed,
            onTap: () => onTapProgress(progress),
            isSlidable: isEditableByUser,
            onTapDeleteProgress: () =>
                onTapDeleteProgress(repetition, progress),
            progress: progress,
            attempt: _attempt,
            groupChallenge: groupChallenge,
            unit: _attempt.getAcceptanceCriteria(groupChallenge).unit,
          )));
    }
    return progressListItems;
  }

  repetitionListItem(RepetitionModel repetition) {
    bool isRepetitionExpanded =
        expandedRepetitionIndexList.contains(repetition.repetitionNumber);

    Column item = Column(
      children: <SpaceColumnComponent>[
        SpaceColumnComponent(
          child: Column(
            children: [
              isRepetitionExpanded
                  ? ListItemRepetitionExpandedComponent(
                      onTap: () => onTapRepetition(repetition),
                      repetition: repetition,
                      attempt: _attempt,
                      groupChallenge: groupChallenge,
                      participant: _participant,
                      isEditableByUser: isEditableByUser,
                      onTapNextRepetition: (int repetitionNumber) {
                        setState(() {
                          expandedRepetitionIndexList.clear();
                          expandedRepetitionIndexList.add(repetitionNumber);
                        });
                      },
                    )
                  : ListItemRepetitionComponent(
                      onTap: () => onTapRepetition(repetition),
                      repetition: repetition,
                      attempt: _attempt,
                      groupChallenge: groupChallenge,
                    ),
            ],
          ),
        )
      ],
    );

    if (isRepetitionExpanded) {
      item.children.addAll(progressList(repetition));
    }

    return item;
  }

  button() {
    return GestureDetector(
      onTap: () {},
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 55,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: const Center(
              child: Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          )),
        ),
      ),
    );
  }

  onTapProgress(ProgressModel progress) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => ProgressMediaListPage(
          preTitle:
              '${widget.preTitle}/Repetitions/${progress.repetitionNumber}',
          initialMediaList: _attempt.media
              .where((element) => progress.mediaIds.contains(element.id))
              .toList(),
          attempt: _attempt,
          groupChallenge: groupChallenge,
          participant: _participant,
          repetition: _attempt.repetitions[progress.repetitionNumber - 1],
          progress: progress,
          isSaveInsteadOfEditButtonVisible: false,
          isEditableByUser: isEditableByUser,
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
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => ProgressMediaListPage(
          preTitle:
              '${widget.preTitle}/Repetitions/${repetition.repetitionNumber}',
          repetition: repetition,
          initialMediaList: List.empty(growable: true),
          attempt: _attempt,
          groupChallenge: groupChallenge,
          participant: _participant,
          isSaveInsteadOfEditButtonVisible: true,
          isEditableByUser: isEditableByUser,
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
    groupChallengeProvider.updateAttempt(
        groupChallenge, _participant, _attempt);
  }

  actionButton() {
    void onTapStartChallenge() {
      groupChallengeProvider.startAttemptOrChallenge(
          groupChallenge, _participant, _attempt, context);
      setState(() {});
    }

    void onTapEndChallenge() {
      EndChallengeDialog.show(
          context: context,
          challengeTitle: groupChallenge.title,
          onTapYes: () {
            groupChallengeProvider.endAttempt(
                groupChallenge, _participant, _attempt);
            setState(() {});
          });
    }

    return Align(
        alignment: _attempt.isInBacklog()
            ? Alignment.topCenter
            : Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _attempt.isInBacklog()
              ? ListItemButtonComponent(
                  onTap: onTapStartChallenge,
                  text: 'Start Challenge',
                  isMainButton: true,
                )
              : ListItemButtonComponent(
                  onTap: onTapEndChallenge,
                  text: 'End Challenge',
                  isMainButton: _attempt.isCompleted(groupChallenge),
                ),
        ));
  }

  _userDidNotStartChallenge() {
    return RefreshIndicatorComponent(
      scrollController: scrollController,
      onRefresh: () async {
        groupChallenge =
            await groupChallengeProvider.getById(groupChallenge.id);
        setState(() {});
      },
      child: ListView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ListItemInfoComponent(
              text:
                  '${_participant.user.username} did not ${_participant.isAccepted() ? 'start' : 'accept'} the challenge yet.'),
        ],
      ),
    );
  }
}
