import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/challenge/acceptance_criteria_model.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:challenge/services/time_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../services/faker_service.dart';
import 'acceptance_criteria_model_test.dart';
import 'frequency_model_test.dart';
import 'group_challenge_model_test.dart';
import 'group_challenge_options_model_test.dart';
import 'media_model_test.dart';
import 'repetition_model_test.dart';

AttemptModel mockAttemptModel({
  ChallengeStatusEnum? status,
  DateTime? startDate,
  DateTime? endDate,
  int? number,
  AcceptanceCriteriaModel? acceptanceCriteria,
  FrequencyModel? frequency,
  List<MediaModel>? media,
  List<RepetitionModel>? repetitions,
  DateTime? createdAt,
}) {
  return AttemptModel(
    status: status ?? ChallengeStatusEnum.backlog,
    startDate: startDate ?? FakerService.dateTime(),
    endDate: endDate ?? FakerService.dateTime(),
    number: number ?? 1,
    acceptanceCriteria: acceptanceCriteria ?? mockAcceptanceCriteriaModel(),
    frequency: frequency ?? mockFrequencyModel(),
    media: media ?? [mockMediaModel()],
    repetitions: repetitions ?? [mockRepetitionModel()],
    createdAt: createdAt ?? DateTime.now(),
  );
}

