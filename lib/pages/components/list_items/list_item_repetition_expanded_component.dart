import 'dart:math';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/models/repetition_model.dart';
import 'package:challenge/pages/components/list_items/list_item_button_component.dart';
import 'package:challenge/pages/components/list_items/list_item_container_component.dart';
import 'package:challenge/pages/components/list_items/list_item_fraction_component.dart';
import 'package:challenge/pages/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/pages/components/simple_components/custom_button_component.dart';
import 'package:challenge/pages/components/simple_components/custom_container_component.dart';
import 'package:challenge/pages/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/pages/components/simple_components/space_component.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';

class ListItemRepetitionExpandedComponent extends StatefulWidget {
  const ListItemRepetitionExpandedComponent(
      {super.key,
      required this.repetition,
      this.onTap,
      required this.challenge});

  final RepetitionModel repetition;
  final ChallengeModel challenge;
  final void Function()? onTap;

  @override
  State<ListItemRepetitionExpandedComponent> createState() =>
      _ListItemRepetitionExpandedComponentState();
}

class _ListItemRepetitionExpandedComponentState
    extends State<ListItemRepetitionExpandedComponent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListItemFractionComponent(
          initialProgress:
              min(1, widget.repetition.getLastProgressPercentage()),
          isFailed: widget.repetition.isFailed(widget.challenge),
          onTap: widget.onTap,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [repetitionIcon(), repetition(), progress()],
            ),
          ),
        ),
        ListItemContainerComponent(
          height: 140,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Container(
                height: ListItemContainerComponent.standardHeight -
                    1, // -1 for the border
              ),
              const SpaceComponent(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: Align(
                    alignment: Alignment.bottomLeft,
                    child: CustomContainerComponent(
                      margin:
                          const EdgeInsets.only(left: 10, bottom: 10, right: 5),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: const Text(
                              "Start:",
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          Container(
                            child: Text(
                              "${DesignUtil.getDateAndTimeFormated(widget.repetition.startDate).split(' ')[0]}",
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5, bottom: 10, right: 10),
                        child: CustomButtonComponent(
                            onTap: () => {}, text: 'Next'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SpaceComponent(),
      ],
    );
  }

  repetition() {
    return ContainerInContainerTextComponent(
        text:
            '${widget.repetition.repetitionNumber}/${widget.challenge.frequency.amount ?? '∞'} ${widget.challenge.frequency.dayDaysTimeOrTimes()}');
  }

  progress() {
    return ContainerInContainerTextComponent(
        text:
            '${DesignUtil.doubleAsInt(widget.repetition.getLastProgressProgress())}/${DesignUtil.doubleAsInt(widget.challenge.acceptanceCriteria.amount)} ${widget.challenge.acceptanceCriteria.unit}');
  }

  repetitionIcon() {
    return const IconContainerInListItemComponent(
      icon: Icons.repeat_rounded,
    );
  }
}
