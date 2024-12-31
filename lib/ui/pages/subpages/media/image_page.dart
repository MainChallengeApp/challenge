import 'dart:io';

import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImagePage extends StatefulWidget {
  final List<MediaModel> mediaList;
  final int initialMediaIndex;
  final AttemptModel attempt;
  final GroupChallengeModel groupChallenge;
  final ParticipantModel participant;

  const ImagePage(
      {super.key,
      required this.mediaList,
      required this.initialMediaIndex,
      required this.attempt,
      required this.groupChallenge,
      required this.participant});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  late PageController controller =
      PageController(initialPage: widget.initialMediaIndex);
  late String currentTitle = widget.mediaList[widget.initialMediaIndex].title;
  late int currentMediaIndex = widget.initialMediaIndex;

  late final groupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
      appBar: AppBarComponent(title: currentTitle),
      isBottomNavigationVisible: false,
      body: Stack(
        children: [
          PageView(
            onPageChanged: onSwipeMedia,
            scrollDirection: Axis.vertical,
            controller: controller,
            children: widget.mediaList.map((media) {
              return Center(
                  child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(media.source,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: Icon(Icons.question_mark,
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                            ),
                          )),
                ),
              ));
            }).toList(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: deleteButton(),
          )
        ],
      ),
    );
  }

  void onSwipeMedia(int value) {
    setState(() {
      currentTitle = widget.mediaList[value].title;
      currentMediaIndex = value;
    });
  }

  deleteButton() {
    return GestureDetector(
      onTap: () {
        MediaModel media = widget.mediaList[currentMediaIndex];

        File file = File(media.source);
        file.exists().then((value) {
          if (value) {
            file.delete();
          }
        });

        widget.mediaList.removeWhere((element) => element.id == media.id);
        widget.attempt.removeMedia(media);

        groupChallengesProvider.updateAttempt(
            widget.groupChallenge, widget.participant, widget.attempt);

        setState(() {
          if (currentMediaIndex >= widget.mediaList.length) {
            currentMediaIndex = widget.mediaList.length - 1;
          }
        });
        if (widget.mediaList.isEmpty) {
          Navigator.pop(context);
        }
      },
      child: Container(
        width: 55,
        height: 55,
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Center(
            child: Icon(
          IconEnum.delete.icon,
          color: Theme.of(context).colorScheme.red,
        )),
      ),
    );
  }
}
