import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/ui/components/media/video_thumbnail_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/dialogs/error_occurred_dialog.dart';
import 'package:challenge/ui/pages/home/repetition/progress_media_list_page.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class MediaCameraPage extends StatefulWidget {
  const MediaCameraPage({
    Key? key,
    required this.mediaList,
    required this.attempt,
    required this.groupChallenge,
    required this.participant,
  }) : super(key: key);

  final List<MediaModel> mediaList;
  final AttemptModel attempt;
  final GroupChallengeModel groupChallenge;
  final ParticipantModel participant;

  @override
  State<MediaCameraPage> createState() => _CameraStateMedia();
}

class _CameraStateMedia extends State<MediaCameraPage>
    with WidgetsBindingObserver {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  Future<void> _initializeControllerFuture = Future.value();
  FlashMode _flashMode = FlashMode.off;
  final List<MediaModel> _currentMedia = [];
  CameraDescription? _currentCamera;
  bool _isCameraFeedback = false;
  bool _isRecording = false;
  late final UsersProvider _usersProvider;

  double _currentZoomLevel = 1.0; // Start slightly zoomed in
  double _baseZoomLevel = 1.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 5.0; // Limit max zoom to 5x for more natural feel
  final ResolutionPreset _currentResolutionPreset = ResolutionPreset.high;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _usersProvider = Provider.of<UsersProvider>(context, listen: false);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const AppBarComponent(title: ''),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(bottom: false, child: _buildBody()),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        throw CameraException(
            'No cameras available', 'No cameras were found on the device.');
      }
      _currentCamera = _cameras.first;
      await _initializeCameraController();
    } on CameraException catch (e) {
      // ignore: use_build_context_synchronously
      ErrorOccurredDialog.show(context: context, errorText: e.description);
    }
  }

  Future<void> _initializeCameraController() async {
    final CameraController cameraController = CameraController(
      _currentCamera!,
      _currentResolutionPreset,
      enableAudio: false,
    );
    _controller = cameraController;
    _initializeControllerFuture = cameraController.initialize();
    await _initializeControllerFuture;
    await cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);

    // Get the available zoom range
    _minAvailableZoom = await cameraController.getMinZoomLevel();
    _maxAvailableZoom = await cameraController.getMaxZoomLevel();

    // Clamp the initial zoom level
    _currentZoomLevel =
        _baseZoomLevel.clamp(_minAvailableZoom, _maxAvailableZoom);

    // Set initial zoom level
    await cameraController.setZoomLevel(_currentZoomLevel);

    if (mounted) {
      setState(() {});
    }
  }

  void _onDoubleTapChangeCamera() async {
    if (_cameras.length < 2) return;
    final CameraDescription newCamera =
        _currentCamera == _cameras[0] ? _cameras[1] : _cameras[0];
    await _controller?.dispose();
    _currentCamera = newCamera;
    await _initializeCameraController();
    setState(() {});
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      _cameraFeedback();
      XFile image = await _controller!.takePicture();

      // Check if the current camera is the front camera
      bool isFrontCamera =
          _controller!.description.lensDirection == CameraLensDirection.front;

      if (isFrontCamera) {
        // If it's the front camera, flip the image
        File imageFile = File(image.path);
        Uint8List imageBytes = await imageFile.readAsBytes();

        ui.Image decodedImage = await decodeImageFromList(imageBytes);

        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder);

        canvas.scale(-1, 1); // This flips the image horizontally
        canvas.drawImage(
            decodedImage, Offset(-decodedImage.width.toDouble(), 0), Paint());

        final picture = recorder.endRecording();
        final img =
            await picture.toImage(decodedImage.width, decodedImage.height);
        final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

        File flippedFile =
            await File('${path.dirname(image.path)}/flipped_${image.name}')
                .create();
        await flippedFile.writeAsBytes(pngBytes!.buffer.asUint8List());

        image = XFile(flippedFile.path);
      }

      if (!mounted) return;
      setState(() {
        MediaModel media = MediaModel(
          type: MediaTypeEnum.image,
          title: TimeService.now().toString().split('.')[0],
          source: image.path,
        );
        widget.mediaList.add(media);
        _currentMedia.add(media);
      });
    } catch (e) {
      ErrorOccurredDialog.show(
          context: context, errorText: 'Failed to take picture: $e');
    }
  }

  // ignore: unused_element
  Future<void> _toggleVideoRecording() async {
    if (_isRecording) {
      try {
        final XFile video = await _controller!.stopVideoRecording();
        if (!mounted) return;
        setState(() {
          _isRecording = false;
          MediaModel media = MediaModel(
            type: MediaTypeEnum.video,
            title: TimeService.now().toString().split('.')[0],
            source: video.path,
          );
          widget.mediaList.add(media);
          _currentMedia.add(media);
        });
      } catch (e) {
        ErrorOccurredDialog.show(
            context: context, errorText: 'Failed to stop video recording: $e');
      }
    } else {
      try {
        await _controller!.prepareForVideoRecording();
        await _controller!.startVideoRecording();
        setState(() {
          _isRecording = true;
        });
      } catch (e) {
        ErrorOccurredDialog.show(
            // ignore: use_build_context_synchronously
            context: context,
            errorText: 'Failed to start video recording: $e');
      }
    }
  }

  void _toggleFlash() async {
    if (_controller == null) return;

    _flashMode = _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    try {
      await _controller?.setFlashMode(_flashMode);
    } catch (e) {
      // not possible with front camera
    }
    setState(() {});
  }

  void _cameraFeedback() {
    setState(() {
      _isCameraFeedback = true;
    });
    Future.delayed(
      const Duration(milliseconds: 100),
      () => setState(() {
        _isCameraFeedback = false;
      }),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [_buildCameraPreview(), _buildControls()],
          );
        } else {
          return const Center(child: LoadingCircleComponent());
        }
      },
    );
  }

  Widget _buildCameraPreview() {
    if (_currentCamera == null ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return const Center(child: LoadingCircleComponent());
    }
    return GestureDetector(
      onDoubleTap: _onDoubleTapChangeCamera,
      onScaleStart: _handleZoomStart,
      onScaleUpdate: _handleZoom,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(CardComponent.standardBorderRadius),
        ),
        child: Container(
          color: Theme.of(context).colorScheme.themeColor4,
          child: Stack(
            children: [
              CameraPreview(_controller!),
              _arrowBack(),
              if (_isCameraFeedback) const _CameraFeedbackOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  _arrowBack() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Align(
        heightFactor: 1,
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: Icon(
            IconEnum.arrowLeft.icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _handleZoom(ScaleUpdateDetails details) {
    // Ensure the controller is initialized
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    // Calculate the new zoom level
    double newZoomLevel = (_baseZoomLevel * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    // Only update if the zoom level has changed
    if (newZoomLevel != _currentZoomLevel) {
      setState(() {
        _currentZoomLevel = newZoomLevel;
      });

      _controller!.setZoomLevel(newZoomLevel).then((_) {
        // Zoom set successfully
      }).catchError((error) {
        log('Error setting zoom: $error');
      });
    }
  }

// Add this method to reset the base zoom level when the scale gesture starts
  void _handleZoomStart(ScaleStartDetails details) {
    _baseZoomLevel = _currentZoomLevel;
  }

  Widget _buildControls() {
    return Visibility(
      visible: _cameras.isNotEmpty,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: BottomNavigationComponent.standardMargin + 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildFlashButton(),
              _buildCaptureButton(),
              _buildAcceptButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlashButton() {
    return GestureDetector(
      onTap: _toggleFlash,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _flashMode == FlashMode.off
              ? Colors.white.withOpacity(0.3)
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.themeColor5,
          ),
        ),
        child: Icon(
          Icons.flashlight_on_outlined,
          color: _flashMode == FlashMode.off ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    return TapContainerComponent(
      onTap: _takePicture,
      onTapColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
      isQuadratic: true,
      height: 60,
      borderRadius: 20,
      child: Icon(
        _isRecording ? Icons.stop : IconEnum.camera.icon,
        color: _isRecording ? Colors.white : Colors.black,
        size: 30,
      ),
    );
  }

  Widget _buildAcceptButton() {
    return GestureDetector(
      onTap: () {
        _controller?.setFlashMode(FlashMode.off);
        Navigator.push(
          context,
          NoAnimationPageRouteComponent(
            builder: (context) => ProgressMediaListPage(
              initialMediaList: _currentMedia,
              attempt: widget.attempt,
              groupChallenge: widget.groupChallenge,
              participant: widget.participant,
              isEditableByUser:
                  widget.participant.user.id == _usersProvider.user.id,
              repetition:
                  widget.attempt.getCurrentRepetition(widget.groupChallenge),
              amountOfPops: 2,
            ),
          ),
        ).then((_) => setState(() {}));
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          image: _currentMedia.isNotEmpty &&
                  _currentMedia.last.type == MediaTypeEnum.image
              ? DecorationImage(
                  image: AssetImage(_currentMedia.last.source),
                  fit: BoxFit.cover)
              : null,
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.themeColor5,
          ),
        ),
        child: Stack(
          children: [
            if (_currentMedia.isNotEmpty &&
                _currentMedia.last.type == MediaTypeEnum.video)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: VideoThumbnailComponent(
                    filePath: _currentMedia.last.source),
              ),
            Center(
                child: Icon(Icons.chevron_right,
                    color:
                        _currentMedia.isEmpty ? Colors.black : Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _CameraFeedbackOverlay extends StatelessWidget {
  const _CameraFeedbackOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.8),
    );
  }
}
