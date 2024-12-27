import 'package:challenge/models/challenge/progress_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../services/faker_service.dart';

ProgressModel mockProgressModel({
  double? progress,
  List<String>? mediaIds,
  DateTime? date,
}) {
  return ProgressModel(
    progress: progress ?? FakerService.decimal(),
    mediaIds: mediaIds ?? FakerService.list((index) => FakerService.guid()),
    date: date ?? FakerService.dateTime(),
  );
}

void main() {
  group('ProgressModel', () {
    group('ProgressModel.empty()', () {
      test('should create progress with default values', () {
        // Arrange
        // Act
        ProgressModel progress = ProgressModel.empty();
        // Assert
        expect(progress.progress, equals(0));
        expect(progress.mediaIds, equals([]));
        expect(progress.date, isNotNull);
      });
    });

    group('fromDocs()', () {
      test('should create list of progress when doc is passed correctly', () {
        // Arrange
        List<Map<String, dynamic>> json = FakerService.list((index) {
          double progress = FakerService.decimal();
          double percentProgress = FakerService.decimal();

          return {
            'progress': progress,
            'mediaIds': FakerService.list((index) => FakerService.guid()),
            'date': Timestamp.fromDate(FakerService.dateTime()),
            'percentProgress': percentProgress
          };
        });
        // Act
        List<ProgressModel> progressList = ProgressModel.fromDocs(json);

        // Assert
        for (int i = 0; i < progressList.length; i++) {
          expect(progressList[i].progress, equals(json[i]['progress']));
          expect(progressList[i].mediaIds, equals(json[i]['mediaIds']));
          expect(progressList[i].date,
              equals((json[i]['date'] as Timestamp).toDate()));
        }
      });
    });

    group('updateProgress()', () {
      test('should update progress', () {
        // Arrange
        ProgressModel progress = mockProgressModel();
        ProgressModel newProgress = mockProgressModel();
        // Act
        progress.updateProgress(newProgress);
        // Assert
        expect(progress.progress, equals(newProgress.progress));
        expect(progress.mediaIds, equals(newProgress.mediaIds));
      });
    });

    group('toDocs()', () {
      test('should create json from progressList', () {
        // Arrange
        List<ProgressModel> progressList =
            FakerService.list((_) => mockProgressModel());
        // Act
        List<Map<String, dynamic>> json = ProgressModel.toDocs(progressList);
        // Assert
        for (int i = 0; i < progressList.length; i++) {
          expect(json[i]['progress'], equals(progressList[i].progress));
          expect(json[i]['mediaIds'], equals(progressList[i].mediaIds));
          expect(json[i]['date'], Timestamp.fromDate(progressList[i].date));
        }
      });
    });

    group('copyProgressList()', () {
      test('should copy progressList', () {
        // Arrange
        List<ProgressModel> progressList =
            FakerService.list((_) => mockProgressModel());
        // Act
        List<ProgressModel> copiedProgressList =
            ProgressModel.copyProgressList(progressList);
        // Assert

        for (int i = 0; i < progressList.length; i++) {
          expect(
              copiedProgressList[i].progress, equals(progressList[i].progress));
          expect(
              copiedProgressList[i].mediaIds, equals(progressList[i].mediaIds));
          expect(copiedProgressList[i].date, equals(progressList[i].date));
        }
      });
    });

    group('copyOrCreateProgress()', () {
      test('should copy progress when progress is not null', () {
        // Arrange
        ProgressModel progress = mockProgressModel();
        // Act
        ProgressModel copiedProgress = ProgressModel.copyOrCreateProgress(
            progress, progress.mediaIds, progress.progress, progress.date);
        // Assert
        expect(copiedProgress.progress, equals(progress.progress));
        expect(copiedProgress.mediaIds, equals(progress.mediaIds));
        expect(copiedProgress.date, equals(progress.date));
      });

      test('should create progress when its null', () {
        // Arrange
        double progress = FakerService.decimal();
        List<String> mediaIds =
            FakerService.list((index) => FakerService.guid());
        DateTime date = FakerService.dateTime();
        // Act
        ProgressModel copiedProgress =
            ProgressModel.copyOrCreateProgress(null, mediaIds, progress, date);
        // Assert
        expect(copiedProgress.progress, equals(progress));
        expect(copiedProgress.mediaIds, equals(mediaIds));
        expect(copiedProgress.date, equals(isNotNull));
      });
    });
  });
}
