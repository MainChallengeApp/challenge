import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/thumbnail_model.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:flutter/material.dart';

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
          MediaModel? media = await mediaService.openImagePicker();
          if (media == null) {
            return;
          }
          setState(() {
            widget.editChallenge.thumbnail = ThumbnailModel();
            widget.editChallenge.thumbnail!.selectThumbnail(media.source);
          });
        },
        isQuadratic: true,
        padding: const EdgeInsets.all(0),
        child: Center(
          child: SizedBox(
            width: CustomContainerComponent.standardHeight,
            height: CustomContainerComponent.standardHeight,
            child: widget.editChallenge.hasThumbnail()
                ? mediaService.isUrlLocal(widget.editChallenge.thumbnail!.url)
                    ? ClipRRect(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(13)), // TODO: 13?
                        child: Transform.scale(
                          scale: widget.editChallenge.thumbnail!.scale,
                          child: Image.asset(
                            widget.editChallenge.thumbnail!.url,
                            fit: widget.editChallenge.thumbnail!.fit.fit,
                          ),
                        ))
                    : ClipRRect(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(13)), // TODO: 13?
                        child: Transform.scale(
                          scale: widget.editChallenge.thumbnail!.scale,
                          child: Image.network(
                            widget.editChallenge.thumbnail!.url,
                            fit: widget.editChallenge.thumbnail!.fit.fit,
                          ),
                        ))
                : const Center(
                    child: Icon(Icons.file_upload_rounded, color: themeColor3),
                  ),
          ),
        ));
  }
}
