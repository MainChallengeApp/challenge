import 'package:challenge/models/progress_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProgressModel', () {
    group('ProgressModel.empty()', () {
      test('should create progress with default values', () {
        // Arrange
        ProgressModel progress =
            ProgressModel.empty(repetitionNumber: 1, goal: 1.0);
        // Act
        // Assert
        expect(progress.progress, equals(0));
        expect(progress.mediaIds, equals([]));
        expect(progress.date, isNotNull);
        expect(progress.repetitionNumber, equals(1));
      });
    });

    group('fromJsonList()', () {
      test('should create progress when json is passed correctly', () {
        // Arrange
        DateTime date = DateTime.now();
        List<Map<String, dynamic>> json = [
          {
            'progress': 1.0,
            'mediaIds': ['1', '2', '3'],
            'percentProgress': 1.0,
            'date': date.toString(),
            'repetitionNumber': 1,
            'goal': 1.0
          }
        ];
        // Act
        List<ProgressModel> progress = ProgressModel.fromJsonList(json);
        // Assert
        expect(progress[0].progress, equals(1.0));
        expect(progress[0].mediaIds, equals(['1', '2', '3']));
        expect(progress[0].date, equals(date));
        expect(progress[0].repetitionNumber, equals(1));
        expect(progress[0].goal, equals(1.0));
      });
    });

    group('updateProgress()', () {
      test('should update progress', () {
        // Arrange
        ProgressModel progress =
            ProgressModel.empty(repetitionNumber: 1, goal: 2);
        ProgressModel newProgress = ProgressModel(
            progress: 2.0,
            mediaIds: ['1', '2', '3'],
            date: DateTime.now(),
            repetitionNumber: 1,
            goal: 1);
        // Act
        progress.updateProgress(newProgress);
        // Assert
        expect(progress.progress, equals(newProgress.progress));
        expect(progress.mediaIds, equals(newProgress.mediaIds));
        expect(progress.goal, equals(newProgress.goal));
      });
    });

    group('toJsonList()', () {
      test('should create json from progressList', () {
        // Arrange
        DateTime progressDate = DateTime.now();
        List<ProgressModel> progressList = [
          ProgressModel(
              progress: 1.0,
              mediaIds: ['1', '2', '3'],
              date: progressDate,
              repetitionNumber: 1,
              goal: 1.0)
        ];
        // Act
        List<Map<String, dynamic>> json =
            ProgressModel.toJsonList(progressList);
        // Assert
        expect(json[0]['progress'], equals(progressList[0].progress));
        expect(json[0]['mediaIds'], equals(progressList[0].mediaIds));
        expect(json[0]['date'], progressDate.toString());
        expect(json[0]['repetitionNumber'],
            equals(progressList[0].repetitionNumber));
        expect(json[0]['goal'], equals(progressList[0].goal));
      });
    });

    group('copyProgressList()', () {
      test('should copy progressList', () {
        // Arrange
        List<ProgressModel> progressList = [
          ProgressModel(
              progress: 1.0,
              mediaIds: ['1', '2', '3'],
              date: DateTime.now(),
              repetitionNumber: 1,
              goal: 1.0)
        ];
        // Act
        List<ProgressModel> copiedProgressList =
            ProgressModel.copyProgressList(progressList);
        // Assert
        expect(
            copiedProgressList[0].progress, equals(progressList[0].progress));
        expect(
            copiedProgressList[0].mediaIds, equals(progressList[0].mediaIds));
        expect(copiedProgressList[0].date, equals(progressList[0].date));
        expect(copiedProgressList[0].repetitionNumber,
            equals(progressList[0].repetitionNumber));
      });
    });

    group('copyOrCreateProgress()', () {
      test('should copy progress', () {
        // Arrange
        ProgressModel progress =
            ProgressModel.empty(repetitionNumber: 1, goal: 1);
        // Act
        ProgressModel copiedProgress = ProgressModel.copyOrCreateProgress(
            progress,
            progress.repetitionNumber,
            progress.goal,
            progress.mediaIds,
            progress.progress);
        // Assert
        expect(copiedProgress.progress, equals(progress.progress));
        expect(copiedProgress.mediaIds, equals(progress.mediaIds));
        expect(copiedProgress.date, equals(progress.date));
        expect(
            copiedProgress.repetitionNumber, equals(progress.repetitionNumber));
      });

      test('should create progress', () {
        // Arrange
        ProgressModel progress =
            ProgressModel.empty(repetitionNumber: 1, goal: 1);
        progress.progress = 1.0;
        progress.mediaIds = ['1', '2', '3'];
        progress.date = DateTime.now();
        // Act
        ProgressModel copiedProgress = ProgressModel.copyOrCreateProgress(
            null,
            progress.repetitionNumber,
            progress.goal,
            progress.mediaIds,
            progress.progress);
        // Assert
        expect(copiedProgress.progress, equals(progress.progress));
        expect(copiedProgress.mediaIds, equals(progress.mediaIds));
        expect(copiedProgress.goal, equals(progress.goal));
        expect(copiedProgress.date, equals(isNotNull));
        expect(
            copiedProgress.repetitionNumber, equals(progress.repetitionNumber));
      });
    });
  });
}
