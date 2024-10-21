import 'package:challenge/enums/box_fit_enum.dart';
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
  var mediaService = MediaService();

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
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                            ))
                    : Image.network(widget.userPictureUrl!,
                        fit: BoxFitEnum.cover.fit,
                        errorBuilder: (context, error, stackTrace) => Center(
                              child: Icon(IconEnum.user.icon,
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                            ))),
      ),
    );
  }
}
