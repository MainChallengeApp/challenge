import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoComponent extends StatefulWidget {
  final String filePath;

  const VideoComponent({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoComponentState createState() => _VideoComponentState();
}

class _VideoComponentState extends State<VideoComponent> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
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
