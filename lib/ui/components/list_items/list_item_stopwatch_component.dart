import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/media/stopwatch_media_model.dart';
import 'package:challenge/models/challenge/media/stopwatch_round_model.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class ListItemStopwatchComponent extends StatefulWidget {
  final StopwatchRoundModel round;
  final int roundNumber;
  final bool isShortest;
  final bool isLongest;
  final VoidCallback? onTapDelete;

  const ListItemStopwatchComponent(
      {super.key,
      required this.round,
      required this.roundNumber,
      required this.onTapDelete,
      required this.isShortest,
      required this.isLongest});

  @override
  State<ListItemStopwatchComponent> createState() =>
      _ListItemStopwatchComponentState();
}

class _ListItemStopwatchComponentState
    extends State<ListItemStopwatchComponent> {
  late BuildContext context2;

  bool isTapVisible = false;

  @override
  Widget build(BuildContext context) {
    return ListItemContainerComponent(
      child: Row(
        children: [
          ContainerInContainerTextComponent(
            color: widget.isShortest
                ? Theme.of(context).colorScheme.green
                : widget.isLongest
                    ? Theme.of(context).colorScheme.red
                    : null,
            text: '${widget.roundNumber}',
            textStyle: Theme.of(context).textTheme.titleMedium,
          ),
          const SpaceComponent(),
          Text(
            StopwatchMediaModel.durationToTimeString(widget.round.duration),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Expanded(child: SizedBox()),
          IconButton(
            onPressed: widget.onTapDelete,
            icon: Icon(IconEnum.delete.icon),
            color: Theme.of(context).colorScheme.red,
          ),
        ],
      ),
    );
  }
}
