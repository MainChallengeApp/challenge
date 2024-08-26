import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';

class UserProfilePictureComponent extends StatelessWidget {
  final String? profilePictureUrl;

  const UserProfilePictureComponent(
      {super.key, required this.profilePictureUrl});

  @override
  Widget build(BuildContext context) {
    return CustomContainerComponent(
      isQuadratic: true,
      child: Center(
          child: profilePictureUrl == null
              ? Icon(
                  IconEnum.profile.icon,
                  color: themeColor3,
                )
              : Image.network(profilePictureUrl!)),
    );
  }
}
