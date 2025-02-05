import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class UserPictureMinComponent extends StatefulWidget {
  final String? userPictureUrl;
  final Function()? onTap;

  const UserPictureMinComponent(
      {super.key, required this.userPictureUrl, this.onTap});

  @override
  State<UserPictureMinComponent> createState() =>
      _UserPictureMinComponentState();
}

class _UserPictureMinComponentState extends State<UserPictureMinComponent> {
  final _mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    return TapContainerComponent(
        onTap: widget.onTap,
        isQuadratic: true,
        height: 3 * CustomContainerComponent.standardHeight,
        backgroundColor: Theme.of(context).colorScheme.themeColor4,
        borderWidth: 0,
        padding: const EdgeInsets.all(0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(
              CustomContainerComponent.standardRadius - 2)), // TODO: -2 ?
          child: _mediaService.getImage(context, widget.userPictureUrl,
              icon: IconEnum.user.icon, fit: BoxFit.cover),
        ));
  }
}
