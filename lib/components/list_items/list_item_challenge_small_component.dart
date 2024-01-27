import 'package:challenge/components/list_items/list_item_container_component.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:challenge/models/challenge_model.dart';

import 'package:challenge/globals.dart';

class ListItemChallengeSmallComponent extends StatelessWidget {
  const ListItemChallengeSmallComponent(
      {super.key, required this.onTap, required this.challenge});

  final dynamic Function() onTap;

  final ChallengeModel challenge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListItemContainerComponent(
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: themeColor4,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 12),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: challenge.getThumbnailPath() != ''
                      ? challenge.isThumbnailFromAssetsImage()
                          ? Transform.scale(
                              scale: 0.8,
                              child: Image.asset(
                                challenge.getThumbnailPath(),
                                fit: BoxFit.contain,
                              ),
                            )
                          : Image.asset(challenge.getThumbnailPath(),
                              fit: BoxFit.cover)
                      : const Center(
                          child: Icon(Icons.question_mark, color: themeColor3),
                        )),
            ),
            Expanded(
              child: Text(
                challenge.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Container(
                width: 25,
                height: 25,
                margin: const EdgeInsets.only(right: 7),
                child: challenge.status != ChallengeStatusEnum.backlog
                    ? CircularProgressIndicator(
                        backgroundColor: themeColor5,
                        strokeCap: StrokeCap.round,
                        value: challenge.acceptanceCriterias.isEmpty
                            ? 1
                            : challenge.acceptanceCriterias[0].amount <= 0
                                ? 1
                                : challenge.acceptanceCriterias[0]
                                    .calcProgressRatio(),
                        color: challenge.status == ChallengeStatusEnum.failed
                            ? Colors.red[300]
                            : Colors.green[300],
                      )
                    : Container())
          ],
        ),
      ),
    );
  }
}
