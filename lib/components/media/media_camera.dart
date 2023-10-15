import 'dart:io';

import 'package:camera/camera.dart';
import 'package:challenge/components/media/acceptance_criteria_data_list.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge.dart';
import 'package:flutter/material.dart';

import '../navigation/custom_app_bar.dart';

class MediaCamera extends StatefulWidget {
  const MediaCamera({
    super.key,
    required this.camera,
    required this.preTitle,
    required this.mediaList,
  });

  final CameraDescription camera;
  final String preTitle;
  final List<Media> mediaList;

  @override
  State<MediaCamera> createState() => _CameraStateMedia();
}

class _CameraStateMedia extends State<MediaCamera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  FlashMode flashMode = FlashMode.off;
  List<Media> currentMedia = [];

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.height / size.width;
    // Fill this out in the next steps.
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return Stack(children: [
            Transform.scale(
              scale: deviceRatio,
              child: Center(
                child: CameraPreview(_controller),
              ),
            ),
            CustomeAppBar.build(
                preTitle: widget.preTitle,
                title: 'Camera',
                backgroundColor: Colors.transparent,
                textColor: Colors.white),
            Align(
              alignment: Alignment.bottomCenter,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  child: flashButton(),
                ),
                const SizedBox(
                  width: 50,
                ),
                Container(
                  child: documentationButton(Icons.camera_alt_outlined),
                ),
                const SizedBox(
                  width: 50,
                ),
                Container(
                  child: acceptButton(),
                )
              ]),
            )
          ]);
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  documentationButton(IconData iconData) {
    return GestureDetector(
      onTap: () async {
        // Take the Picture in a try / catch block. If anything goes wrong,
        // catch the error.
        try {
          // Ensure that the camera is initialized.
          await _initializeControllerFuture;

          // Attempt to take a picture and get the file `image`
          // where it was saved.
          final image = await _controller.takePicture();

          if (!mounted) return;
          setState(() {
            widget.mediaList.add(Media(
                type: 'image',
                title: DateTime.now().toString(),
                source: image.path));

            currentMedia.add(Media(
                type: 'image',
                title: DateTime.now().toString(),
                source: image.path));
          });

          // // If the picture was taken, display it on a new screen.
          // await Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => DisplayPictureScreen(
          //       // Pass the automatically generated path to
          //       // the DisplayPictureScreen widget.
          //       imagePath: image.path,
          //     ),
          //   ),
          // );
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
      },
      child: Container(
        width: 55,
        height: 55,
        margin: const EdgeInsets.only(bottom: 50),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Center(child: Icon(iconData)),
      ),
    );
  }

  flashButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (flashMode == FlashMode.off) {
            _controller.setFlashMode(FlashMode.torch);
            flashMode = FlashMode.torch;
          } else if (flashMode == FlashMode.torch) {
            _controller.setFlashMode(FlashMode.off);
            flashMode = FlashMode.off;
          } else {
            _controller.setFlashMode(FlashMode.off);
            flashMode = FlashMode.off;
          }
        });
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(bottom: 50),
        decoration: BoxDecoration(
            color: flashMode == FlashMode.off ? Colors.white : themeColor1,
            border: Border.all(width: 1, color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Center(
            child: Icon(
          Icons.flashlight_on_outlined,
          color: flashMode == FlashMode.off ? Colors.black : Colors.white,
        )),
      ),
    );
  }

  acceptButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) => AcceptanceCriteriaDataList(preTitle: widget.preTitle, mediaList: currentMedia),
      ),
    ).then((_) => setState(() {}));
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(bottom: 50),
        decoration: BoxDecoration(
            image: currentMedia.isNotEmpty ? DecorationImage(
              image: AssetImage(currentMedia.last.source),
              fit: BoxFit.cover,
            ) : null,
            color: flashMode == FlashMode.off
                ? Colors.white.withAlpha(100)
                : themeColor1,
            border: Border.all(width: 1, color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Center(
            child: Icon(
          Icons.chevron_right,
          color: flashMode == FlashMode.off ? Colors.white : Colors.white,
        )),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
