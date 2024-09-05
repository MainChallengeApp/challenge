import 'package:challenge/enums/box_fit_enum.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';

class UserPictureMinComponent extends StatefulWidget {
  final String? userPictureUrl;

  const UserPictureMinComponent({super.key, required this.userPictureUrl});

  @override
  State<UserPictureMinComponent> createState() =>
      _UserPictureMinComponentState();
}

class _UserPictureMinComponentState extends State<UserPictureMinComponent> {
  var mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    return CustomContainerComponent(
      isQuadratic: true,
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(0),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(
              Radius.circular(CustomContainerComponent.standardRadius)),
          child: widget.userPictureUrl == null
              ? Icon(
                  IconEnum.user.icon,
                  color: themeColor3,
                )
              : mediaService.isUrlLocal(widget.userPictureUrl!)
                  ? Image.asset(widget.userPictureUrl!,
                      fit: BoxFitEnum.cover.fit,
                      errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(IconEnum.user.icon, color: themeColor3),
                          ))
                  : Image.network(widget.userPictureUrl!,
                      fit: BoxFitEnum.cover.fit,
                      errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(IconEnum.user.icon, color: themeColor3),
                          ))),
    );
  }
}
