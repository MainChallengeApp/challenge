import 'dart:ui';

import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/thumbnail_model.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/simple_components/app_icon_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/small_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class ThumbnailMaxComponent extends StatelessWidget {
  final ThumbnailModel? thumbnail;
  final AttemptModel? attempt;
  final IconData? nullIcon;
  final Function()? onTap;

  ThumbnailMaxComponent({
    super.key,
    this.onTap,
    required this.thumbnail,
    this.attempt,
    this.nullIcon,
  });

  final _mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.75,
      child: TapContainerComponent(
        onTap: onTap,
        backgroundColor: Theme.of(context).colorScheme.themeColor4,
        padding: const EdgeInsets.all(0),
        borderWidth: 0,
        height: double.infinity,
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(CustomContainerComponent.standardRadius),
                    ),
                    child: nullIcon != null && thumbnail == null
                        ? Icon(
                            nullIcon,
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 40,
                          )
                        : Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.center,
                            children: [
                                Visibility(
                                    visible:
                                        thumbnail?.isBackgroundBlurred ?? false,
                                    child: _mediaService.getImage(
                                      context,
                                      thumbnail?.url ?? AppIconComponent.path,
                                      fit: BoxFit.cover,
                                      scale: 0.99,
                                    )),
                                Visibility(
                                  visible:
                                      thumbnail?.isBackgroundBlurred ?? false,
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 20, sigmaY: 20),
                                    child: Container(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                    ),
                                  ),
                                ),
                                _mediaService.getImage(
                                  context,
                                  thumbnail?.url ?? AppIconComponent.path,
                                  fit: BoxFit.contain,
                                  scale:
                                      (thumbnail?.isBackgroundBlurred ?? false)
                                          ? 0.8
                                          : thumbnail?.scale ?? 0.5,
                                ),
                              ])),
              ),
            ),
            _mediaAmount(context),
          ],
        ),
      ),
    );
  }

  _mediaAmount(BuildContext context) {
    return attempt == null
        ? const SizedBox()
        : Positioned(
            right: 0,
            bottom: 0,
            child: ContainerInContainerComponent(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(
                  horizontal: ContainerInContainerComponent
                          .standardPaddingSmall +
                      0.5), // + 0.5 more equal to total challenge percentage
              height: SmallContainerInListItemComponent.height,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${attempt!.media.length} ',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                  Icon(
                    IconEnum.media.icon,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: Theme.of(context).textTheme.bodySmall?.fontSize,
                  )
                ],
              ),
            ));
  }
}
