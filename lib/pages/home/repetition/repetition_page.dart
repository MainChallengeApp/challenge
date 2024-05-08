import 'dart:math';
import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/repetition_model.dart';
import 'package:challenge/pages/components/list_items/list_item_button_component.dart';
import 'package:challenge/pages/components/list_items/list_item_icon_small_component.dart';
import 'package:challenge/pages/components/list_items/list_item_progress_component.dart';
import 'package:challenge/pages/components/list_items/list_item_repetition_component.dart';
import 'package:challenge/pages/components/list_items/list_item_repetition_expanded_component.dart';
import 'package:challenge/pages/components/navigation/app_bar_component.dart';
import 'package:challenge/pages/components/simple_components/space_column_component.dart';
import 'package:challenge/pages/components/simple_components/space_component.dart';
import 'package:challenge/services/challenge_service.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:provider/provider.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/progress_model.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:challenge/pages/components/navigation/no_animation_page_route_component.dart';
import 'progress_media_list_page.dart';

class RepetitionPage extends StatefulWidget {
  final String preTitle;
  final ChallengeModel challenge;

  const RepetitionPage(
      {super.key, required this.preTitle, required this.challenge});

  @override
  State<RepetitionPage> createState() => _RepetitionPageState();
}

class _RepetitionPageState extends State<RepetitionPage> {
  ScrollController scrollController = ScrollController();
  late final AcceptanceCriteriaModel acceptanceCriteria =
      widget.challenge.acceptanceCriteria;

  late final expandedRepetitionIndexList = [
    widget.challenge.getCurrentRepetitionNumber()
  ];

  ChallengeService challengeService = ChallengeService();

  @override
  void initState() {
    super.initState();
    setIsBottomNavBarVisibleToFalse();
    Future.delayed(Duration.zero, () {
      List<String> preTitleArray = widget.preTitle.split('/');
      if (preTitleArray.length >= 3 && preTitleArray.contains('Repetitions')) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent(
          preTitle: widget.preTitle,
          titleText: 'Repetitions',
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _buildList(),
          ],
        ));
  }

  Widget _buildList() {
    return RawScrollbar(
      controller: scrollController,
      radius: const Radius.circular(4),
      thumbColor: themeColor3,
      padding: const EdgeInsets.only(right: 4),
      child: ListView.builder(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: max(1, widget.challenge.getCurrentRepetitionNumber()),
          itemBuilder: (BuildContext content, int index) {
            if (widget.challenge.isInBacklog()) {
              return ListItemButtonComponent(
                onTap: onTapStartChallenge,
                text: "Start Challenge",
                isMainButton: true,
              );
            }

            widget.challenge.setRepetitionsEndDate();
            RepetitionModel repetition;
            if ((widget.challenge.getCurrentRepetitionNumber() - 1 - index) <
                    widget.challenge.repetitions.length &&
                (widget.challenge.getCurrentRepetitionNumber() - 1 - index) >=
                    0) {
              repetition = widget.challenge.getAllRepetitions()[
                  widget.challenge.getCurrentRepetitionNumber() - 1 - index];
              repetition.evaluateRepetitionStatus();
            } else {
              repetition = widget.challenge.addRepetition();
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
          child: ListItemIconSmallComponent(
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
            isFailed:
                repetition.repetitionStatus == RepetitionStatusEnum.failed,
            onTap: () => onTapProgress(progress),
            isSlidable: true,
            onTapDeleteProgress: () => onTapDeleteProgress(
                repetition, repetition.progressList.indexOf(progress)),
            progress: progress,
            challenge: widget.challenge,
            unit: acceptanceCriteria.unit,
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
          height: isRepetitionExpanded ? null : 16,
          child: Column(
            children: [
              isRepetitionExpanded
                  ? ListItemRepetitionExpandedComponent(
                      onTap: () => onTapRepetition(repetition),
                      repetition: repetition,
                      challenge: widget.challenge,
                      setStateRepetitionPage: () => setState(() {}),
                      addToExpandedRepetition: (int repetitionNumber) {
                        setState(() {
                          expandedRepetitionIndexList.clear();
                          expandedRepetitionIndexList.add(repetitionNumber);
                        });
                      },
                    )
                  : ListItemRepetitionComponent(
                      onTap: () => onTapRepetition(repetition),
                      repetition: repetition,
                      challenge: widget.challenge,
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
              color: themeColor2,
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
          initialMediaList: widget.challenge.media
              .where((element) => progress.mediaIds.contains(element.id))
              .toList(),
          challenge: widget.challenge,
          repetition:
              widget.challenge.repetitions[progress.repetitionNumber - 1],
          progress: progress,
          isSaveInsteadOfEditButtonVisible: false,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void setIsBottomNavBarVisibleToFalse() {
    Future.delayed(Duration.zero, () {
      setState(() {
        context.read<DesignProvider>().setIsBottomNavBarVisible(false);
      });
    });
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
    context.read<DesignProvider>().setIsBottomNavBarVisible(false);
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => ProgressMediaListPage(
          preTitle:
              '${widget.preTitle}/Repetitions/${repetition.repetitionNumber}',
          repetition: repetition,
          challenge: widget.challenge,
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

  void onTapStartChallenge() {
    setState(() {
      challengeService.startChallenge(widget.challenge);
    });
  }

  onTapDeleteProgress(RepetitionModel repetition, int progressIndex) {
    setState(() {
      challengeService.deleteProgress(
          widget.challenge, repetition, progressIndex);
    });
  }
}
