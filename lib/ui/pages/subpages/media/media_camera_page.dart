import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:challenge/ui/components/media/video_thumbnail_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/ui/pages/home/repetition/progress_media_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MediaCameraPage extends StatefulWidget {
  const MediaCameraPage({
    super.key,
    required this.cameras,
    required this.preTitle,
    required this.mediaList,
    required this.challenge,
  });

  final List<CameraDescription> cameras;
  final String preTitle;
  final List<MediaModel> mediaList;
  final ChallengeModel challenge;

  @override
  State<MediaCameraPage> createState() => _CameraStateMedia();
}

class _CameraStateMedia extends State<MediaCameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  FlashMode flashMode = FlashMode.off;
  List<MediaModel> currentMedia = [];
  CameraDescription? currentCamera;

  var isCameraFeedback = false;

  bool isRecording = false;

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
      _initializeControllerFuture
          .then((value) => _controller.getMinZoomLevel().then((value) {
                _controller
                    .lockCaptureOrientation(DeviceOrientation.portraitUp);
                _controller.setZoomLevel(1);
              }));
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
      appBar: AppBarComponent(preTitle: widget.preTitle, titleText: 'Camera'),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return currentCamera != null
                ? GestureDetector(
                    onDoubleTap: () {
                      onDoubleTapChangeCamera();
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
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 32, top: 16),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: flashButton(),
                                  ),
                                  const SpaceComponent(
                                    width: 50,
                                  ),
                                  Container(
                                    child: documentationButton(
                                        Icons.camera_alt_outlined),
                                  ),
                                  const SpaceComponent(
                                    width: 50,
                                  ),
                                  Container(
                                    child: acceptButton(),
                                  )
                                ]),
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

  void onDoubleTapChangeCamera() {
    setState(() {
      if (widget.cameras.length >= 2 && currentCamera == widget.cameras[0]) {
        currentCamera = widget.cameras[1];
        _controller = CameraController(
          // Get a specific camera from the list of available cameras.
          currentCamera!,
          // Define the resolution to use.
          ResolutionPreset.max,
        );

        // Next, initialize the controller. This returns a Future.
        _initializeControllerFuture = _controller.initialize();
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
        _initializeControllerFuture = _controller.initialize();
      }
      _initializeControllerFuture.then((value) {
        _controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
      });
    });
  }

  documentationButton(IconData iconData) {
    return GestureDetector(
      onTap: () async {
        if (isRecording) {
          setState(() {
            isRecording = false;
          });
          try {
            final video = await _controller.stopVideoRecording();
            if (!mounted) return;
            setState(() {
              MediaModel media = MediaModel(
                  type: MediaTypeEnum.video,
                  title: DateTime.now().toString().split('.')[0],
                  source: video.path);
              widget.mediaList.add(media);

              currentMedia.add(media);
            });
            // Navigator.push(
            //   context,
            //   NoAnimationPageRouteComponent(
            //     builder: (context) =>
            //         VideoPage(filePath: currentMedia.last.source),
            //   ),
            // ).then((_) => setState(() {}));
          } on Exception catch (e) {
            log(e.toString());
          }
        } else {
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
              MediaModel media = MediaModel(
                  type: MediaTypeEnum.image,
                  title: DateTime.now().toString().split('.')[0],
                  source: image.path);
              widget.mediaList.add(media);

              currentMedia.add(media);
            });
          } catch (e) {
            // If an error occurs, log the error to the console.
            log(e.toString());
          }
        }
      },
      onLongPress: () async {
        if (!isRecording) {
          setState(() {
            isRecording = true;
          });
          try {
            await _controller.prepareForVideoRecording();
            await _controller.startVideoRecording();
          } catch (e) {
            // If an error occurs, log the error to the console.
            log(e.toString());
          }
        }
      },
      child: Container(
        width: 55,
        height: 55,
        // margin: const EdgeInsets.only(bottom: 50),
        decoration: BoxDecoration(
            color: isRecording ? themeColor1 : Colors.white,
            border: Border.all(
                width: 1, color: isRecording ? themeColor1 : Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Center(
            child: Icon(
          iconData,
          color: isRecording ? Colors.white : Colors.black,
        )),
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
            border: Border.all(
                width: 1,
                color: flashMode == FlashMode.off ? Colors.white : themeColor1),
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
          NoAnimationPageRouteComponent(
            builder: (context) => ProgressMediaListPage(
              preTitle: '${widget.preTitle}/Camera',
              initialMediaList: currentMedia,
              challenge: widget.challenge,
              repetition: widget.challenge.getCurrentRepetition(),
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
                ? currentMedia.last.type == MediaTypeEnum.image
                    ? DecorationImage(
                        image: AssetImage(currentMedia.last.source),
                        fit: BoxFit.cover,
                      )
                    : null
                : null,
            color: Colors.white.withAlpha(100),
            border: Border.all(width: 1, color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Stack(
          children: [
            currentMedia.isNotEmpty &&
                    currentMedia.last.type == MediaTypeEnum.video
                ? ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: VideoThumbnailComponent(
                        filePath: currentMedia.last.source))
                : Container(),
            Center(
                child: Icon(
              Icons.chevron_right,
              color: flashMode == FlashMode.off ? Colors.white : Colors.white,
            ))
          ],
        ),
      ),
    );
  }

  void cameraFeedback() {
    setState(() {
      isCameraFeedback = true;
    });
    Future.delayed(
      const Duration(milliseconds: 100),
      () => setState(() {
        isCameraFeedback = false;
      }),
    );
  }
}
