import 'package:challenge/components/navigation/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../models/media.dart';

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
                child: Image.asset(e.source,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                Icon(Icons.question_mark, color: themeColor3),
                          ),
                        )),
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
    });
  }

  deleteButton() {
    return GestureDetector(
      onTap: () {},
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
