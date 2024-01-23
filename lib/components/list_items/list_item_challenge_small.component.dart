import 'package:challenge/components/list_items/list_item_container.component.dart';
import 'package:challenge/enums/challenge_status.enum.dart';
import 'package:flutter/material.dart';
import 'package:challenge/models/challenge.model.dart';

import 'package:challenge/globals.dart';

class ListItemChallengeSmallComponent extends StatelessWidget {
  const ListItemChallengeSmallComponent(
      {super.key,
      required this.onTap,
      required this.challenge,
      this.isProgressVisible = false});

  final dynamic Function() onTap;

  final ChallengeModel challenge;

  final bool isProgressVisible;

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
                  child: challenge.thumbnailPath != ''
                      ? Image.asset(challenge.thumbnailPath, fit: BoxFit.cover)
                      : challenge.media.isNotEmpty
                          ? Image.asset(challenge.media.first.source,
                              fit: BoxFit.cover)
                          : const Center(
                              child:
                                  Icon(Icons.question_mark, color: themeColor3),
                            )),
            ),
            Expanded(
              child: Container(
                child: Text(
                  challenge.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            isProgressVisible
                ? Container(
                    width: 25,
                    height: 25,
                    margin: EdgeInsets.only(right: 7),
                    child: CircularProgressIndicator(
                      backgroundColor: themeColor5,
                      strokeCap: StrokeCap.round,
                      value: challenge.acceptanceCriterias.isEmpty
                          ? 0
                          : challenge.acceptanceCriterias[0].activity.amount <=
                                  0
                              ? 0
                              : challenge.acceptanceCriterias[0].progress /
                                  challenge
                                      .acceptanceCriterias[0].activity.amount,
                      color: challenge.status == ChallengeStatusEnum.failed
                          ? Colors.red[300]
                          : Colors.green[300],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
