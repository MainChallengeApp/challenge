import 'package:challenge/models/challenge/media/stopwatch_media_model.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:flutter/material.dart';

class StopwatchMediaCardComponent extends StatefulWidget {
  final StopwatchMediaModel stopwatchMedia;
  final bool isFullScreen;
  const StopwatchMediaCardComponent({
    super.key,
    required this.stopwatchMedia,
    required this.isFullScreen,
  });

  @override
  State<StopwatchMediaCardComponent> createState() =>
      _StopwatchMediaCardComponentState();
}

class _StopwatchMediaCardComponentState
    extends State<StopwatchMediaCardComponent> {
  @override
  Widget build(BuildContext context) {
    return widget.isFullScreen
        ? SafeArea(
            child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CardComponent.standardSideMargin),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _titleAndContent(),
            ),
          ))
        : CardComponent(
            children: _titleAndContent(),
          );
  }

  List<Widget> _titleAndContent() {
    return [
      Align(
        alignment: Alignment.topLeft,
        child: SpaceColumnComponent(
          heightMultiplier: 0.5,
          child: Text(
            widget.stopwatchMedia.title,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      Expanded(
        child: Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.stopwatchMedia.rounds.reversed
                    .map((round) => Text(
                        '${widget.stopwatchMedia.rounds.indexOf(round) + 1}: ${StopwatchMediaModel.durationToTimeString(round.duration)}'))
                    .toList(),
              ),
            )
            // SingleChildScrollView(
            //   physics: widget.isFullScreen
            //       ? const AlwaysScrollableScrollPhysics()
            //       : const NeverScrollableScrollPhysics(),
            //   child: Text(
            //     widget.stopwatchMedia.rounds.reversed
            //         .map((round) => widget.stopwatchMedia.rounds.indexOf(round) + 1)
            //         .join('\n'),
            //     softWrap: true,
            //     textAlign: TextAlign.justify,
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ),
            ),
      ),
    ];
  }
}
