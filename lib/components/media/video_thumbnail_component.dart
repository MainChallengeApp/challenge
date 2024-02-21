import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnailComponent extends StatefulWidget {
  final String filePath;

  const VideoThumbnailComponent({Key? key, required this.filePath})
      : super(key: key);

  @override
  _VideoThumbnailComponentState createState() =>
      _VideoThumbnailComponentState();
}

class _VideoThumbnailComponentState extends State<VideoThumbnailComponent> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
    await _videoPlayerController.pause();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initVideoPlayer(),
      builder: (context, state) {
        if (state.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return VideoPlayer(_videoPlayerController);
        }
      },
    );
  }
}
