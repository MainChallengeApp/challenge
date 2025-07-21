import 'dart:async';

import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media/media_model.dart';
import 'package:challenge/models/challenge/media/stopwatch_media_model.dart';
import 'package:challenge/models/challenge/media/stopwatch_round_entry_model.dart';
import 'package:challenge/models/challenge/media/stopwatch_round_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_stopwatch_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/bottom_buttons_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/home/repetition/progress_media_list_page.dart';
import 'package:flutter/material.dart';

class MediaStopwatchPage extends StatefulWidget {
  final AttemptModel attempt;
  final GroupChallengeModel groupChallenge;
  final ParticipantModel participant;

  const MediaStopwatchPage({
    Key? key,
    required this.attempt,
    required this.groupChallenge,
    required this.participant,
  }) : super(key: key);

  @override
  State<MediaStopwatchPage> createState() => _MediaStopwatchPageState();
}

class _MediaStopwatchPageState extends State<MediaStopwatchPage> {
  Timer? _timer;
  bool _isStopwatchRunning = false;
  final StopwatchMediaModel _stopwatchMedia = StopwatchMediaModel();

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
      appBar: const AppBarComponent(
        title: 'Stopwatch',
      ),
      isBottomNavigationVisible: false,
      body: Column(
        children: [
          Expanded(
              child: Column(
            children: [_stopwatchAndButtons(), _roundsList()],
          )),
          _actionButtons(),
        ],
      ),
    );
  }

  BottomButtonsComponent _actionButtons() {
    return BottomButtonsComponent(
      buttons: [
        _cancelButton(),
        _acceptButton(),
      ],
    );
  }

  Expanded _roundsList() {
    if (_stopwatchMedia.rounds.isEmpty) {
      return const Expanded(child: SizedBox());
    }

    final shortestDurationIndex = _stopwatchMedia.rounds.indexOf(_stopwatchMedia
        .rounds
        .reduce((a, b) => a.duration < b.duration ? a : b));
    final longestDurationIndex = _stopwatchMedia.rounds.indexOf(_stopwatchMedia
        .rounds
        .reduce((a, b) => a.duration > b.duration ? a : b));

    return Expanded(
      child: ListView(
        children: [
          ..._stopwatchMedia.rounds.reversed
              .map((round) => _roundEntry(
                  round, shortestDurationIndex, longestDurationIndex))
              .toList(),
        ],
      ),
    );
  }

  SpaceColumnComponent _roundEntry(StopwatchRoundModel round,
      int shortestDurationIndex, int longestDurationIndex) {
    return SpaceColumnComponent(
      child: ListItemStopwatchComponent(
        round: round,
        roundNumber: _stopwatchMedia.rounds.indexOf(round) + 1,
        onTapDelete: () => _onTapDeleteRound(round),
        isShortest: _stopwatchMedia.rounds.length > 1 &&
            _stopwatchMedia.rounds.indexOf(round) == shortestDurationIndex,
        isLongest: _stopwatchMedia.rounds.length > 1 &&
            _stopwatchMedia.rounds.indexOf(round) == longestDurationIndex,
      ),
    );
  }

  void _onTapDeleteRound(StopwatchRoundModel round) {
    final isLastRound = _stopwatchMedia.rounds.last == round;
    _stopwatchMedia.rounds.removeAt(_stopwatchMedia.rounds.indexOf(round));
    if (_stopwatchMedia.rounds.isEmpty) {
      _isStopwatchRunning = false;
    } else if (isLastRound && _isStopwatchRunning) {
      _onTapStart();
    }
    setState(() {});
  }

  _stopwatchAndButtons() {
    return SpaceColumnComponent(
      child: ListItemContainerComponent(
        isHeightDynamic: true,
        padding: const EdgeInsets.all(CardComponent.standardPadding),
        child: Column(
          children: [
            Text(
              _stopwatchDuration(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontFeatures: const [
                  FontFeature.tabularFigures(),
                ],
              ),
            ),
            const SpaceComponent(),
            Row(
              children: [
                Expanded(child: _resetAndRoundButton()),
                const SpaceComponent(),
                Expanded(child: _startAndStopButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _cancelButton() {
    return ListItemButtonComponent(
      onTap: _onTapCancel,
      text: 'Cancel',
      isMainButton: false,
      margin: EdgeInsets.zero,
    );
  }

  _acceptButton() {
    return ListItemButtonComponent(
      onTap: _onTapAccept,
      text: 'Accept',
      isMainButton: true,
      margin: EdgeInsets.zero,
    );
  }

  void _onTapCancel() {
    Navigator.pop(context);
  }

  void _onTapAccept() {
    if (_isStopwatchRunning) {
      _onTapStop();
    }
    _stopwatchMedia.title = 'Stopwatch: ${_stopwatchDuration()}';
    widget.attempt.addMedia(_stopwatchMedia);
    List<MediaModel> initialMediaList = [_stopwatchMedia];
    Navigator.push(context, MaterialPageRoute(builder: (builder) {
      return ProgressMediaListPage(
        attempt: widget.attempt,
        groupChallenge: widget.groupChallenge,
        participant: widget.participant,
        initialMediaList: initialMediaList,
        isEditableByUser: true,
        amountOfPops: 2,
      );
    }));
  }

  String _stopwatchDuration() {
    if (_stopwatchMedia.rounds.isEmpty) {
      return '00:00:00.00';
    }

    final duration = _stopwatchMedia.getDuration();
    return StopwatchMediaModel.durationToTimeString(duration);
  }

  _startAndStopButton() {
    return CustomButtonComponent(
      onTap: () {
        if (!_isStopwatchRunning) {
          _onTapStart();
        } else {
          _onTapStop();
        }
      },
      text: _isStopwatchRunning ? 'Stop' : 'Start',
      margin: EdgeInsets.zero,
      isPrimaryButton: !_isStopwatchRunning,
    );
  }

  void _onTapStart() {
    setState(() {
      _isStopwatchRunning = true;
      if (_stopwatchMedia.rounds.isEmpty) {
        _stopwatchMedia.rounds.add(StopwatchRoundModel(
            entries: [StopwatchRoundEntryModel(startTime: TimeService.now())]));
      } else {
        _stopwatchMedia.rounds.last.entries
            .add(StopwatchRoundEntryModel(startTime: TimeService.now()));
      }
    });
    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _onTapStop() {
    _timer?.cancel();
    setState(() {
      _isStopwatchRunning = false;
      _stopwatchMedia.rounds.last.entries.last.stopTime = TimeService.now();
    });
  }

  _resetAndRoundButton() {
    return CustomButtonComponent(
      onTap: () {
        setState(() {
          if (_isStopwatchRunning) {
            _stopwatchMedia.rounds.last.entries.last.stopTime =
                TimeService.now();
            _stopwatchMedia.rounds.add(StopwatchRoundModel(entries: [
              StopwatchRoundEntryModel(startTime: TimeService.now())
            ]));
          } else {
            _stopwatchMedia.rounds.clear();
            _timer?.cancel();
            _isStopwatchRunning = false;
          }
        });
      },
      text: _isStopwatchRunning ? 'Round' : 'Reset',
      margin: EdgeInsets.zero,
      isPrimaryButton: false,
    );
  }
}
