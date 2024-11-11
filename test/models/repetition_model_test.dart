import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/exceptions/repetition_status_is_not_supported_exception.dart';
import 'package:challenge/models/challenge/progress_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:challenge/services/time_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../services/faker_service.dart';
import 'acceptance_criteria_model_test.dart';
import 'attempt_model_test.dart';
import 'group_challenge_model_test.dart';
import 'progress_model_test.dart';

RepetitionModel mockRepetitionModel(
    {int? repetitionNumber,
    double? goalAmount,
    List<ProgressModel>? progressList,
    DateTime? startDate,
    DateTime? endDate,
    RepetitionStatusEnum? repetitionStatus}) {
  int actualRepetitionNumber = repetitionNumber ?? FakerService.integer();

  return RepetitionModel(
      repetitionNumber: actualRepetitionNumber,
      goalAmount: goalAmount ?? FakerService.decimal(),
      progressList: progressList ??
          FakerService.list((_) =>
              mockProgressModel(repetitionNumber: actualRepetitionNumber)),
      startDate: startDate ?? FakerService.dateTime(),
      endDate: endDate ?? FakerService.dateTime(),
      repetitionStatus: repetitionStatus ??
          FakerService.randomObject(RepetitionStatusEnum.values));
}

void main() {
  group('RepetitionModel', () {
    group('RepetitionModel.empty()', () {
      test('should create empty repetition with default values', () {
        // Act
        int repetitionNumber = FakerService.integer();
        double goalAmount = FakerService.decimal();
        RepetitionModel repetition = RepetitionModel.empty(
            repetitionNumber: repetitionNumber, goalAmount: goalAmount);
        // Assert
        expect(repetition.progressList, equals([]));
        expect(repetition.startDate, isNull);
        expect(repetition.endDate, isNull);
        expect(
            repetition.repetitionStatus, equals(RepetitionStatusEnum.backlog));
        expect(repetition.repetitionNumber, equals(repetitionNumber));
        expect(repetition.goalAmount, equals(goalAmount));
      });
    });

    group('isComplete()', () {
      test('should return false when progressList is empty', () {
        // Arrange
        RepetitionModel repetition = mockRepetitionModel(progressList: []);
        // Act
        bool result = repetition.isComplete();
        // Assert
        expect(result, isFalse);
      });

      test(
          'should return true when progressList is not empty and last progress is equal or greater then goalAmount',
          () {
        // Arrange
        double goalAmount = FakerService.decimal();
        RepetitionModel repetition = mockRepetitionModel(
            progressList: [mockProgressModel(progress: goalAmount)],
            goalAmount: goalAmount);
        // Act
        bool result = repetition.isComplete();
        // Assert
        expect(result, isTrue);
      });

      test(
          'should return false when progressList is not empty and last progress is not equal to goalAmount',
          () {
        // Arrange
        double goalAmount = FakerService.decimal();
        RepetitionModel repetition = mockRepetitionModel(
            progressList: [mockProgressModel(progress: goalAmount - 1)],
            goalAmount: goalAmount);
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
        RepetitionModel repetition = mockRepetitionModel(
            repetitionStatus: RepetitionStatusEnum.inProgress,
            startDate: TimeService.now());
        // Act
        bool result = repetition.isInProgress();
        // Assert
        expect(result, isTrue);
      });

      test('should return false when repetitionStatus is not inProgress', () {
        // Arrange
        RepetitionModel repetition = mockRepetitionModel(
            repetitionStatus: FakerService.randomObject(RepetitionStatusEnum
                .values
                .where((repetitionStatus) =>
                    repetitionStatus != RepetitionStatusEnum.inProgress)
                .toList()));
        // Act
        bool result = repetition.isInProgress();
        // Assert
        expect(result, isFalse);
      });

      test('should return false when startDate is null', () {
        // Arrange
        RepetitionModel repetition = mockRepetitionModel();
        repetition.startDate = null;
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
            mockRepetitionModel(repetitionStatus: RepetitionStatusEnum.backlog);
        // Act
        bool result = repetition.isInBacklog();
        // Assert
        expect(result, isTrue);
      });

      test('should return true when startDate is null', () {
        // Arrange
        RepetitionModel repetition = mockRepetitionModel();
        repetition.startDate = null;
        // Act
        bool result = repetition.isInBacklog();
        // Assert
        expect(result, isTrue);
      });

      test(
          'should return false when repetitionStatus is not backlog and startDate is not null',
          () {
        // Arrange
        RepetitionModel repetition = mockRepetitionModel(
            repetitionStatus: RepetitionStatusEnum.inProgress);
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
            mockRepetitionModel(repetitionStatus: RepetitionStatusEnum.backlog);
        repetition.startDate = null;
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
        double goalAmount = FakerService.decimal();
        RepetitionModel repetition = mockRepetitionModel(
            progressList: [mockProgressModel(progress: goalAmount)],
            goalAmount: goalAmount);
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
        RepetitionModel repetition = mockRepetitionModel(progressList: []);
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
        double goalAmount = FakerService.decimal();
        RepetitionModel repetition = mockRepetitionModel(
            progressList: [mockProgressModel(progress: goalAmount)],
            goalAmount: goalAmount,
            endDate: TimeService.now().subtract(const Duration(days: 1)));
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
        RepetitionModel repetition = mockRepetitionModel(
            progressList: [],
            endDate: TimeService.now().subtract(const Duration(days: 1)));
        // Act
        RepetitionStatusEnum result = repetition.evaluateRepetitionStatus();
        // Assert
        expect(result, equals(RepetitionStatusEnum.failed));
        expect(
            repetition.repetitionStatus, equals(RepetitionStatusEnum.failed));
      });

      test(
          'should set repetitionStatus to inProgress when startDate is not null and endDate is null',
          () {
        // Arrange
        RepetitionModel repetition = mockRepetitionModel(
            progressList: [],
            startDate: TimeService.now().subtract(const Duration(days: 1)));
        repetition.endDate = null;
        // Act
        RepetitionStatusEnum result = repetition.evaluateRepetitionStatus();
        // Assert
        expect(result, equals(RepetitionStatusEnum.inProgress));
        expect(repetition.repetitionStatus,
            equals(RepetitionStatusEnum.inProgress));
      });

      test('should set repetitionStatus to backlog when startDate is null', () {
        // Arrange
        RepetitionModel repetition = mockRepetitionModel();
        repetition.startDate = null;
        repetition.endDate = null;
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
        RepetitionModel repetition = mockRepetitionModel(progressList: []);
        // Act
        double result = repetition.getLastProgressPercentage(
            mockGroupChallengeModel(), mockAttemptModel());
        // Assert
        expect(result, equals(0));
      });

      test(
          'should return last progress percentProgress when progressList is not empty',
          () {
        // Arrange
        double progress = FakerService.decimal();
        double goalAmount = FakerService.decimal(min: progress);
        double percentProgress = progress / goalAmount;

        RepetitionModel repetition = mockRepetitionModel(
            progressList: [mockProgressModel(progress: progress)],
            goalAmount: goalAmount);
        // Act
        double result = repetition.getLastProgressPercentage(
            mockGroupChallengeModel(
                acceptanceCriteria:
                    mockAcceptanceCriteriaModel(amount: goalAmount)),
            mockAttemptModel(
                acceptanceCriteria:
                    mockAcceptanceCriteriaModel(amount: goalAmount)));
        // Assert
        expect(result, equals(percentProgress));
      });
    });

    group('getLastProgressAbsolute()', () {
      test('should return 0 when progressList is empty', () {
        // Arrange
        RepetitionModel repetition = mockRepetitionModel(progressList: []);
        // Act
        double result = repetition.getLastProgressAbsolute();
        // Assert
        expect(result, equals(0));
      });

      test(
          'should return last progress progress when progressList is not empty',
          () {
        // Arrange
        double progress = FakerService.decimal();
        RepetitionModel repetition = mockRepetitionModel(
            progressList: [mockProgressModel(progress: progress)]);
        // Act
        double result = repetition.getLastProgressAbsolute();
        // Assert
        expect(result, equals(progress));
      });
    });

    group('getLastProgress()', () {
      test('should return null when progressList is empty', () {
        // Arrange
        RepetitionModel repetition = mockRepetitionModel(progressList: []);
        // Act
        ProgressModel? result = repetition.getLastProgress();
        // Assert
        expect(result, isNull);
      });

      test('should return last progress when progressList is not empty', () {
        // Arrange
        ProgressModel progress = mockProgressModel();
        RepetitionModel repetition =
            mockRepetitionModel(progressList: [progress]);
        // Act
        ProgressModel? result = repetition.getLastProgress();
        // Assert
        expect(result, equals(progress));
      });
    });

    group('addProgress()', () {
      test('should add empty progress when passed progress is null', () {
        // Arrange
        RepetitionModel repetition = mockRepetitionModel();
        // Act
        ProgressModel result = repetition.addProgress();
        // Assert
        expect(result.repetitionNumber, equals(repetition.repetitionNumber));
        expect(result.progress, equals(0));
      });

      test('should add passed progress when passed progress is not null', () {
        // Arrange
        RepetitionModel repetition = mockRepetitionModel();
        ProgressModel progress = mockProgressModel();
        // Act
        repetition.addProgress(progress: progress);
        // Assert
        expect(repetition.progressList.contains(progress), isTrue);
      });
    });

    group('toDoc()', () {
      test('should return a repetition as doc', () {
        // Arrange
        RepetitionModel repetition = mockRepetitionModel();
        // Act
        Map<String, dynamic> result = repetition.toDoc();
        // Assert
        expect(result[RepetitionModel.repetitionNumberField],
            equals(repetition.repetitionNumber));
        expect(result[RepetitionModel.goalAmountField],
            equals(repetition.goalAmount));
        expect(result[RepetitionModel.progressListField],
            equals(ProgressModel.toDocs(repetition.progressList)));
        expect(
            result[RepetitionModel.startDateField],
            repetition.startDate == null
                ? null
                : Timestamp.fromDate(repetition.startDate!));
        expect(
            result[RepetitionModel.endDateField],
            repetition.endDate == null
                ? null
                : Timestamp.fromDate(repetition.endDate!));
        expect(result[RepetitionModel.repetitionStatusField],
            equals(repetition.repetitionStatus.status));
      });
    });

    group('fromJsonList()', () {
      test('should return list of repetitions from json', () {
        // Arrange
        List<RepetitionModel> repetitions =
            FakerService.list((_) => mockRepetitionModel());
        List<Map<String, dynamic>> doc =
            repetitions.map((e) => e.toDoc()).toList();
        // Act
        List<RepetitionModel> result = RepetitionModel.fromDocs(doc);
        // Assert
        for (int i = 0; i < repetitions.length; i++) {
          expect(result[i].repetitionNumber,
              equals(repetitions[i].repetitionNumber));
          expect(result[i].goalAmount, equals(repetitions[i].goalAmount));
          expect(result[i].progressList.toString(),
              equals(repetitions[i].progressList.toString()));
          expect(result[i].startDate, equals(repetitions[i].startDate));
          expect(result[i].endDate, equals(repetitions[i].endDate));
          expect(result[i].repetitionStatus,
              equals(repetitions[i].repetitionStatus));
        }
      });

      test('should throw repetition status is not supported exception', () {
        // Arrange
        Map<String, dynamic> json = {
          'repetitionNumber': 1,
          'goalAmount': 1.0,
          'progressList': [],
          'startDate': Timestamp.fromDate(FakerService.dateTime()),
          'endDate': Timestamp.fromDate(FakerService.dateTime()),
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
        RepetitionModel repetition = mockRepetitionModel();
        // Act
        RepetitionModel repetitionCopy = repetition.copy();
        // Assert
        expect(repetitionCopy.repetitionNumber,
            equals(repetition.repetitionNumber));
        expect(repetitionCopy.goalAmount, equals(repetition.goalAmount));
        expect(repetitionCopy.progressList.toString(),
            equals(repetition.progressList.toString()));
        expect(repetitionCopy.startDate, equals(repetition.startDate));
        expect(repetitionCopy.endDate, equals(repetition.endDate));
        expect(repetitionCopy.repetitionStatus,
            equals(repetition.repetitionStatus));
      });
    });

    group('copyRepetitionList()', () {
      test('should return a copy of the list of repetitions', () {
        // Arrange
        List<RepetitionModel> repetitions =
            FakerService.list((_) => mockRepetitionModel());
        // Act
        List<RepetitionModel> result = RepetitionModel.copyList(repetitions);
        // Assert
        for (int i = 0; i < repetitions.length; i++) {
          expect(result[i].repetitionNumber,
              equals(repetitions[i].repetitionNumber));
          expect(result[i].goalAmount, equals(repetitions[i].goalAmount));
          expect(result[i].progressList.toString(),
              equals(repetitions[i].progressList.toString()));
          expect(result[i].startDate, equals(repetitions[i].startDate));
          expect(result[i].endDate, equals(repetitions[i].endDate));
          expect(result[i].repetitionStatus,
              equals(repetitions[i].repetitionStatus));
        }
      });
    });

    group('deleteProgress()', () {
      test('should delete progress from progressList', () {
        // Arrange
        ProgressModel progress = mockProgressModel();
        RepetitionModel repetition =
            mockRepetitionModel(progressList: [progress]);
        // Act
        repetition.deleteProgress(progress);
        // Assert
        expect(repetition.progressList, isEmpty);
      });
    });
  });
}
