import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class UserPictureMaxComponent extends StatefulWidget {
  final String? userPictureUrl;

  const UserPictureMaxComponent({super.key, required this.userPictureUrl});

  @override
  State<UserPictureMaxComponent> createState() =>
      _UserPictureMaxComponentState();
}

class _UserPictureMaxComponentState extends State<UserPictureMaxComponent> {
  final _mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomContainerComponent(
        backgroundColor: Theme.of(context).colorScheme.themeColor4,
        borderWidth: 0,
        padding: const EdgeInsets.all(0),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(
                Radius.circular(CustomContainerComponent.standardRadius)),
            child: _mediaService.getImage(context, widget.userPictureUrl,
                icon: IconEnum.user.icon)),
      ),
    );
  }
}
