import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/pages/components/challenge/challenge_total_percentage_component.dart';
import 'package:challenge/pages/components/list_items/list_item_container_component.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/pages/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:challenge/models/challenge_model.dart';

import 'package:challenge/globals.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListItemChallengeSmallComponent extends StatefulWidget {
  const ListItemChallengeSmallComponent({
    super.key,
    required this.onTap,
    required this.challenge,
    this.isSearch = false,
    this.onTapDeleteChallenge,
  });

  final dynamic Function() onTap;
  final ChallengeModel challenge;
  final bool isSearch;
  final void Function()? onTapDeleteChallenge;

  @override
  State<ListItemChallengeSmallComponent> createState() =>
      _ListItemChallengeSmallComponentState();
}

class _ListItemChallengeSmallComponentState
    extends State<ListItemChallengeSmallComponent> {
  late BuildContext context2;
  @override
  Widget build(BuildContext context) {
    return ListItemContainerComponent(
      endActionPane: endActionPane,
      onTap: widget.onTap,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: themeColor4,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 12),
            child: Hero(
              tag: widget.challenge.id.toString(),
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
          ),
          Expanded(
            child: Text(
              widget.challenge.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          // progressRecurring(),
          percentageDone()
          // progressCircle()
        ],
      ),
    );
  }

  Container progressCircle() {
    return widget.challenge.status != ChallengeStatusEnum.backlog
        ? Container(
            width: 25,
            height: 25,
            margin: const EdgeInsets.only(right: 7, left: 10),
            child: CircularProgressIndicator(
              backgroundColor: themeColor5,
              strokeCap: StrokeCap.round,
              value: widget.challenge.acceptanceCriteria.amount <= 0
                  ? 1
                  : widget.challenge
                      .getCurrentRepetitionProgressPercentageProgress(),
              color: widget.challenge.status == ChallengeStatusEnum.failed
                  ? red
                  : green,
            ))
        : Container();
  }

  percentageDone() {
    return ChallengeTotalPercentageComponent(
      challenge: widget.challenge,
      isVisible: !widget.isSearch,
    );
  }

  ActionPane? endActionPane(Function closeSlidable) {
    return widget.isSearch
        ? null
        : ActionPane(
            extentRatio: 0.22,
            motion: const ScrollMotion(),
            children: [
                deleteSlider(closeSlidable),
                const SpaceComponent(
                  width: 20,
                )
              ]);
  }

  deleteSlider(Function closeSlidable) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          closeSlidable();
          widget.onTapDeleteChallenge?.call();
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(24))),
          child: Center(
              child: Icon(
            IconEnum.delete.icon,
            color: red,
          )),
        ),
      ),
    );
  }
}
