import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:flutter/material.dart';

class UploadUserPictureComponent extends StatefulWidget {
  final UserModel editUser;

  const UploadUserPictureComponent({super.key, required this.editUser});

  @override
  State<UploadUserPictureComponent> createState() =>
      _UploadUserPictureComponentState();
}

class _UploadUserPictureComponentState
    extends State<UploadUserPictureComponent> {
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
            widget.editUser.pictureUrl = media.source;
          });
        },
        isQuadratic: true,
        padding: const EdgeInsets.all(0),
        child: Center(
          child: SizedBox(
            width: CustomContainerComponent.standardHeight,
            height: CustomContainerComponent.standardHeight,
            child: widget.editUser.hasPicture()
                ? mediaService.isUrlLocal(widget.editUser.pictureUrl!)
                    ? ClipRRect(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(13)), // TODO: 13?
                        child: Image.asset(
                          widget.editUser.pictureUrl!,
                          fit: BoxFit.cover,
                        ))
                    : ClipRRect(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(13)), // TODO: 13?
                        child: Image.network(
                          widget.editUser.pictureUrl!,
                          fit: BoxFit.cover,
                        ))
                : Center(
                    child: Icon(Icons.file_upload_rounded,
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
          ),
        ));
  }
}