main() {
  group('AttemptModel', () {
    GroupChallengeModel groupChallenge = mockGroupChallengeModel(
        groupChallengeOptions:
            mockGroupChallengeOptionsModel(isProgressIndividuell: true));
    groupChallenge.startDate = null;
    group('toDoc()', () {
      test('should return document of attempt model', () {
        // arrange
        AttemptModel attemptModel = mockAttemptModel();
        // act
        var result = attemptModel.toDoc();
        // assert
        expect(result[AttemptModel.numberField], attemptModel.number);
        expect(
            result[AttemptModel.statusField], attemptModel.status.toString());
        expect(result[AttemptModel.acceptanceCriteriaField],
            attemptModel.acceptanceCriteria.toDoc());
        expect(result[AttemptModel.frequencyField],
            attemptModel.frequency.toDoc());
        expect(result[AttemptModel.mediaField],
            attemptModel.media.map((e) => e.toDoc()).toList());
        expect(result[AttemptModel.repetitionsField],
            attemptModel.repetitions.map((e) => e.toDoc()).toList());
        expect(result[AttemptModel.createdAtField], attemptModel.createdAt);
      });
    });

    group('fromDoc()', () {
      test('should return attempt model from document', () {
        // arrange
        AttemptModel attemptModel = mockAttemptModel();
        Map<String, dynamic> doc = attemptModel.toDoc();
        // act
        var result = AttemptModel.fromDoc(doc);
        // assert
        expect(result.number, attemptModel.number);
        expect(result.status, attemptModel.status);
        expect(result.acceptanceCriteria.amount,
            attemptModel.acceptanceCriteria.amount);
        expect(result.acceptanceCriteria.unit,
            attemptModel.acceptanceCriteria.unit);
        expect(result.frequency.amount, attemptModel.frequency.amount);
        expect(result.frequency.type, attemptModel.frequency.type);
        expect(result.media.length, attemptModel.media.length);
        expect(result.repetitions.length, attemptModel.repetitions.length);
        expect(result.createdAt, attemptModel.createdAt);
      });
    });

    group('getAllRepetitions()', () {
      test(
          'should return all repetitions when repetitions is not empty and frequency type is time',
          () {
        // Arrange
        AttemptModel attempt = mockAttemptModel(
            frequency: mockFrequencyModel(type: FrequencyTypeEnum.time));

        // Act
        List<RepetitionModel> allRepetitions =
            attempt.getAllRepetitions(groupChallenge);

        // Assert
        expect(allRepetitions, equals(attempt.repetitions));
      });

      test(
          'should return empty list when repetitions is empty and start date is null',
          () {
        // Arrange
        AttemptModel attempt = mockAttemptModel(
            repetitions: [],
            frequency: mockFrequencyModel(type: FrequencyTypeEnum.time));
        attempt.startDate = null;

        // Act
        List<RepetitionModel> allRepetitions =
            attempt.getAllRepetitions(groupChallenge);

        // Assert
        expect(allRepetitions, equals([]));
      });

      test(
          'should return one repetition when frequency type is time and repetitions is empty and start date is not null and in the past',
          () {
        // Arrange
        AttemptModel attempt = mockAttemptModel(
            repetitions: [],
            status: ChallengeStatusEnum.inProgress,
            startDate: TimeService.now().subtract(const Duration(days: 1)),
            frequency: mockFrequencyModel(type: FrequencyTypeEnum.time));
        // Act
        List<RepetitionModel> allRepetitions =
            attempt.getAllRepetitions(groupChallenge);

        // Assert
        expect(allRepetitions.first.startDate, equals(attempt.startDate));
        expect(allRepetitions.first.endDate, equals(null));
        expect(allRepetitions.first.repetitionNumber, equals(1));
        expect(allRepetitions.first.goalAmount,
            equals(attempt.acceptanceCriteria.amount));
        expect(allRepetitions.first.repetitionStatus,
            equals(RepetitionStatusEnum.inProgress));
      });

      test(
          'should return all repetitions when frequency type is daily and no repetitions are saved',
          () {
        // Arrange
        int days = FakerService.integer(max: 10);
        AttemptModel attempt = mockAttemptModel(
            repetitions: [],
            status: ChallengeStatusEnum.inProgress,
            startDate: TimeService.now().subtract(Duration(days: days)),
            endDate: TimeService.now(),
            frequency: mockFrequencyModel(
                amount: days, type: FrequencyTypeEnum.daily));

        // Act
        List<RepetitionModel> allRepetitions =
            attempt.getAllRepetitions(groupChallenge);

        // Assert
        expect(allRepetitions.length, equals(days));
      });

      test(
          'should return frequency amount of repetitions when challenge is over',
          () {
        // Arrange
        int days = FakerService.integer(max: 10);
        AttemptModel attempt = mockAttemptModel(
            repetitions: [],
            status: ChallengeStatusEnum.failed,
            startDate: TimeService.now().subtract(Duration(days: days)),
            endDate: TimeService.now(),
            frequency: mockFrequencyModel(
                amount: days, type: FrequencyTypeEnum.daily));

        // Act
        List<RepetitionModel> allRepetitions =
            attempt.getAllRepetitions(groupChallenge);

        // Assert
        expect(allRepetitions.length, equals(attempt.frequency.amount));
      });
    });

    group('getLastRepetition()', () {
      test('should return last repetition of attempt model', () {
        // arrange
        AttemptModel attemptModel = mockAttemptModel(
            repetitions:
                FakerService.list((_) => mockRepetitionModel(), min: 1));
        // act
        var result = attemptModel.getLastRepetition(groupChallenge);
        // assert
        expect(result, attemptModel.repetitions.last);
      });

      test('should return null when repetitions is empty', () {
        // arrange
        AttemptModel attemptModel = mockAttemptModel(
            repetitions: [],
            frequency: mockFrequencyModel(type: FrequencyTypeEnum.time));
        attemptModel.startDate = null;
        // act
        var result = attemptModel.getLastRepetition(groupChallenge);
        // assert
        expect(result, isNull);
      });
    });

    group('getCurrentRepetitionNumber()', () {
      test('should return repetition.length when frequency type is time', () {
        // Arrange
        AttemptModel attempt = mockAttemptModel(
            frequency: mockFrequencyModel(type: FrequencyTypeEnum.time));
        // Act
        int currentRepetitionNumber =
            attempt.getCurrentRepetitionNumber(groupChallenge);

        // Assert
        expect(currentRepetitionNumber, equals(attempt.repetitions.length));
      });

      test(
          'should return days difference between start and now when frequency type is daily',
          () {
        // Arrange
        int days = FakerService.integer(max: 10);
        AttemptModel attempt = mockAttemptModel(
            startDate: TimeService.now().subtract(Duration(days: days)),
            endDate: TimeService.now(),
            frequency: mockFrequencyModel(
                amount: days, type: FrequencyTypeEnum.daily));

        // Act
        int currentRepetitionNumber =
            attempt.getCurrentRepetitionNumber(groupChallenge);

        // Assert
        expect(currentRepetitionNumber, equals(days));
      });
    });
  });
}
