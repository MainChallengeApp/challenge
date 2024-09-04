import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';

class UserPictureMaxComponent extends StatelessWidget {
  final String? userPictureUrl;

  const UserPictureMaxComponent({super.key, required this.userPictureUrl});

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
            child: userPictureUrl == null
                ? Icon(
                    IconEnum.user.icon,
                    color: themeColor3,
                  )
                : Image.network(userPictureUrl!, fit: BoxFit.cover)),
      ),
    );
  }
}
