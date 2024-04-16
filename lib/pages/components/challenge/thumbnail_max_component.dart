import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
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
    return GestureDetector(
      onTap: onTapOpenMediaPage,
      child: Container(
        decoration: const BoxDecoration(
            color: themeColor4,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        height: 180,
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: challenge.getThumbnailPath() != ''
                      ? challenge.isThumbnailFromAssetsImage()
                          ? Transform.scale(
                              scale: 0.8,
                              child: Image.asset(challenge.getThumbnailPath(),
                                  fit: BoxFit.contain),
                            )
                          : Image.asset(challenge.getThumbnailPath(),
                              fit: BoxFit.cover)
                      : const Icon(Icons.question_mark, color: themeColor3)),
            ),
            isMediaListVisible
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      clipBehavior: Clip.none,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: themeColor2.withAlpha(120)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            challenge.media.length.toString(),
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12),
                          ),
                          const Icon(
                            Icons.image_outlined,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
