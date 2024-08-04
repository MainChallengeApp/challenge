import 'package:challenge/components/simple_components/custom_container_component.dart';
import 'package:challenge/components/simple_components/tap_container_component.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadThumbnailComponent extends StatefulWidget {
  final ChallengeModel editChallenge;

  const UploadThumbnailComponent({super.key, required this.editChallenge});

  @override
  State<UploadThumbnailComponent> createState() =>
      _UploadThumbnailComponentState();
}

class _UploadThumbnailComponentState extends State<UploadThumbnailComponent> {
  MediaService mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    return TapContainerComponent(
      onTap: () async {
        XFile? file = await mediaService.onTapUploadMedia();
        setState(() {
          if (file != null) {
            widget.editChallenge.thumbnailPath = file.path;
          }
        });
      },
      isQuadratic: true,
      padding: widget.editChallenge.isThumbnailFromAssetsImage()
          ? const EdgeInsets.all(10)
          : const EdgeInsets.all(0),
      child: Center(
          child: SizedBox(
        width: CustomContainerComponent.standardHeight,
        height: CustomContainerComponent.standardHeight,
        child: widget.editChallenge.hasThumbnail()
            ? ClipRRect(
                borderRadius: widget.editChallenge.isThumbnailFromAssetsImage()
                    ? BorderRadius.zero
                    : const BorderRadius.all(Radius.circular(13)),
                child: Image.asset(widget.editChallenge.thumbnailPath,
                    fit: BoxFit.cover))
            : const Center(
                child: Icon(Icons.file_upload_rounded, color: themeColor3),
              ),
      )),
    );
  }
}
