import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/progress_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProgressModel', () {
    group('ProgressModel.empty()', () {
      test('should create progress with default values', () {
        // Arrange
        ProgressModel progress = ProgressModel.empty(repetitionNumber: 1);
        // Act
        // Assert
        expect(progress.progress, equals(0));
        expect(progress.mediaIds, equals([]));
        expect(progress.date, isNotNull);
        expect(progress.percentProgress, equals(0));
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
            'repetitionNumber': 1
          }
        ];
        // Act
        List<ProgressModel> progress = ProgressModel.fromJsonList(json);
        // Assert
        expect(progress[0].progress, equals(1.0));
        expect(progress[0].mediaIds, equals(['1', '2', '3']));
        expect(progress[0].percentProgress, equals(1.0));
        expect(progress[0].date, equals(date));
        expect(progress[0].repetitionNumber, equals(1));
      });
    });

    group('setProgress()', () {
      test('should set progress and percentProgress = 1 when amount is 0', () {
        // Arrange
        ProgressModel progress = ProgressModel.empty(repetitionNumber: 1);
        double progressAbsolute = 2.0;
        // Act
        progress.setProgress(
            AcceptanceCriteriaModel.empty(amount: 0), progressAbsolute);
        // Assert
        expect(progress.progress, equals(progressAbsolute));
        expect(progress.percentProgress, equals(1.0));
      });

      test('should set progress and percentProgress when amount is > 0', () {
        // Arrange
        ProgressModel progress = ProgressModel.empty(repetitionNumber: 1);
        double progressAbsolute = 2.0;
        // Act
        progress.setProgress(
            AcceptanceCriteriaModel.empty(amount: 1), progressAbsolute);
        // Assert
        expect(progress.progress, equals(progressAbsolute));
        expect(progress.percentProgress, equals(2.0));
      });

      test('should set progress and percentProgress when amount is > 0', () {
        // Arrange
        ProgressModel progress = ProgressModel.empty(repetitionNumber: 1);
        double progressAbsolute = 2.0;
        // Act
        progress.setProgress(
            AcceptanceCriteriaModel.empty(amount: 4), progressAbsolute);
        // Assert
        expect(progress.progress, equals(progressAbsolute));
        expect(progress.percentProgress, equals(0.5));
      });
    });

    group('updateProgress()', () {
      test('should update progress', () {
        // Arrange
        ProgressModel progress = ProgressModel.empty(repetitionNumber: 1);
        ProgressModel newProgress = ProgressModel(
            progress: 2.0,
            mediaIds: ['1', '2', '3'],
            percentProgress: 1.0,
            date: DateTime.now(),
            repetitionNumber: 1);
        // Act
        progress.updateProgress(newProgress);
        // Assert
        expect(progress.progress, equals(newProgress.progress));
        expect(progress.mediaIds, equals(newProgress.mediaIds));
        expect(progress.percentProgress, equals(newProgress.percentProgress));
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
              percentProgress: 1.0,
              date: progressDate,
              repetitionNumber: 1)
        ];
        // Act
        List<Map<String, dynamic>> json =
            ProgressModel.toJsonList(progressList);
        // Assert
        expect(json[0]['progress'], equals(progressList[0].progress));
        expect(json[0]['mediaIds'], equals(progressList[0].mediaIds));
        expect(json[0]['percentProgress'],
            equals(progressList[0].percentProgress));
        expect(json[0]['date'], progressDate.toString());
        expect(json[0]['repetitionNumber'],
            equals(progressList[0].repetitionNumber));
      });
    });

    group('copyProgressList()', () {
      test('should copy progressList', () {
        // Arrange
        List<ProgressModel> progressList = [
          ProgressModel(
              progress: 1.0,
              mediaIds: ['1', '2', '3'],
              percentProgress: 1.0,
              date: DateTime.now(),
              repetitionNumber: 1)
        ];
        // Act
        List<ProgressModel> copiedProgressList =
            ProgressModel.copyProgressList(progressList);
        // Assert
        expect(
            copiedProgressList[0].progress, equals(progressList[0].progress));
        expect(
            copiedProgressList[0].mediaIds, equals(progressList[0].mediaIds));
        expect(copiedProgressList[0].percentProgress,
            equals(progressList[0].percentProgress));
        expect(copiedProgressList[0].date, equals(progressList[0].date));
        expect(copiedProgressList[0].repetitionNumber,
            equals(progressList[0].repetitionNumber));
      });
    });

    group('copyOrCreateProgress()', () {
      test('should copy progress', () {
        // Arrange
        ProgressModel progress = ProgressModel.empty(repetitionNumber: 1);
        // Act
        ProgressModel copiedProgress = ProgressModel.copyOrCreateProgress(
            progress,
            progress.repetitionNumber,
            progress.mediaIds,
            progress.percentProgress);
        // Assert
        expect(copiedProgress.progress, equals(progress.progress));
        expect(copiedProgress.mediaIds, equals(progress.mediaIds));
        expect(
            copiedProgress.percentProgress, equals(progress.percentProgress));
        expect(copiedProgress.date, equals(progress.date));
        expect(
            copiedProgress.repetitionNumber, equals(progress.repetitionNumber));
      });

      test('should create progress', () {
        // Arrange
        ProgressModel progress = ProgressModel.empty(repetitionNumber: 1);
        progress.progress = 1.0;
        progress.mediaIds = ['1', '2', '3'];
        progress.percentProgress = 1.0;
        progress.date = DateTime.now();
        // Act
        ProgressModel copiedProgress = ProgressModel.copyOrCreateProgress(
            null,
            progress.repetitionNumber,
            progress.mediaIds,
            progress.percentProgress);
        // Assert
        expect(copiedProgress.progress, equals(progress.progress));
        expect(copiedProgress.mediaIds, equals(progress.mediaIds));
        expect(copiedProgress.percentProgress, equals(0));
        expect(copiedProgress.date, equals(isNotNull));
        expect(
            copiedProgress.repetitionNumber, equals(progress.repetitionNumber));
      });
    });
  });
}
