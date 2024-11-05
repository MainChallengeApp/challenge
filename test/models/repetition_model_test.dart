import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/exceptions/repetition_status_is_not_supported_exception.dart';
import 'package:challenge/models/challenge/progress_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RepetitionModel', () {
    group('RepetitionModel.empty()', () {
      test('should create empty repetition with default values', () {
        // Act
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        // Assert
        expect(repetition.progressList, equals([]));
        expect(repetition.startDate, isNull);
        expect(repetition.endDate, isNull);
        expect(
            repetition.repetitionStatus, equals(RepetitionStatusEnum.backlog));
      });
    });

    group('isComplete()', () {
      test('should return false when progressList is empty', () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        // Act
        bool result = repetition.isComplete();
        // Assert
        expect(result, isFalse);
      });

      test(
          'should return true when progressList is not empty and last progress is equal to goalAmount',
          () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.progressList.add(ProgressModel.empty(
            repetitionNumber: 1, progress: 1, goal: repetition.goalAmount));
        // Act
        bool result = repetition.isComplete();
        // Assert
        expect(result, isTrue);
      });

      test(
          'should return false when progressList is not empty and last progress is not equal to goalAmount',
          () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.progressList.add(ProgressModel.empty(
            repetitionNumber: 1, progress: 0.5, goal: repetition.goalAmount));
        // Act
        bool result = repetition.isComplete();
        // Assert
        expect(result, isFalse);
      });
    });

    group('isInProgress()', () {
      test(
          'should return true when repetitionStatus is inProgress and startDate is not null',
          () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.repetitionStatus = RepetitionStatusEnum.inProgress;
        repetition.startDate = DateTime.now();
        // Act
        bool result = repetition.isInProgress();
        // Assert
        expect(result, isTrue);
      });

      test('should return false when repetitionStatus is not inProgress', () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.repetitionStatus = RepetitionStatusEnum.failed;
        repetition.startDate = DateTime.now();
        // Act
        bool result = repetition.isInProgress();
        // Assert
        expect(result, isFalse);
      });

      test('should return false when startDate is null', () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.repetitionStatus = RepetitionStatusEnum.inProgress;
        // Act
        bool result = repetition.isInProgress();
        // Assert
        expect(result, isFalse);
      });
    });

    group('isInBacklog()', () {
      test('should return true when repetitionStatus is backlog', () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.repetitionStatus = RepetitionStatusEnum.backlog;
        // Act
        bool result = repetition.isInBacklog();
        // Assert
        expect(result, isTrue);
      });

      test('should return true when startDate is null', () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        // Act
        bool result = repetition.isInBacklog();
        // Assert
        expect(result, isTrue);
      });

      test(
          'should return false when repetitionStatus is not backlog and startDate is not null',
          () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.repetitionStatus = RepetitionStatusEnum.inProgress;
        repetition.startDate = DateTime.now();
        // Act
        bool result = repetition.isInBacklog();
        // Assert
        expect(result, isFalse);
      });
    });

    group('start()', () {
      test(
          'should set startDate to current date and repetitionStatus to inProgress',
          () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        // Act
        repetition.start();
        // Assert
        expect(repetition.startDate, isNotNull);
        expect(repetition.repetitionStatus,
            equals(RepetitionStatusEnum.inProgress));
      });
    });

    group('end()', () {
      test(
          'should set endDate to current date and repetitionStatus to success when repetition is complete',
          () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.progressList.add(ProgressModel.empty(
            repetitionNumber: 1, progress: 1, goal: repetition.goalAmount));
        // Act
        repetition.end();
        // Assert
        expect(repetition.endDate, isNotNull);
        expect(
            repetition.repetitionStatus, equals(RepetitionStatusEnum.success));
      });

      test(
          'should set endDate to current date and repetitionStatus to failed when repetition is not complete',
          () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.progressList.add(ProgressModel.empty(
            repetitionNumber: 1, progress: 0.5, goal: repetition.goalAmount));
        // Act
        repetition.end();
        // Assert
        expect(repetition.endDate, isNotNull);
        expect(
            repetition.repetitionStatus, equals(RepetitionStatusEnum.failed));
      });
    });

    group('evaluateRepetitionStatus()', () {
      test(
          'should set repetitionStatus to success when repetition is complete and endDate is before current date',
          () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.progressList.add(ProgressModel.empty(
            repetitionNumber: 1, progress: 1, goal: repetition.goalAmount));
        repetition.end();
        repetition.endDate = DateTime.now().subtract(const Duration(days: 1));
        // Act
        RepetitionStatusEnum result = repetition.evaluateRepetitionStatus();
        // Assert
        expect(result, equals(RepetitionStatusEnum.success));
        expect(
            repetition.repetitionStatus, equals(RepetitionStatusEnum.success));
      });

      test(
          'should set repetitionStatus to failed when repetition is not complete and endDate is before current date',
          () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.progressList.add(ProgressModel.empty(
            repetitionNumber: 1, progress: 0.5, goal: repetition.goalAmount));
        repetition.end();
        repetition.endDate = DateTime.now().subtract(const Duration(days: 1));
        // Act
        RepetitionStatusEnum result = repetition.evaluateRepetitionStatus();
        // Assert
        expect(result, equals(RepetitionStatusEnum.failed));
        expect(
            repetition.repetitionStatus, equals(RepetitionStatusEnum.failed));
      });

      test(
          'should set repetitionStatus to inProgress when startDate is not null',
          () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.startDate = DateTime.now();
        // Act
        RepetitionStatusEnum result = repetition.evaluateRepetitionStatus();
        // Assert
        expect(result, equals(RepetitionStatusEnum.inProgress));
        expect(repetition.repetitionStatus,
            equals(RepetitionStatusEnum.inProgress));
      });

      test('should set repetitionStatus to backlog when startDate is null', () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        // Act
        RepetitionStatusEnum result = repetition.evaluateRepetitionStatus();
        // Assert
        expect(result, equals(RepetitionStatusEnum.backlog));
        expect(
            repetition.repetitionStatus, equals(RepetitionStatusEnum.backlog));
      });
    });

    group('getLastProgressPercentage()', () {
      test('should return 0 when progressList is empty', () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        // Act
        double result = repetition.getLastProgressPercentage();
        // Assert
        expect(result, equals(0));
      });

      test(
          'should return last progress percentProgress when progressList is not empty',
          () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.progressList.add(ProgressModel.empty(
            repetitionNumber: 1, progress: 0.5, goal: repetition.goalAmount));
        // Act
        double result = repetition.getLastProgressPercentage();
        // Assert
        expect(result, equals(0.5));
      });
    });

    group('getLastProgressAbsolute()', () {
      test('should return 0 when progressList is empty', () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        // Act
        double result = repetition.getLastProgressAbsolute();
        // Assert
        expect(result, equals(0));
      });

      test(
          'should return last progress progress when progressList is not empty',
          () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.progressList.add(ProgressModel.empty(
            repetitionNumber: 1, progress: 0.5, goal: repetition.goalAmount));
        // Act
        double result = repetition.getLastProgressAbsolute();
        // Assert
        expect(result, equals(0.5));
      });
    });

    group('getLastProgress()', () {
      test('should return null when progressList is empty', () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        // Act
        ProgressModel? result = repetition.getLastProgress();
        // Assert
        expect(result, isNull);
      });

      test('should return last progress when progressList is not empty', () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        ProgressModel progress = ProgressModel.empty(
            repetitionNumber: 1, progress: 0.5, goal: repetition.goalAmount);
        repetition.progressList.add(progress);
        // Act
        ProgressModel? result = repetition.getLastProgress();
        // Assert
        expect(result, equals(progress));
      });
    });

    group('addProgress()', () {
      test('should add empty progress when progress is null', () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        // Act
        ProgressModel result = repetition.addProgress();
        // Assert
        expect(result.repetitionNumber, equals(1));
        expect(result.progress, equals(0));
      });

      test('should add progress when progress is not null', () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        ProgressModel progress =
            ProgressModel.empty(repetitionNumber: 1, progress: 0.5, goal: 1);
        // Act
        ProgressModel result = repetition.addProgress(progress: progress);
        // Assert
        expect(result, equals(progress));
      });
    });

    group('toDoc()', () {
      test('should return a repetition as json', () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.progressList.add(
            ProgressModel.empty(repetitionNumber: 1, progress: 0.5, goal: 1));
        repetition.startDate = DateTime.now();
        repetition.endDate = DateTime.now().add(const Duration(days: 1));
        repetition.repetitionStatus = RepetitionStatusEnum.inProgress;

        // Act
        Map<String, dynamic> result = repetition.toDoc();
        // Assert
        expect(result['repetitionNumber'], equals(1));
        expect(result['goalAmount'], equals(1));
        expect(result['progressList'],
            equals(ProgressModel.toDocs(repetition.progressList)));
        expect(result['startDate'], equals(repetition.startDate.toString()));
        expect(result['endDate'], equals(repetition.endDate.toString()));
        expect(result['repetitionStatus'],
            equals(repetition.repetitionStatus.status));
      });
    });

    group('fromJsonList()', () {
      test('should return list of repetitions from json', () {
        // Arrange
        Map<String, dynamic> json1 = {
          'repetitionNumber': 1,
          'goalAmount': 1.0,
          'progressList': [
            {
              'repetitionNumber': 1,
              'progress': 0.5,
              'mediaIds': [],
              'percentProgress': 0.5,
              'date': DateTime.now().toString(),
              'goal': 1.0
            }
          ],
          'startDate': DateTime.now().toString(),
          'endDate': DateTime.now().add(const Duration(days: 1)).toString(),
          'repetitionStatus': RepetitionStatusEnum.inProgress.status
        };

        Map<String, dynamic> json2 = {
          'repetitionNumber': 2,
          'goalAmount': 2.0,
          'progressList': [
            {
              'repetitionNumber': 2,
              'progress': 1.0,
              'mediaIds': [],
              'percentProgress': 1.0,
              'date': DateTime.now().toString(),
              'goal': 2.0
            }
          ],
          'startDate':
              DateTime.now().subtract(const Duration(days: 1)).toString(),
          'endDate':
              DateTime.now().subtract(const Duration(days: 1)).toString(),
          'repetitionStatus': RepetitionStatusEnum.failed.status
        };

        List<Map<String, dynamic>> json = [json1, json2];
        // Act
        List<RepetitionModel> result = RepetitionModel.fromDocs(json);
        // Assert
        expect(result.length, equals(2));
        expect(result[0].repetitionNumber, equals(1));
        expect(result[0].goalAmount, equals(1));
        expect(result[0].progressList.length, equals(1));
        expect(result[0].progressList[0].repetitionNumber, equals(1));
        expect(result[0].progressList[0].progress, equals(0.5));
        expect(result[0].startDate, equals(DateTime.parse(json1['startDate'])));
        expect(result[0].endDate, equals(DateTime.parse(json1['endDate'])));
        expect(result[0].repetitionStatus,
            equals(RepetitionStatusEnum.inProgress));

        expect(result[1].repetitionNumber, equals(2));
        expect(result[1].goalAmount, equals(2));
        expect(result[1].progressList.length, equals(1));
        expect(result[1].progressList[0].repetitionNumber, equals(2));
      });

      test('should throw repetition status is not supported exception', () {
        // Arrange
        Map<String, dynamic> json = {
          'repetitionNumber': 1,
          'goalAmount': 1.0,
          'progressList': [],
          'startDate': DateTime.now().toString(),
          'endDate': DateTime.now().add(const Duration(days: 1)).toString(),
          'repetitionStatus': 'not supported status'
        };
        // Act
        // Assert
        expect(() => RepetitionModel.fromDocs([json]),
            throwsA(isA<RepetitionStatusIsNotSupportedException>()));
      });
    });

    group('copyRepetition()', () {
      test('should return a copy of the repetition', () {
        // Arrange
        DateTime repetitionStartDate = DateTime.now();
        DateTime repetitionEndDate =
            DateTime.now().add(const Duration(days: 1));

        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition.progressList.add(
            ProgressModel.empty(repetitionNumber: 1, progress: 0.5, goal: 1));
        repetition.startDate = repetitionStartDate;
        repetition.endDate = repetitionEndDate;
        repetition.repetitionStatus = RepetitionStatusEnum.inProgress;
        // Act
        RepetitionModel result = repetition.copy();
        // Assert
        expect(result.repetitionNumber, equals(repetition.repetitionNumber));
        expect(result.goalAmount, equals(repetition.goalAmount));
        expect(result.progressList.toString(),
            equals(repetition.progressList.toString()));
        expect(result.startDate, equals(repetitionStartDate));
        expect(result.endDate, equals(repetitionEndDate));
        expect(result.repetitionStatus, equals(repetition.repetitionStatus));
      });
    });

    group('copyRepetitionList()', () {
      test('should return a copy of the list of repetitions', () {
        // Arrange
        DateTime repetitionStartDate = DateTime.now();
        DateTime repetitionEndDate =
            DateTime.now().add(const Duration(days: 1));

        RepetitionModel repetition1 =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        repetition1.progressList.add(
            ProgressModel.empty(repetitionNumber: 1, progress: 0.5, goal: 1));
        repetition1.startDate = repetitionStartDate;
        repetition1.endDate = repetitionEndDate;
        repetition1.repetitionStatus = RepetitionStatusEnum.inProgress;

        RepetitionModel repetition2 =
            RepetitionModel.empty(repetitionNumber: 2, goalAmount: 2);
        repetition2.progressList.add(
            ProgressModel.empty(repetitionNumber: 2, progress: 1, goal: 1));
        repetition2.startDate =
            DateTime.now().subtract(const Duration(days: 1));
        repetition2.endDate = DateTime.now().subtract(const Duration(days: 1));
        repetition2.repetitionStatus = RepetitionStatusEnum.failed;

        List<RepetitionModel> repetitions = [repetition1, repetition2];
        // Act
        List<RepetitionModel> result = RepetitionModel.copyList(repetitions);
        // Assert
        expect(result.length, equals(2));
        expect(
            result[0].repetitionNumber, equals(repetition1.repetitionNumber));
        expect(result[0].goalAmount, equals(repetition1.goalAmount));
        expect(result[0].progressList.toString(),
            equals(repetition1.progressList.toString()));
        expect(result[0].startDate, equals(repetitionStartDate));
        expect(result[0].endDate, equals(repetitionEndDate));
        expect(
            result[0].repetitionStatus, equals(repetition1.repetitionStatus));

        expect(
            result[1].repetitionNumber, equals(repetition2.repetitionNumber));
        expect(result[1].goalAmount, equals(repetition2.goalAmount));
        expect(result[1].progressList.toString(),
            equals(repetition2.progressList.toString()));
        expect(result[1].startDate, equals(repetition2.startDate));
        expect(result[1].endDate, equals(repetition2.endDate));
        expect(
            result[1].repetitionStatus, equals(repetition2.repetitionStatus));
      });
    });

    group('deleteProgress()', () {
      test('should delete progress from progressList', () {
        // Arrange
        RepetitionModel repetition =
            RepetitionModel.empty(repetitionNumber: 1, goalAmount: 1);
        ProgressModel progress =
            ProgressModel.empty(repetitionNumber: 1, progress: 0.5, goal: 1);
        repetition.progressList.add(progress);
        // Act
        repetition.deleteProgress(progress);
        // Assert
        expect(repetition.progressList, isEmpty);
      });
    });
  });
}
