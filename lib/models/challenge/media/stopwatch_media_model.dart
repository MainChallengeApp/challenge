import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/models/challenge/media/media_model.dart';
import 'package:challenge/models/challenge/media/stopwatch_round_model.dart';
import 'package:uuid/uuid.dart';

class StopwatchMediaModel extends MediaModel {
  List<StopwatchRoundModel> rounds;
  static const String roundsField = 'rounds';

  StopwatchMediaModel({String? id, String? title, this.rounds = const []})
      : super(
            id: id,
            title: title ?? 'Stopwatch',
            type: MediaTypeEnum.stopwatch,
            icon: IconEnum.stopwatch.icon) {
    if (id == null || id.isEmpty) {
      id = const Uuid().v4();
    }
  }

  static fromDoc(doc) {
    return StopwatchMediaModel(
        id: doc[MediaModel.idField],
        title: doc[MediaModel.titleField],
        rounds: doc[roundsField] == null
            ? []
            : List<StopwatchRoundModel>.from(doc[roundsField]
                .map((round) => StopwatchRoundModel.fromDoc(round))
                .toList()));
  }

  @override
  toDoc() {
    return {
      ...super.toDoc(),
      roundsField: rounds.map((round) => round.toDoc()).toList()
    };
  }

  @override
  copy() {
    return StopwatchMediaModel(id: id, title: title, rounds: rounds);
  }

  static String durationToTimeString(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    final milliseconds = duration.inMilliseconds % 1000;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(3, '0').substring(0, 2)}';
  }
}
