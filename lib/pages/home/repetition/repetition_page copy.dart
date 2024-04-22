import 'dart:math';

import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/models/repetition_model.dart';
import 'package:challenge/pages/components/list_items/list_item_button_component.dart';
import 'package:challenge/pages/components/list_items/list_item_icon_small_component.dart';
import 'package:challenge/pages/components/list_items/list_item_progress_component.dart';
import 'package:challenge/pages/components/list_items/list_item_repetition_component.dart';
import 'package:challenge/pages/components/navigation/app_bar_component.dart';
import 'package:challenge/pages/components/simple_components/space_column_component.dart';
import 'package:challenge/pages/components/simple_components/space_component.dart';
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

  ChallengeController challengeController = ChallengeController();

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
          reverse: false,
          shrinkWrap: true,
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

            RepetitionModel repetition;
            if ((widget.challenge.getCurrentRepetitionNumber() - 1 - index) <
                    widget.challenge.repetitions.length &&
                (widget.challenge.getCurrentRepetitionNumber() - 1 - index) >=
                    0) {
              repetition = widget.challenge.repetitions.reversed.toList()[
                  widget.challenge.getCurrentRepetitionNumber() - 1 - index];
              repetition.evaluateRepetitionStatus(widget.challenge);
            } else {
              repetition = widget.challenge.addRepetition();
            }
            return repetitionListItem(repetition);
          }),
    );
  }

  progressList(RepetitionModel repetition, bool isRepetitionExpanded) {
    var progressListItems = ListView(
        children: repetition.progressList.map(
      (progress) {
        return Column(
          children: [
            isRepetitionExpanded ? line() : const SpaceComponent(),
            ListItemProgressComponent(
              isFailed:
                  repetition.repetitionStatus == RepetitionStatusEnum.failed,
              progress: progress,
              challenge: widget.challenge,
              unit: acceptanceCriteria.unit,
              onTap: () => onTapProgress(progress),
            ),
          ],
        );
      },
    ).toList()

        // .(Column(
        //   children: [
        // isRepetitionExpanded ? line() : const SpaceComponent(),
        //     ListItemIconSmallComponent(
        //       icon: Icons.add_rounded,
        //       title: 'New Progress',
        //       onTap: () => onTapNewProgress(repetition),
        //     ),
        //   ],
        // )),
        );

    // for (var progress in repetition.progressList.reversed) {
    //   progressListItems. .add(Column(
    //     children: [
    // isRepetitionExpanded && progress != repetition.progressList.first
    //     ? line()
    //     : const SpaceComponent(),
    // ListItemProgressComponent(
    //   isFailed:
    //       repetition.repetitionStatus == RepetitionStatusEnum.failed,
    //   progress: progress,
    //   challenge: widget.challenge,
    //   unit: acceptanceCriteria.unit,
    // ),
    //     ],
    //   ));
    // }
    return progressListItems;
  }

  repetitionListItem(RepetitionModel repetition) {
    bool isRepetitionExpanded =
        expandedRepetitionIndexList.contains(repetition.repetitionNumber);

    ListView item = ListView.builder(
      reverse: true,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount:
          isRepetitionExpanded ? repetition.progressList.length * 2 + 2 : 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return const SpaceComponent();
        }

        if (index == 1 && !isRepetitionExpanded) {
          return ListItemRepetitionComponent(
            repetition: repetition,
            challenge: widget.challenge,
            onTap: () => onTapRepetition(repetition),
          );
        }

        if ((index - 1) ~/ 2 >= repetition.progressList.length) {
          return ListItemRepetitionComponent(
            repetition: repetition,
            challenge: widget.challenge,
            onTap: () => onTapRepetition(repetition),
          );
        }

        if (index % 2 == 1) {
          return ListItemProgressComponent(
              progress: repetition.progressList.elementAt((index - 1) ~/ 2),
              unit: widget.challenge.acceptanceCriteria.unit,
              challenge: widget.challenge,
              isFailed: repetition.isFailed(widget.challenge));
        }

        if (index % 2 == 0) {
          return line();
        }

        return const SpaceComponent();
      },
    );

    // if (isRepetitionExpanded) {
    //   item. children.add(progressList(repetition, isRepetitionExpanded));
    // }

    return item;
  }

  Center line() {
    return Center(
      child: Container(
        width: 4,
        height: 16,
        color: themeColor5,
      ),
    );
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
            challenge: widget.challenge),
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
      widget.challenge.start();
    });
    challengeController.writeFile(allChallengesList);
  }
}
