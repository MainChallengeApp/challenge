import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class ThumbnailMaxComponent extends StatelessWidget {
  final ChallengeModel challenge;
  final dynamic Function() onTapOpenMediaPage;
  final AttemptModel? attempt;

  final mediaService = MediaService();

  ThumbnailMaxComponent(
      {super.key,
      required this.challenge,
      required this.onTapOpenMediaPage,
      this.attempt});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.75,
      child: TapContainerComponent(
        onTap: onTapOpenMediaPage,
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
                    borderRadius: const BorderRadius.all(Radius.circular(
                        CustomContainerComponent.standardRadius)),
                    child: challenge.hasThumbnail()
                        ? mediaService.isUrlLocal(challenge.thumbnail!.url)
                            ? Transform.scale(
                                scale: challenge.thumbnail!.scale,
                                child: Image.asset(challenge.thumbnail!.url,
                                    fit: challenge.thumbnail!.fit.fit),
                              )
                            : Transform.scale(
                                scale: challenge.thumbnail!.scale,
                                child: Image.network(challenge.thumbnail!.url,
                                    fit: challenge.thumbnail!.fit.fit),
                              )
                        : Image.asset(
                            'assets/icons/challenge_icon_black.png',
                            fit: BoxFit.contain,
                            width: 100,
                            height: 100,
                          )),
              ),
            ),
            attempt != null
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: ContainerInContainerComponent(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${attempt!.media.length}',
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.inventory_2_outlined,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.fontSize,
                            )
                          ],
                        )))
                : Container(),
          ],
        ),
      ),
    );
  }
}
