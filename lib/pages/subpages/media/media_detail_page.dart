import 'dart:io';

import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/pages/components/navigation/app_bar_component.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/pages/subpages/media/video_component.dart';
import 'package:flutter/material.dart';

import 'package:challenge/globals.dart';
import 'package:challenge/models/media_model.dart';

class MediaDetailPage extends StatefulWidget {
  final String preTitle;
  final List<MediaModel> mediaList;
  final int initialMediaIdex;
  final ChallengeModel challenge;

  const MediaDetailPage(
      {super.key,
      required this.preTitle,
      required this.mediaList,
      required this.initialMediaIdex,
      required this.challenge});

  @override
  State<MediaDetailPage> createState() => _MediaDetailPageState();
}

class _MediaDetailPageState extends State<MediaDetailPage> {
  late PageController controller =
      PageController(initialPage: widget.initialMediaIdex);
  late String currentTitle = widget.mediaList[widget.initialMediaIdex].title;
  late int currentMediaIndex = widget.initialMediaIdex;

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
            children: widget.mediaList.reversed.map((media) {
              return media.type == MediaTypeEnum.image
                  ? Center(
                      child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(media.source,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Icon(Icons.question_mark,
                                        color: themeColor3),
                                  ),
                                )),
                      ),
                    ))
                  : Center(
                      child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: VideoComponent(
                          filePath: media.source,
                        ),
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
        widget.challenge.media.removeWhere((element) => element.id == media.id);
        for (var repetition in widget.challenge.repetitions) {
          for (var progress in repetition.progressList) {
            progress.mediaIds.removeWhere((mediaId) => mediaId == media.id);
          }
        }

        allChallengesList
            .firstWhere((element) => element.id == widget.challenge.id)
            .media
            .removeWhere((element) => element.id == media.id);

        ChallengeController challengeController = ChallengeController();
        challengeController.writeFile(allChallengesList);

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
          color: red,
        )),
      ),
    );
  }
}
