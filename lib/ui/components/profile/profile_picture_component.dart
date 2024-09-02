import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';

class ProfilePictureMaxComponent extends StatelessWidget {
  final String? profilePictureUrl;

  const ProfilePictureMaxComponent(
      {super.key, required this.profilePictureUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomContainerComponent(
        backgroundColor: themeColor4,
        borderWidth: 0,
        padding: const EdgeInsets.all(0),
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
    );
  }
}
