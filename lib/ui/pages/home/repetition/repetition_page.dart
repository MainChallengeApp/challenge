import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/progress_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_progress_component.dart';
import 'package:challenge/ui/components/list_items/list_item_repetition_component.dart';
import 'package:challenge/ui/components/list_items/list_item_repetition_expanded_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/dialogs/end_challenge_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'progress_media_list_page.dart';

class RepetitionPage extends StatefulWidget {
  final String preTitle;
  final UserChallengeModel userChallenge;

  const RepetitionPage(
      {super.key, required this.preTitle, required this.userChallenge});

  @override
  State<RepetitionPage> createState() => _RepetitionPageState();
}

class _RepetitionPageState extends State<RepetitionPage> {
  ScrollController scrollController = ScrollController();

  late final expandedRepetitionIndexList = [
    widget.userChallenge.getCurrentRepetitionNumber()
  ];

  late final userChallengesProvider =
      Provider.of<UserChallengesProvider>(context, listen: false);

  late final listeningProvider =
      Provider.of<UserChallengesProvider>(context, listen: true);

  final mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    listeningProvider.userChallenges;

    return Scaffold(
        appBar: AppBarComponent(
          preTitle: widget.preTitle,
          titleText: 'Repetitions',
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _buildList(),
            !(widget.userChallenge.isFailed() ||
                    widget.userChallenge.isSucceeded())
                ? actionButton()
                : Container()
          ],
        ));
  }

  Widget _buildList() {
    return RawScrollbar(
      controller: scrollController,
      radius: const Radius.circular(4),
      thumbColor: Theme.of(context).colorScheme.tertiary,
      padding: const EdgeInsets.only(right: 4),
      child: ListView.builder(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: widget.userChallenge.getCurrentRepetitionNumber(),
          itemBuilder: (BuildContext content, int index) {
            RepetitionModel repetition;
            if ((widget.userChallenge.getCurrentRepetitionNumber() -
                        1 -
                        index) <
                    widget.userChallenge.repetitions.length &&
                (widget.userChallenge.getCurrentRepetitionNumber() -
                        1 -
                        index) >=
                    0) {
              repetition = widget.userChallenge.getAllRepetitions()[
                  widget.userChallenge.getCurrentRepetitionNumber() -
                      1 -
                      index];
              repetition.evaluateRepetitionStatus();
            } else {
              repetition = widget.userChallenge.addRepetition();
            }
            repetition.evaluateRepetitionStatus();
            return repetitionListItem(repetition);
          }),
    );
  }

  List<SpaceColumnComponent> progressList(RepetitionModel repetition) {
    var progressListItems = [
      SpaceColumnComponent(
          height: repetition.progressList.isEmpty
              ? SpaceComponent.staticHeight * 4
              : null,
          child: ListItemIconTextComponent(
            margin: const EdgeInsets.only(left: 30, right: 20),
            icon: Icons.add_rounded,
            title: 'New Progress',
            onTap: () => onTapNewProgress(repetition),
          ))
    ];
    for (var progress in repetition.progressList.reversed) {
      progressListItems.add(SpaceColumnComponent(
          height: progress == repetition.progressList.first
              ? SpaceComponent.staticHeight * 5
              : null,
          child: ListItemProgressComponent(
            margin: const EdgeInsets.only(left: 30, right: 20),
            isFailed:
                repetition.repetitionStatus == RepetitionStatusEnum.failed,
            onTap: () => onTapProgress(progress),
            isSlidable: true,
            onTapDeleteProgress: () =>
                onTapDeleteProgress(repetition, progress),
            progress: progress,
            challenge: widget.userChallenge,
            unit: widget.userChallenge.acceptanceCriteria.unit,
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
          height: isRepetitionExpanded ? null : SpaceComponent.staticHeight,
          child: Column(
            children: [
              isRepetitionExpanded
                  ? ListItemRepetitionExpandedComponent(
                      onTap: () => onTapRepetition(repetition),
                      repetition: repetition,
                      userChallenge: widget.userChallenge,
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
                      challenge: widget.userChallenge,
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
          initialMediaList: widget.userChallenge.media
              .where((element) => progress.mediaIds.contains(element.id))
              .toList(),
          userChallenge: widget.userChallenge,
          repetition:
              widget.userChallenge.repetitions[progress.repetitionNumber - 1],
          progress: progress,
          isSaveInsteadOfEditButtonVisible: false,
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
          userChallenge: widget.userChallenge,
          isSaveInsteadOfEditButtonVisible: true,
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
        MediaModel.copyMediaIdList(progress.mediaIds), widget.userChallenge);
    setState(() {
      repetition.deleteProgress(progress);
    });
    userChallengesProvider.update(widget.userChallenge);
  }

  actionButton() {
    void onTapStartChallenge() {
      userChallengesProvider.start(widget.userChallenge);
    }

    void onTapEndChallenge() {
      EndChallengeDialog.show(
          context: context,
          onTapYes: () {
            userChallengesProvider.end(widget.userChallenge);
          });
    }

    return Align(
        alignment: widget.userChallenge.isInBacklog()
            ? Alignment.topCenter
            : Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: widget.userChallenge.isInBacklog()
              ? ListItemButtonComponent(
                  onTap: onTapStartChallenge,
                  text: 'Start Challenge',
                  isMainButton: true,
                )
              : ListItemButtonComponent(
                  onTap: onTapEndChallenge,
                  text: 'End Challenge',
                  isMainButton: widget.userChallenge.isCompleted(),
                ),
        ));
  }
}
