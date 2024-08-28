import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:flutter/material.dart';

class UploadProfilePictureComponent extends StatefulWidget {
  final UserModel editUser;

  const UploadProfilePictureComponent({super.key, required this.editUser});

  @override
  State<UploadProfilePictureComponent> createState() =>
      _UploadProfilePictureComponentState();
}

class _UploadProfilePictureComponentState
    extends State<UploadProfilePictureComponent> {
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
            widget.editUser.profilePictureUrl = media.source;
          });
        },
        isQuadratic: true,
        padding: const EdgeInsets.all(0),
        child: Center(
          child: SizedBox(
            width: CustomContainerComponent.standardHeight,
            height: CustomContainerComponent.standardHeight,
            child: widget.editUser.hasProfilePicture()
                ? mediaService.isUrlLocal(widget.editUser.profilePictureUrl!)
                    ? ClipRRect(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(13)), // TODO: 13?
                        child: Image.asset(
                          widget.editUser.profilePictureUrl!,
                          fit: BoxFit.contain,
                        ))
                    : ClipRRect(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(13)), // TODO: 13?
                        child: Image.network(
                          widget.editUser.profilePictureUrl!,
                          fit: BoxFit.contain,
                        ))
                : const Center(
                    child: Icon(Icons.file_upload_rounded, color: themeColor3),
                  ),
          ),
        ));
  }
}
