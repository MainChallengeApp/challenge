import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/ui/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';

class UserProfilePictureMaxComponent extends StatelessWidget {
  final String? profilePictureUrl;

  const UserProfilePictureMaxComponent(
      {super.key, required this.profilePictureUrl});

  @override
  Widget build(BuildContext context) {
    return CustomContainerComponent(
      backgroundColor: themeColor4,
      padding: const EdgeInsets.all(0),
      borderWidth: 0,
      height: ThumbnailMaxComponent.standardHeight,
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: ClipRRect(
              borderRadius: const BorderRadius.all(
                  Radius.circular(CustomContainerComponent.standardRadius)),
              child: profilePictureUrl == null
                  ? Icon(
                      IconEnum.profile.icon,
                      color: themeColor3,
                    )
                  : Image.network(profilePictureUrl!, fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
