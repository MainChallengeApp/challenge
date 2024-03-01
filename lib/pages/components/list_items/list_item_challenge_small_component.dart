import 'package:challenge/pages/components/list_items/list_item_container_component.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:flutter/material.dart';
import 'package:challenge/models/challenge_model.dart';

import 'package:challenge/globals.dart';

class ListItemChallengeSmallComponent extends StatefulWidget {
  const ListItemChallengeSmallComponent(
      {super.key, required this.onTap, required this.challenge});

  final dynamic Function() onTap;

  final ChallengeModel challenge;

  @override
  State<ListItemChallengeSmallComponent> createState() =>
      _ListItemChallengeSmallComponentState();
}

class _ListItemChallengeSmallComponentState
    extends State<ListItemChallengeSmallComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
                  child: widget.challenge.getThumbnailPath() != ''
                      ? widget.challenge.isThumbnailFromAssetsImage()
                          ? Transform.scale(
                              scale: 0.8,
                              child: Image.asset(
                                widget.challenge.getThumbnailPath(),
                                fit: BoxFit.contain,
                              ),
                            )
                          : Image.asset(widget.challenge.getThumbnailPath(),
                              fit: BoxFit.cover)
                      : const Center(
                          child: Icon(Icons.question_mark, color: themeColor3),
                        )),
            ),
            Expanded(
              child: Text(
                widget.challenge.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            progressRecurring(),
            widget.challenge.status != ChallengeStatusEnum.backlog
                ? Container(
                    width: 25,
                    height: 25,
                    margin: const EdgeInsets.only(right: 7, left: 10),
                    child: CircularProgressIndicator(
                      backgroundColor: themeColor5,
                      strokeCap: StrokeCap.round,
                      value: widget.challenge.acceptanceCriterias.isEmpty
                          ? 1
                          : widget.challenge.acceptanceCriterias[0].amount <= 0
                              ? 1
                              : widget.challenge.acceptanceCriterias[0]
                                  .calcProgressRatio(),
                      color:
                          widget.challenge.status == ChallengeStatusEnum.failed
                              ? Colors.red[300]
                              : Colors.green[300],
                    ))
                : Container()
          ],
        ),
      ),
    );
  }

  progressRecurring() {
    AcceptanceCriteriaModel acceptanceCriteria =
        widget.challenge.acceptanceCriterias.first;
    return Container(
      margin: const EdgeInsets.only(right: 2),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: themeColor4,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Text(
          '${acceptanceCriteria.getCurrentFrequencyAmount(widget.challenge.startDate)}/${acceptanceCriteria.frequency.amount ?? '∞'} ${acceptanceCriteria.frequency.type == FrequencyTypeEnum.daily ? acceptanceCriteria.frequency.amount == 1 ? 'Day' : 'Days' : acceptanceCriteria.frequency.type == FrequencyTypeEnum.time ? acceptanceCriteria.frequency.amount == 1 ? 'Time' : 'Times' : ''}',
          style: const TextStyle(fontSize: 10, color: themeColor3),
          overflow: TextOverflow.ellipsis),
    );
  }
}
