import 'package:challenge/components/navigation/custom_app_bar.dart';
import 'package:challenge/models/challenge.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class MediaDetail extends StatefulWidget {
  final String preTitle;
  final List<Media> media;
  final int initialMediaIdex;

  const MediaDetail(
      {super.key,
      required this.preTitle,
      required this.media,
      required this.initialMediaIdex});

  @override
  State<MediaDetail> createState() => _MediaDetailState();
}

class _MediaDetailState extends State<MediaDetail> {
  late PageController controller =
      PageController(initialPage: widget.initialMediaIdex);
  late String currentTitle = widget.media[widget.initialMediaIdex].title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomeAppBar.build(preTitle: widget.preTitle, title: currentTitle),
      backgroundColor: Colors.white,
      body: PageView(
        onPageChanged: onSwipeMedia,
        scrollDirection: Axis.vertical,
        controller: controller,
        children: widget.media.map((e) {
          return Center(
              child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(e.source,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Icon(Icons.question_mark, color: themeColor3),
                      ),
                    )),
          ));
        }).toList(),
      ),
    );
  }

  void onSwipeMedia(int value) {
    setState(() {
      currentTitle = widget.media[value].title;
    });
  }
}
