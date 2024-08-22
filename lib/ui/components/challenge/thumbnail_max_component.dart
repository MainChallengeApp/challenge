import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:flutter/material.dart';

class ThumbnailMaxComponent extends StatelessWidget {
  final ChallengeModel challenge;
  final dynamic Function() onTapOpenMediaPage;
  final bool isMediaListVisible;

  const ThumbnailMaxComponent(
      {super.key,
      required this.challenge,
      required this.onTapOpenMediaPage,
      this.isMediaListVisible = true});

  @override
  Widget build(BuildContext context) {
    return TapContainerComponent(
      onTap: onTapOpenMediaPage,
      backgroundColor: themeColor4,
      padding: const EdgeInsets.all(0),
      borderWith: 0,
      height: 180,
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: double.infinity,
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(CustomContainerComponent.standardRadius)),
                  child: challenge.getThumbnailPath() != ''
                      ? challenge.isThumbnailLocal()
                          ? Transform.scale(
                              scale: challenge.thumbnail.scale,
                              child: Image.asset(challenge.getThumbnailPath(),
                                  fit: challenge.thumbnail.fit.fit),
                            )
                          : Transform.scale(
                              scale: challenge.thumbnail.scale,
                              child: Image.network(challenge.getThumbnailPath(),
                                  fit: challenge.thumbnail.fit.fit),
                            )
                      : const Icon(Icons.question_mark, color: themeColor3)),
            ),
          ),
          isMediaListVisible
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    clipBehavior: Clip.none,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: themeColor4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${challenge.media.length}',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              color: themeColor3,
                              // fontWeight: FontWeight.w100,
                              fontSize: 10),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.inventory_2_outlined,
                          color: themeColor3,
                          size: 10,
                        )
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
