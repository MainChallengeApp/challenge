import 'dart:io';

import 'package:camera/camera.dart';
import 'package:challenge/components/media/acceptance_criteria_media_list.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/acceptance_criteria.dart';
import '../../models/media.dart';
import '../navigation/custom_app_bar.dart';
import '../navigation/no_animation_page_route.dart';

class MediaCamera extends StatefulWidget {
  const MediaCamera({
    super.key,
    required this.cameras,
    required this.preTitle,
    required this.mediaList,
    required this.acceptanceCriteria,
    required this.challenge,
  });

  final List<CameraDescription> cameras;
  final String preTitle;
  final List<Media> mediaList;
  final AcceptanceCriteria acceptanceCriteria;
  final Challenge challenge;

  @override
  State<MediaCamera> createState() => _CameraStateMedia();
}

class _CameraStateMedia extends State<MediaCamera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  FlashMode flashMode = FlashMode.off;
  List<Media> currentMedia = [];
  CameraDescription? currentCamera;

  var isCameraFeedback = false;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    if (widget.cameras.isNotEmpty) {
      currentCamera = widget.cameras[0];
      _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        currentCamera!,
        // Define the resolution to use.
        ResolutionPreset.max,
      );
      // Next, initialize the controller. This returns a Future.
      _initializeControllerFuture = _controller.initialize();
      _initializeControllerFuture.then((value) => _controller
          .getMinZoomLevel()
          .then((value) => _controller.setZoomLevel(1)));
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomeAppBar.build(
          preTitle: widget.preTitle,
          title: 'Camera',
          backgroundColor: Colors.white,
          textColor: Colors.black),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return currentCamera != null
                ? GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        if (widget.cameras.length >= 2 &&
                            currentCamera == widget.cameras[0]) {
                          currentCamera = widget.cameras[1];
                          _controller = CameraController(
                            // Get a specific camera from the list of available cameras.
                            currentCamera!,
                            // Define the resolution to use.
                            ResolutionPreset.max,
                          );

                          // Next, initialize the controller. This returns a Future.
                          _initializeControllerFuture =
                              _controller.initialize();
                        } else if (widget.cameras.length >= 2 &&
                            currentCamera == widget.cameras[1]) {
                          currentCamera = widget.cameras[0];
                          _controller = CameraController(
                            // Get a specific camera from the list of available cameras.
                            currentCamera!,
                            // Define the resolution to use.
                            ResolutionPreset.max,
                          );

                          // Next, initialize the controller. This returns a Future.
                          _initializeControllerFuture =
                              _controller.initialize();
                        }
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Transform.scale(
                              scale: 1.13, child: CameraPreview(_controller)),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 32, top: 16),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: flashButton(),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Container(
                                      child: documentationButton(
                                          Icons.camera_alt_outlined),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Container(
                                      child: acceptButton(),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                        isCameraFeedback
                            ? Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.white,
                                // decoration: BoxDecoration(
                                //     border:
                                //         Border.all(color: Colors.white, width: 15)),
                              )
                            : Container()
                      ],
                    ),
                  )
                : const Center(
                    child: Text('No camera found'),
                  );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  documentationButton(IconData iconData) {
    return GestureDetector(
      onTap: () async {
        // Take the Picture in a try / catch block. If anything goes wrong,
        // catch the error.
        try {
          // Ensure that the camera is initialized.
          // await _initializeControllerFuture;
          cameraFeedback();
          // Attempt to take a picture and get the file `image`
          // where it was saved.
          final image = await _controller.takePicture();

          if (!mounted) return;
          setState(() {
            Media media = Media(
                type: 'image',
                title: DateTime.now().toString().split('.')[0],
                source: image.path);
            widget.mediaList.add(media);

            currentMedia.add(media);
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
        // margin: const EdgeInsets.only(bottom: 50),
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
        // margin: const EdgeInsets.only(bottom: 50),
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
        flashMode = FlashMode.off;
        _controller.setFlashMode(FlashMode.off);
        Navigator.push(
          context,
          NoAnimationPageRoute(
            builder: (context) => AcceptanceCriteriaMediaList(
              preTitle: '${widget.preTitle}/Camera',
              mediaList: currentMedia,
              acceptanceCriteria: widget.acceptanceCriteria,
              challenge: widget.challenge,
            ),
          ),
        ).then((_) => setState(() {}));
      },
      child: Container(
        width: 40,
        height: 40,
        // margin: const EdgeInsets.only(bottom: 50),
        decoration: BoxDecoration(
            image: currentMedia.isNotEmpty
                ? DecorationImage(
                    image: AssetImage(currentMedia.last.source),
                    fit: BoxFit.cover,
                  )
                : null,
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

  void cameraFeedback() {
    setState(() {
      isCameraFeedback = true;
    });
    Future.delayed(
      Duration(milliseconds: 100),
      () => setState(() {
        isCameraFeedback = false;
      }),
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
