import 'dart:async';

import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media/media_model.dart';
import 'package:challenge/models/challenge/media/stopwatch_media_model.dart';
import 'package:challenge/models/challenge/media/stopwatch_round_entry_model.dart';
import 'package:challenge/models/challenge/media/stopwatch_round_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
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
  final StopwatchMediaModel stopwatchMedia;

  const MediaStopwatchPage({
    Key? key,
    required this.attempt,
    required this.groupChallenge,
    required this.participant,
    required this.stopwatchMedia,
  }) : super(key: key);

  @override
  State<MediaStopwatchPage> createState() => _MediaStopwatchPageState();
}

class _MediaStopwatchPageState extends State<MediaStopwatchPage> {
  final List<StopwatchRoundModel> _rounds = [];
  Timer? _timer;
  bool _isStopwatchRunning = false;

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
            children: [
              _stopwatchAndButtons(context),
              const SpaceComponent(),
              _roundsList()
            ],
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
    if (_rounds.isEmpty) {
      return const Expanded(child: SizedBox());
    }

    final shortestDurationIndex = _rounds
        .indexOf(_rounds.reduce((a, b) => a.duration < b.duration ? a : b));
    final longestDurationIndex = _rounds
        .indexOf(_rounds.reduce((a, b) => a.duration > b.duration ? a : b));

    return Expanded(
      child: ListView(
        children: [
          ..._rounds.reversed
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
        roundNumber: _rounds.indexOf(round) + 1,
        onTapDelete: () {
          _rounds.removeAt(_rounds.indexOf(round));
          if (_rounds.isEmpty) {
            _isStopwatchRunning = false;
          }
          setState(() {});
        },
        isShortest: _rounds.length > 1 &&
            _rounds.indexOf(round) == shortestDurationIndex,
        isLongest: _rounds.length > 1 &&
            _rounds.indexOf(round) == longestDurationIndex,
      ),
    );
  }

  ListItemContainerComponent _stopwatchAndButtons(BuildContext context) {
    return ListItemContainerComponent(
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
    widget.stopwatchMedia.rounds = _rounds;
    widget.stopwatchMedia.title = 'Stopwatch: ${_stopwatchDuration()}';
    widget.attempt.addMedia(widget.stopwatchMedia);
    List<MediaModel> initialMediaList = [widget.stopwatchMedia];
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
    if (_rounds.isEmpty) {
      return '00:00:00.00';
    }

    final duration = _rounds.fold(Duration.zero, (a, b) => a + b.duration);
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
      if (_rounds.isEmpty) {
        _rounds.add(StopwatchRoundModel(
            entries: [StopwatchRoundEntryModel(startTime: DateTime.now())]));
      } else {
        _rounds.last.entries
            .add(StopwatchRoundEntryModel(startTime: DateTime.now()));
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
      _rounds.last.entries.last.stopTime = DateTime.now();
    });
  }

  _resetAndRoundButton() {
    return CustomButtonComponent(
      onTap: () {
        setState(() {
          if (_isStopwatchRunning) {
            _rounds.last.entries.last.stopTime = DateTime.now();
            _rounds.add(StopwatchRoundModel(entries: [
              StopwatchRoundEntryModel(startTime: DateTime.now())
            ]));
          } else {
            _rounds.clear();
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
