import 'dart:io';

import 'package:challenge/pages/components/navigation/app_bar_component.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:flutter/material.dart';

import 'package:challenge/globals.dart';
import 'package:challenge/models/media_model.dart';

class ImagePage extends StatefulWidget {
  final String preTitle;
  final List<MediaModel> media;
  final int initialMediaIdex;
  final ChallengeModel challenge;

  const ImagePage(
      {super.key,
      required this.preTitle,
      required this.media,
      required this.initialMediaIdex,
      required this.challenge});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  late PageController controller =
      PageController(initialPage: widget.initialMediaIdex);
  late String currentTitle = widget.media[widget.initialMediaIdex].title;
  int currentMediaIndex = 0;

  @override
  void initState() {
    super.initState();
    currentMediaIndex = widget.initialMediaIdex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBarComponent(preTitle: widget.preTitle, titleText: currentTitle),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            onPageChanged: onSwipeMedia,
            scrollDirection: Axis.vertical,
            controller: controller,
            children: widget.media.map((e) {
              return Center(
                  child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(e.source,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  Icon(Icons.question_mark, color: themeColor3),
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
      currentTitle = widget.media[value].title;
      currentMediaIndex = value;
    });
  }

  deleteButton() {
    return GestureDetector(
      onTap: () {
        MediaModel media = widget.media[currentMediaIndex];

        File file = File(media.source);
        file.exists().then((value) {
          if (value) {
            file.delete();
          }
        });

        widget.media.removeWhere((element) => element.id == media.id);
        widget.challenge.media.removeWhere((element) => element.id == media.id);
        for (var acceptanceCriteria in widget.challenge.acceptanceCriterias) {
          for (var repetition in acceptanceCriteria.repetitions) {
            for (var p in repetition.progressList) {
              p.mediaIds.removeWhere((mediaId) => mediaId == media.id);
            }
          }
        }

        allChallengesList
            .firstWhere((element) => element.id == widget.challenge.id)
            .media
            .removeWhere((element) => element.id == media.id);

        ChallengeController challengeController = ChallengeController();
        challengeController.writeFile(context, allChallengesList);

        setState(() {
          if (currentMediaIndex >= widget.media.length) {
            currentMediaIndex = widget.media.length - 1;
          }
        });
        if (widget.media.isEmpty) {
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
        child: const Center(child: Icon(Icons.delete)),
      ),
    );
  }
}
