import 'package:challenge/models/challenge/media/stopwatch_round_entry_model.dart';

class StopwatchRoundModel {
  List<StopwatchRoundEntryModel> entries;
  static const String entriesField = 'entries';

  StopwatchRoundModel({required this.entries});

  Duration get duration =>
      entries.fold(Duration.zero, (a, b) => a + b.duration);

  static fromDoc(doc) {
    return StopwatchRoundModel(
        entries: doc[entriesField] == null
            ? []
            : List<StopwatchRoundEntryModel>.from(doc[entriesField]
                .map((entry) => StopwatchRoundEntryModel.fromDoc(entry))
                .toList()));
  }

  toDoc() {
    return {
      entriesField: entries.map((entry) => entry.toDoc()).toList(),
    };
  }
}
