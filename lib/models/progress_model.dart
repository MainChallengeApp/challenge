class ProgressModel {
  DateTime date;
  final int frequencyAmount;
  double progress;
  double percentProgress;
  List<String> mediaIds;

  ProgressModel(
      {required this.progress,
      required this.mediaIds,
      required this.date,
      required this.percentProgress,
      required this.frequencyAmount});

  static fromJsonList(json) {
    List<ProgressModel> progressList = [];
    json?.forEach((e) => progressList.add(ProgressModel(
        progress: e['progress'],
        mediaIds: List.from(e['mediaIds']),
        percentProgress: e['percentProgress'],
        date: DateTime.parse(e['date']),
        frequencyAmount: e['frequencyAmount'])));
    return progressList;
  }

  static toJsonList(List<ProgressModel> progressList) {
    return progressList
        .map((progress) => {
              'date': progress.date.toString(),
              'progress': progress.progress,
              'percentProgress': progress.percentProgress,
              'mediaIds': progress.mediaIds,
              'frequencyAmount': progress.frequencyAmount
            })
        .toList();
  }
}
