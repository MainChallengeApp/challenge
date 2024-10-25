import 'package:challenge/enums/box_fit_enum.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
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
  var mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    return TapContainerComponent(
      onTap: widget.onTap,
      isQuadratic: true,
      height: 2 * CustomContainerComponent.standardHeight,
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(0),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(
              CustomContainerComponent.standardRadius - 2)), // TODO: -2 ?
          child: widget.userPictureUrl == null
              ? Icon(
                  IconEnum.user.icon,
                  color: Theme.of(context).colorScheme.tertiary,
                )
              : mediaService.isUrlLocal(widget.userPictureUrl!)
                  ? Image.asset(widget.userPictureUrl!,
                      fit: BoxFitEnum.cover.fit,
                      errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(IconEnum.user.icon,
                                color: Theme.of(context).colorScheme.tertiary),
                          ))
                  : Image.network(widget.userPictureUrl!,
                      fit: BoxFitEnum.cover.fit,
                      errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(IconEnum.user.icon,
                                color: Theme.of(context).colorScheme.tertiary),
                          ))),
    );
  }
}
