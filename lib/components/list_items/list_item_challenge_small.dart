import 'package:challenge/enums/challenge_status.dart';
import 'package:flutter/material.dart';
import 'package:challenge/models/challenge.dart';

import '../../globals.dart';

class ListItemChallengeSmall extends StatelessWidget {
  const ListItemChallengeSmall(
      {super.key,
      required this.onTap,
      required this.challenge,
      this.isProgressVisible = false});

  final dynamic Function() onTap;

  final Challenge challenge;

  final bool isProgressVisible;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: double.infinity,
          height: 64,
          margin: const EdgeInsets.only(left: 20, right: 20),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(24))),
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(241, 245, 249, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: challenge.thumbnailPath != ''
                        ? Image.asset(challenge.thumbnailPath,
                            fit: BoxFit.cover)
                        : challenge.media.isNotEmpty
                            ? Image.asset(challenge.media.first.source,
                                fit: BoxFit.cover)
                            : const Center(
                                child: Icon(Icons.question_mark,
                                    color: themeColor3),
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
                        value: challenge.acceptanceCriteria.isEmpty
                            ? 0
                            : challenge.acceptanceCriteria[0].activity.amount <=
                                    0
                                ? 0
                                : challenge.acceptanceCriteria[0].progress /
                                    challenge
                                        .acceptanceCriteria[0].activity.amount,
                        color: challenge.status == ChallengeStatus.failed
                            ? Colors.red[300]
                            : Colors.green[300],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
