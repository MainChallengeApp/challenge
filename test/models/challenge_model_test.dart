import 'package:challenge/enums/box_fit_enum.dart';
import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/challenge/acceptance_criteria_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/progress_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:challenge/models/challenge/thumbnail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChallengeModel', () {
    ChallengeModel createMockChallengeModel(
        {ChallengeStatusEnum status = ChallengeStatusEnum.inProgress,
        DateTime? startDate,
        DateTime? endDate,
        AcceptanceCriteriaModel? acceptanceCriteria}) {
      return ChallengeModel(
        id: '1',
        status: status,
        title: 'Challenge Title',
        description: 'Challenge Description',
        thumbnail: ThumbnailModel(
            url: 'assets/images/test.png', scale: 0.8, fit: BoxFitEnum.cover),
        acceptanceCriteria: acceptanceCriteria ??
            AcceptanceCriteriaModel(amount: 1, unit: 'Unit'),
        frequency: FrequencyModel(type: FrequencyTypeEnum.time, amount: 1),
        repetitions: [],
        media: [],
        categories: [ChallengeCategoryEnum.mentalHealth],
        startDate: startDate ?? DateTime.now(),
        endDate: endDate ?? DateTime.now().add(const Duration(days: 1)),
      );
    }

    RepetitionModel createMockRepetitionModel(
        {double goalAmount = 1,
        int? progress,
        RepetitionStatusEnum? repetitionStatus = RepetitionStatusEnum.success,
        List<ProgressModel>? progressList = const [],
        DateTime? startDate,
        DateTime? endDate,
        int repetitionNumber = 1}) {
      return RepetitionModel(
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 1)),
          repetitionNumber: repetitionNumber,
          goalAmount: goalAmount,
          progressList: [
            ProgressModel(
                progress: 1,
                mediaIds: [],
                date: DateTime.now(),
                repetitionNumber: repetitionNumber,
                goal: goalAmount)
          ],
          repetitionStatus: RepetitionStatusEnum.success);
    }

    group('empty()', () {
      test('should return empty challenge', () {
        // Act
        ChallengeModel emptyChallenge = ChallengeModel.empty();

        // Assert
        expect(emptyChallenge.acceptanceCriteria.amount, equals(1));
        expect(emptyChallenge.acceptanceCriteria.unit, equals(''));
        expect(emptyChallenge.frequency.type, equals(FrequencyTypeEnum.time));
        expect(emptyChallenge.frequency.amount, equals(1));
        expect(emptyChallenge.categories, equals([]));
        expect(emptyChallenge.description, equals(''));
        expect(emptyChallenge.title, equals(''));
        expect(emptyChallenge.startDate, equals(null));
        expect(emptyChallenge.endDate, equals(null));
        expect(emptyChallenge.status, equals(ChallengeStatusEnum.backlog));
        expect(emptyChallenge.repetitions, equals([]));
        expect(emptyChallenge.media, equals([]));
      });
    });

    // group('fromJson()', () {
    //   test('should create ChallengeModel object when json is passed correctly',
    //       () {
    //     // Arrange
    //     Map<String, dynamic> json = {
    //       'id': '1',
    //       'status': 'backlog',
    //       'title': 'Challenge Title',
    //       'description': 'Challenge Description',
    //       'thumbnailPath': 'assets/images/test.png',
    //       'acceptanceCriteria': {'amount': 1.0, 'unit': 'Unit'},
    //       'frequency': {'type': 'time', 'amount': 1},
    //       'repetitions': [],
    //       'media': [],
    //       'categories': ['social', 'physicalHealth'],
    //       'startDate': DateTime.now().toIso8601String(),
    //       'endDate':
    //           DateTime.now().add(const Duration(days: 1)).toIso8601String()
    //     };

    //     // Act
    //     ChallengeModel challenge = ChallengeModel.fromDoc(json);

    //     // Assert
    //     expect(challenge.id, equals(json['id']));
    //     expect(challenge.status, equals(ChallengeStatusEnum.backlog));
    //     expect(challenge.title, equals(json['title']));
    //     expect(challenge.description, equals(json['description']));
    //     expect(challenge.thumbnailPath, equals(json['thumbnailPath']));
    //     expect(challenge.acceptanceCriteria.amount, equals(1));
    //     expect(challenge.acceptanceCriteria.unit, equals('Unit'));
    //     expect(challenge.frequency.type, equals(FrequencyTypeEnum.time));
    //     expect(challenge.frequency.amount, equals(1));
    //     expect(challenge.repetitions, equals([]));
    //     expect(challenge.media, equals([]));
    //     expect(
    //         challenge.categories,
    //         equals([
    //           ChallengeCategoryEnum.social,
    //           ChallengeCategoryEnum.physicalHealth
    //         ]));
    //     expect(challenge.startDate, equals(DateTime.parse(json['startDate'])));
    //     expect(challenge.endDate, equals(DateTime.parse(json['endDate'])));
    //   });

    //   test('should throw error when json is passed incorrectly', () {
    //     // Arrange
    //     Map<String, dynamic> json = {};

    //     // Act & Assert
    //     expect(() => ChallengeModel.fromDoc(json), throwsA(isA<TypeError>()));
    //   });

    //   test('should throw challenge category is not supported exception', () {
    //     // Arrange
    //     Map<String, dynamic> json = {
    //       'id': '1',
    //       'status': 'backlog',
    //       'title': 'Challenge Title',
    //       'description': 'Challenge Description',
    //       'thumbnailPath': 'assets/images/test.png',
    //       'acceptanceCriteria': {'amount': 1.0, 'unit': 'Unit'},
    //       'frequency': {'type': 'time', 'amount': 1},
    //       'repetitions': [],
    //       'media': [],
    //       'categories': ['notSupportedCategory'],
    //       'startDate': DateTime.now().toString(),
    //       'endDate': DateTime.now().add(const Duration(days: 1)).toString()
    //     };

    //     // Act & Assert
    //     expect(() => ChallengeModel.fromDoc(json),
    //         throwsA(isA<ChallengeCategoryIsNotSupportedException>()));
    //   });

    //   test('should throw challenge status is not supported exception', () {
    //     // Arrange
    //     Map<String, dynamic> json = {
    //       'id': '1',
    //       'status': 'not supported status',
    //       'title': 'Challenge Title',
    //       'description': 'Challenge Description',
    //       'thumbnailPath': 'assets/images/test.png',
    //       'acceptanceCriteria': {'amount': 1.0, 'unit': 'Unit'},
    //       'frequency': {'type': 'time', 'amount': 1},
    //       'repetitions': [],
    //       'media': [],
    //       'categories': ['notSupportedCategory'],
    //       'startDate': DateTime.now().toString(),
    //       'endDate': DateTime.now().add(const Duration(days: 1)).toString()
    //     };

    //     // Act & Assert
    //     expect(() => ChallengeModel.fromDoc(json),
    //         throwsA(isA<ChallengeStatusIsNotSupportedException>()));
    //   });
    // });

    group('toDoc()', () {
      test('should return json when ChallengeModel is passed', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        Map<String, dynamic> json = {
          'status': 'inProgress',
          'title': 'Challenge Title',
          'description': 'Challenge Description',
          'thumbnail': {
            'url': 'assets/images/test.png',
            'scale': 0.8,
            'fit': 'cover'
          },
          'acceptanceCriteria': {'amount': 1.0, 'unit': 'Unit'},
          'frequency': {'type': 'time', 'amount': 1},
          'repetitions': [],
          'media': [],
          'categories': ['mentalHealth'],
          'startDate': challenge.startDate,
          'endDate': challenge.endDate,
          'createdAt': challenge.createdAt
        };

        // Act
        Map<String, dynamic> challengeJson = challenge.toDoc();

        // Assert
        expect(challengeJson, equals(json));
      });
    });

    group('copyChallenge()', () {
      test('should copy challenge with id when challenge is passed', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();

        // Act
        ChallengeModel copiedChallenge = challenge.copyChallenge(withId: true);

        // Assert
        expect(copiedChallenge.id, equals(challenge.id));
        expect(copiedChallenge.status, equals(challenge.status));
        expect(copiedChallenge.title, equals(challenge.title));
        expect(copiedChallenge.description, equals(challenge.description));
        expect(
            copiedChallenge.thumbnail!.url, equals(challenge.thumbnail!.url));
        expect(copiedChallenge.acceptanceCriteria.amount,
            equals(challenge.acceptanceCriteria.amount));
        expect(copiedChallenge.acceptanceCriteria.unit,
            equals(challenge.acceptanceCriteria.unit));
        expect(
            copiedChallenge.frequency.type, equals(challenge.frequency.type));
        expect(copiedChallenge.frequency.amount,
            equals(challenge.frequency.amount));
        expect(copiedChallenge.repetitions, equals(challenge.repetitions));
        expect(copiedChallenge.media, equals(challenge.media));
        expect(copiedChallenge.categories, equals(challenge.categories));
        expect(copiedChallenge.startDate, equals(challenge.startDate));
        expect(copiedChallenge.endDate, equals(challenge.endDate));
      });

      test('should copy challenge without id when challenge is passed', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();

        // Act
        ChallengeModel copiedChallenge = challenge.copyChallenge(withId: false);

        // Assert
        expect(copiedChallenge.id, isNot(equals(challenge.id)));
        expect(copiedChallenge.status, equals(challenge.status));
        expect(copiedChallenge.title, equals(challenge.title));
        expect(copiedChallenge.description, equals(challenge.description));
        expect(
            copiedChallenge.thumbnail!.url, equals(challenge.thumbnail!.url));
        expect(copiedChallenge.acceptanceCriteria.amount,
            equals(challenge.acceptanceCriteria.amount));
        expect(copiedChallenge.acceptanceCriteria.unit,
            equals(challenge.acceptanceCriteria.unit));
        expect(
            copiedChallenge.frequency.type, equals(challenge.frequency.type));
        expect(copiedChallenge.frequency.amount,
            equals(challenge.frequency.amount));
        expect(copiedChallenge.repetitions, equals(challenge.repetitions));
        expect(copiedChallenge.media, equals(challenge.media));
        expect(copiedChallenge.categories, equals(challenge.categories));
        expect(copiedChallenge.startDate, equals(challenge.startDate));
        expect(copiedChallenge.endDate, equals(challenge.endDate));
      });

      test('should copy challenge with try again when challenge is passed', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();

        // Act
        ChallengeModel copiedChallenge =
            challenge.copyChallenge(isTryAgain: true);

        // Assert
        expect(copiedChallenge.id, isNot(equals(challenge.id)));
        expect(copiedChallenge.status, equals(ChallengeStatusEnum.backlog));
        expect(copiedChallenge.title, equals(challenge.title));
        expect(copiedChallenge.description, equals(challenge.description));
        expect(
            copiedChallenge.thumbnail!.url, equals(challenge.thumbnail!.url));
        expect(copiedChallenge.acceptanceCriteria.amount,
            equals(challenge.acceptanceCriteria.amount));
        expect(copiedChallenge.acceptanceCriteria.unit,
            equals(challenge.acceptanceCriteria.unit));
        expect(
            copiedChallenge.frequency.type, equals(challenge.frequency.type));
        expect(copiedChallenge.frequency.amount,
            equals(challenge.frequency.amount));
        expect(copiedChallenge.repetitions, equals([]));
        expect(copiedChallenge.media, equals([]));
        expect(copiedChallenge.categories, equals(challenge.categories));
        expect(copiedChallenge.startDate, equals(null));
        expect(copiedChallenge.endDate, equals(null));
      });
    });

    group('searchInChallenge()', () {
      test('should be in search when all title is passed to function', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.title = 'title';

        // Act
        bool isInSearch = challenge.searchInChallenge(challenge.title);

        // Assert
        expect(isInSearch, equals(true));
      });

      test(
          'should not be in search when passed string is not in any Challenge property',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();

        // Act
        bool isInSearch = challenge.searchInChallenge(
            'not in title or description or acceptance criteria');

        // Assert
        expect(isInSearch, equals(false));
      });
    });

    group('isInCategories()', () {
      test('should be in categories when all categories are passed to function',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.categories = [
          ChallengeCategoryEnum.social,
          ChallengeCategoryEnum.physicalHealth
        ];

        // Act
        bool isInCategories = challenge.isInCategories(challenge.categories);

        // Assert
        expect(isInCategories, equals(true));
      });

      test(
          'should not be in categories when passed categories are not in Challenge categories',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.categories = [
          ChallengeCategoryEnum.social,
          ChallengeCategoryEnum.physicalHealth
        ];

        // Act
        bool isInCategories =
            challenge.isInCategories([ChallengeCategoryEnum.mentalHealth]);

        // Assert
        expect(isInCategories, equals(false));
      });
    });

    group('checkChallengeStatus()', () {
      test('should be success when all repetition are completed', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.repetitions.add(createMockRepetitionModel());
        challenge.endDate = DateTime.now().subtract(const Duration(days: 1));

        // Act
        challenge.checkChallengeStatus();

        // Assert
        expect(challenge.status, equals(ChallengeStatusEnum.success));
      });

      test(
          'should be failed when one repetition is not completed and endDate is before now',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.repetitions.add(createMockRepetitionModel(goalAmount: 2));
        challenge.endDate = DateTime.now().subtract(const Duration(days: 1));

        // Act
        challenge.checkChallengeStatus();

        // Assert
        expect(challenge.status, equals(ChallengeStatusEnum.failed));
      });

      test('should be backlog when startDate is before now', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = DateTime.now().add(const Duration(days: 1));

        // Act
        challenge.checkChallengeStatus();
        // Assert
        expect(challenge.status, equals(ChallengeStatusEnum.backlog));
      });

      test(
          'should be inProgress when one repetition is not completed and startDate is after now and endDate is after now',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = DateTime.now().subtract(const Duration(days: 1));
        challenge.endDate = DateTime.now().add(const Duration(days: 1));
        challenge.repetitions.add(createMockRepetitionModel(goalAmount: 2));

        // Act
        challenge.checkChallengeStatus();
        // Assert
        expect(challenge.status, equals(ChallengeStatusEnum.inProgress));
      });
    });

    group('setEndDate()', () {
      test('should not change end date when start date is null', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = null;

        // Act
        challenge.setEndDate();

        // Assert
        expect(challenge.endDate, equals(challenge.endDate));
      });

      test(
          'should calculate end date when start date is set and frequency type is daily and amount is not null',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = DateTime.now();
        const int frequencyAmount = 1;
        challenge.frequency = FrequencyModel(
            type: FrequencyTypeEnum.daily, amount: frequencyAmount);

        // Act
        challenge.setEndDate();

        // Assert
        expect(
            challenge.endDate,
            equals(challenge.startDate
                ?.add(const Duration(days: frequencyAmount))));
      });

      test(
          'should set end date to null when frequency type is daily and amount is null',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = DateTime.now();
        challenge.endDate = DateTime.now().add(const Duration(days: 1));
        challenge.frequency =
            FrequencyModel(type: FrequencyTypeEnum.daily, amount: null);

        // Act
        challenge.setEndDate();

        // Assert
        expect(challenge.endDate, equals(null));
      });
    });

    group('setFrequencyAmount()', () {
      test(
          'should  not set frequencyAmount when start date and end date are null',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = null;
        challenge.endDate = null;
        const int frequencyAmount = 1;
        challenge.frequency = FrequencyModel(
            type: FrequencyTypeEnum.daily, amount: frequencyAmount);

        // Act
        challenge.setFrequencyAmount();

        // Assert
        expect(challenge.frequency.amount, equals(frequencyAmount));
      });

      test(
          'should set frequency amount when start date is not null, end date is not null and frequency type is daily',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = DateTime.now();
        const int frequencyAmount = 1;
        challenge.endDate =
            challenge.startDate!.add(const Duration(days: frequencyAmount));
        challenge.frequency =
            FrequencyModel(type: FrequencyTypeEnum.daily, amount: null);

        // Act
        challenge.setFrequencyAmount();

        // Assert
        expect(challenge.frequency.amount, equals(frequencyAmount));
      });

      test(
          'should set frequency amount to null when frequency type is daily and end date is null',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.endDate = null;
        challenge.frequency =
            FrequencyModel(type: FrequencyTypeEnum.daily, amount: null);

        // Act
        challenge.setFrequencyAmount();

        // Assert
        expect(challenge.frequency.amount, equals(null));
      });
    });

    group('hasThumbnail()', () {
      test('should return true when thumbnailPath is not empty', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.thumbnail!.url = 'thumbnailPath';

        // Act
        bool hasThumbnail = challenge.hasThumbnail();

        // Assert
        expect(hasThumbnail, equals(true));
      });

      test('should return false when thumbnailPath is empty', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.thumbnail!.url = '';

        // Act
        bool hasThumbnail = challenge.hasThumbnail();

        // Assert
        expect(hasThumbnail, equals(false));
      });
    });

    group('getLastRepetition()', () {
      test('should return last repetition when repetitions is not empty', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        RepetitionModel repetition = createMockRepetitionModel();
        challenge.repetitions.add(repetition);

        // Act
        RepetitionModel? lastRepetition = challenge.getLastRepetition();

        // Assert
        expect(lastRepetition, equals(repetition));
      });

      test(
          'should return null when repetitions is empty and frequency type is time and start date is null',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency.type = FrequencyTypeEnum.time;
        challenge.startDate = null;
        challenge.repetitions = [];

        // Act
        RepetitionModel? lastRepetition = challenge.getLastRepetition();

        // Assert
        expect(lastRepetition, equals(null));
      });

      test(
          'should return empty repetition when repetitions is empty and frequency type is daily and start date is before now',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency.type = FrequencyTypeEnum.daily;
        challenge.frequency.amount = 1;
        challenge.status = ChallengeStatusEnum.inProgress;
        challenge.startDate =
            DateTime.now().subtract(const Duration(hours: 23));
        challenge.endDate = challenge.startDate!.add(const Duration(days: 1));
        challenge.repetitions = [];

        // Act
        RepetitionModel lastRepetition = challenge.getLastRepetition()!;

        // Assert
        expect(lastRepetition.startDate, equals(challenge.startDate));
        expect(lastRepetition.endDate,
            equals(challenge.startDate!.add(const Duration(days: 1))));
        expect(lastRepetition.progressList, equals([]));
        expect(lastRepetition.repetitionStatus,
            equals(RepetitionStatusEnum.inProgress));
      });
    });

    group('getCurrentRepetition()', () {
      test('should return null when there is no current repetition', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.repetitions = [];
        challenge.frequency.type = FrequencyTypeEnum.time;
        challenge.startDate = null;

        // Act
        RepetitionModel? currentRepetition = challenge.getCurrentRepetition();

        // Assert
        expect(currentRepetition, equals(null));
      });

      test(
          'should return last repetition when there is a current repetition and frequency type is time',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        RepetitionModel repetition1 =
            createMockRepetitionModel(repetitionNumber: 1);
        RepetitionModel repetition2 =
            createMockRepetitionModel(repetitionNumber: 2);
        challenge.repetitions.add(repetition1);
        challenge.repetitions.add(repetition2);
        challenge.frequency.type = FrequencyTypeEnum.time;

        // Act
        RepetitionModel? currentRepetition = challenge.getCurrentRepetition();

        // Assert
        expect(currentRepetition, equals(repetition2));
      });
    });

    group('getAllRepetitions()', () {
      test(
          'should return all repetitions when repetitions is not empty and frequency type is time',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        RepetitionModel repetition1 =
            createMockRepetitionModel(repetitionNumber: 1);
        RepetitionModel repetition2 =
            createMockRepetitionModel(repetitionNumber: 2);
        challenge.frequency.type = FrequencyTypeEnum.time;
        challenge.repetitions.add(repetition1);
        challenge.repetitions.add(repetition2);

        // Act
        List<RepetitionModel> allRepetitions = challenge.getAllRepetitions();

        // Assert
        expect(allRepetitions, equals([repetition1, repetition2]));
      });

      test(
          'should return empty list when repetitions is empty and start date is null',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency.type = FrequencyTypeEnum.time;
        challenge.startDate = null;
        challenge.repetitions = [];

        // Act
        List<RepetitionModel> allRepetitions = challenge.getAllRepetitions();

        // Assert
        expect(allRepetitions, equals([]));
      });

      test(
          'should return one repetition when frequency type is time and repetitions is empty and start date is not null',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency.type = FrequencyTypeEnum.time;
        challenge.startDate = DateTime.now().subtract(const Duration(days: 1));
        challenge.repetitions = [];

        // Act
        List<RepetitionModel> allRepetitions = challenge.getAllRepetitions();

        // Assert
        expect(allRepetitions.first.startDate, equals(challenge.startDate));
        expect(allRepetitions.first.endDate, equals(null));
        expect(allRepetitions.first.repetitionNumber, equals(1));
        expect(allRepetitions.first.goalAmount,
            equals(challenge.acceptanceCriteria.amount));
        expect(allRepetitions.first.repetitionStatus,
            equals(RepetitionStatusEnum.inProgress));
      });

      test(
          'should return all repetition when frequency type is daily and no repetitions are saved',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency =
            FrequencyModel(type: FrequencyTypeEnum.daily, amount: 2);
        challenge.startDate = DateTime.now().subtract(const Duration(days: 1));
        challenge.endDate = challenge.startDate!.add(const Duration(days: 2));
        challenge.status = ChallengeStatusEnum.inProgress;
        challenge.repetitions = [];

        // Act
        List<RepetitionModel> allRepetitions = challenge.getAllRepetitions();

        // Assert
        expect(allRepetitions.length, equals(2));
        expect(allRepetitions.first.startDate, equals(challenge.startDate));
        expect(allRepetitions.first.endDate,
            equals(challenge.startDate?.add(const Duration(days: 1))));
        expect(allRepetitions.first.repetitionNumber, equals(1));
        expect(allRepetitions.first.goalAmount,
            equals(challenge.acceptanceCriteria.amount));
        expect(allRepetitions.first.repetitionStatus,
            equals(RepetitionStatusEnum.failed));
        expect(allRepetitions.last.startDate,
            equals(challenge.startDate?.add(const Duration(days: 1))));
        expect(allRepetitions.last.endDate,
            equals(challenge.startDate?.add(const Duration(days: 2))));
        expect(allRepetitions.last.repetitionNumber, equals(2));
        expect(allRepetitions.last.goalAmount,
            equals(challenge.acceptanceCriteria.amount));
        expect(allRepetitions.last.repetitionStatus,
            equals(RepetitionStatusEnum.inProgress));
      });

      test(
          'should return frequency amount of repetitions when challenge is over',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency =
            FrequencyModel(type: FrequencyTypeEnum.daily, amount: 2);
        challenge.startDate = DateTime.now().subtract(const Duration(days: 4));
        challenge.endDate = challenge.startDate!
            .add(Duration(days: challenge.frequency.amount!));
        challenge.status = ChallengeStatusEnum.failed;
        challenge.repetitions = [];

        // Act
        List<RepetitionModel> allRepetitions = challenge.getAllRepetitions();

        // Assert
        expect(allRepetitions.length, equals(challenge.frequency.amount));
      });
    });

    group('getCurrentRepetitionProgressAbsolute()', () {
      test('should return absolute progress of last progress in repetition',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        RepetitionModel repetition = createMockRepetitionModel();
        challenge.acceptanceCriteria.amount = 2;
        repetition.progressList.add(ProgressModel(
            progress: 1,
            mediaIds: [],
            date: DateTime.now(),
            repetitionNumber: 1,
            goal: repetition.goalAmount));
        challenge.repetitions.add(repetition);

        // Act
        double progress = challenge.getCurrentRepetitionProgressAbsolute();

        // Assert
        expect(progress, equals(1));
      });

      test('should return 0 when there is no repetition', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = null;
        challenge.status = ChallengeStatusEnum.backlog;

        challenge.repetitions = [];

        // Act
        double progress = challenge.getCurrentRepetitionProgressAbsolute();

        // Assert
        expect(progress, equals(0));
      });
    });

    group('getCurrentRepetitionProgressPercentage()', () {
      test('should return percentage progress of last progress in repetition',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        RepetitionModel repetition = createMockRepetitionModel(goalAmount: 2);
        challenge.acceptanceCriteria.amount = 2;
        repetition.progressList.add(ProgressModel(
            progress: 1,
            mediaIds: [],
            date: DateTime.now(),
            repetitionNumber: 1,
            goal: repetition.goalAmount));
        challenge.repetitions.add(repetition);

        // Act
        double progress = challenge.getCurrentRepetitionProgressPercentage();

        // Assert
        expect(progress, equals(0.5));
      });

      test('should return 0 when there is no repetition', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = null;
        challenge.status = ChallengeStatusEnum.backlog;

        challenge.repetitions = [];

        // Act
        double progress = challenge.getCurrentRepetitionProgressPercentage();

        // Assert
        expect(progress, equals(0));
      });
    });

    group('addRepetition()', () {
      test(
          'should add first repetition when repetitions is empty and challenge is in backlog',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = null;
        challenge.status = ChallengeStatusEnum.backlog;

        // Act
        RepetitionModel repetition = challenge.addRepetition();

        // Assert
        expect(challenge.repetitions, equals([repetition]));
      });

      test('should add last repetition when repetitions is not empty', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency.amount = 2;

        // Act
        RepetitionModel repetition = challenge.addRepetition();

        // Assert
        expect(challenge.repetitions.last, equals(repetition));
      });
    });

    group('endRepetition()', () {
      test('should end repetition when repetition is in progress', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency.type = FrequencyTypeEnum.time;
        challenge.frequency.amount = 2;
        RepetitionModel repetition = createMockRepetitionModel();
        repetition.repetitionStatus = RepetitionStatusEnum.inProgress;
        challenge.repetitions.add(repetition);

        // Act
        challenge.endRepetition();

        // Assert
        expect(
            repetition.repetitionStatus, equals(RepetitionStatusEnum.success));
        expect(challenge.repetitions.length, equals(2));
      });

      test(
          'should not be able to end repetition when frequency type is not time',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency.type = FrequencyTypeEnum.daily;
        RepetitionModel repetition = createMockRepetitionModel();
        repetition.repetitionStatus = RepetitionStatusEnum.inProgress;
        challenge.repetitions.add(repetition);

        // Act
        challenge.endRepetition();

        // Assert
        expect(repetition.repetitionStatus,
            equals(RepetitionStatusEnum.inProgress));
      });
    });

    group('isCompleted()', () {
      test('should be completed when all repetitions are completed', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.repetitions.add(createMockRepetitionModel());

        // Act
        bool isCompleted = challenge.isCompleted();

        // Assert
        expect(isCompleted, equals(true));
      });

      test('should not be completed when one repetition is not completed', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.repetitions.add(createMockRepetitionModel(goalAmount: 2));

        // Act
        bool isCompleted = challenge.isCompleted();

        // Assert
        expect(isCompleted, equals(false));
      });
    });

    group('getCurrentRepetitionNumber()', () {
      test('should return repetition.length when frequency type is time', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency.type = FrequencyTypeEnum.time;
        challenge.repetitions
            .add(createMockRepetitionModel(repetitionNumber: 1));
        challenge.repetitions
            .add(createMockRepetitionModel(repetitionNumber: 2));

        // Act
        int currentRepetitionNumber = challenge.getCurrentRepetitionNumber();

        // Assert
        expect(currentRepetitionNumber, equals(challenge.repetitions.length));
      });

      test(
          'should return days difference between start and now when frequency type is daily',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency.type = FrequencyTypeEnum.daily;
        challenge.startDate = DateTime.now().subtract(const Duration(days: 2));
        challenge.endDate = null;
        challenge.frequency.amount = 2;

        // Act
        int currentRepetitionNumber = challenge.getCurrentRepetitionNumber();

        // Assert
        expect(currentRepetitionNumber, equals(2));
      });
    });

    group('start()', () {
      test('should set start date to now and status to inProgress', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = null;
        challenge.status = ChallengeStatusEnum.backlog;

        // Act
        challenge.start();

        // Assert
        expect(challenge.startDate, isNotNull);
        expect(challenge.status, equals(ChallengeStatusEnum.inProgress));
      });

      test(
          'should set the frequency amount when end date is set and frequency amount is not null and type is daily',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = null;
        challenge.status = ChallengeStatusEnum.backlog;
        const int daysDifferenceBetweenStartAndEnd = 2;
        challenge.endDate = DateTime.now()
            .add(const Duration(days: daysDifferenceBetweenStartAndEnd));
        challenge.frequency.amount = null;
        challenge.frequency.type = FrequencyTypeEnum.daily;

        // Act
        challenge.start();

        // Assert
        expect(challenge.frequency.amount,
            equals(daysDifferenceBetweenStartAndEnd));
        expect(challenge.startDate, isNotNull);
        expect(challenge.status, equals(ChallengeStatusEnum.inProgress));
      });

      test('should return nothing when frequency amount is 0', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = null;
        challenge.status = ChallengeStatusEnum.backlog;
        challenge.frequency.amount = 0;
        challenge.endDate = DateTime.now().add(const Duration(days: 1));

        // Act
        challenge.start(); // actually skipping in the end function

        // Assert
        expect(challenge.status, equals(ChallengeStatusEnum.backlog));
      });

      test('should add and start new repetition when there are no repetitions',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = null;
        challenge.status = ChallengeStatusEnum.backlog;
        challenge.frequency.amount = null;
        challenge.repetitions = [];

        // Act
        challenge.start();

        // Assert
        expect(challenge.repetitions.length, equals(1));
        expect(challenge.repetitions.first.startDate, isNotNull);
        expect(challenge.repetitions.first.repetitionStatus,
            equals(RepetitionStatusEnum.inProgress));
      });
    });

    group('end()', () {
      test(
          'should set end date to now and status to success when challenge is completed',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.repetitions.add(createMockRepetitionModel());
        challenge.status = ChallengeStatusEnum.inProgress;

        // Act
        challenge.end();

        // Assert
        expect(challenge.endDate, isNotNull);
        expect(challenge.status, equals(ChallengeStatusEnum.success));
      });

      test(
          'should set end date to now and status to failed when challenge is not completed',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.repetitions.add(createMockRepetitionModel(goalAmount: 2));
        challenge.status = ChallengeStatusEnum.inProgress;

        // Act
        challenge.end();

        // Assert
        expect(challenge.endDate, isNotNull);
        expect(challenge.status, equals(ChallengeStatusEnum.failed));
      });

      test('should change nothing when status is backlog', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.status = ChallengeStatusEnum.backlog;
        challenge.endDate = null;

        // Act
        challenge.end();

        // Assert
        expect(challenge.endDate, isNull);
        expect(challenge.status, equals(ChallengeStatusEnum.backlog));
      });

      test('should end current repetition when its in progress', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        RepetitionModel repetition = createMockRepetitionModel();
        repetition.repetitionStatus = RepetitionStatusEnum.inProgress;
        challenge.repetitions.add(repetition);

        // Act
        challenge.end();

        // Assert
        expect(
            repetition.repetitionStatus, equals(RepetitionStatusEnum.success));
      });
    });

    group('isInBacklog()', () {
      test('should return true when status is backlog', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.status = ChallengeStatusEnum.backlog;

        // Act
        bool isInBacklog = challenge.isInBacklog();

        // Assert
        expect(isInBacklog, equals(true));
      });

      test('should return false when status is not backlog', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.status = ChallengeStatusEnum.inProgress;

        // Act
        bool isInBacklog = challenge.isInBacklog();

        // Assert
        expect(isInBacklog, equals(false));
      });
    });

    group('isInProgress()', () {
      test('should return true when status is inProgress', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.status = ChallengeStatusEnum.inProgress;

        // Act
        bool isInProgress = challenge.isInProgress();

        // Assert
        expect(isInProgress, equals(true));
      });

      test('should return false when status is not inProgress', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.status = ChallengeStatusEnum.backlog;

        // Act
        bool isInProgress = challenge.isInProgress();

        // Assert
        expect(isInProgress, equals(false));
      });
    });

    group('isSucceeded()', () {
      test('should return true when status is success', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.status = ChallengeStatusEnum.success;

        // Act
        bool isSucceeded = challenge.isSucceeded();

        // Assert
        expect(isSucceeded, equals(true));
      });

      test('should return false when status is not success', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.status = ChallengeStatusEnum.backlog;

        // Act
        bool isSucceeded = challenge.isSucceeded();

        // Assert
        expect(isSucceeded, equals(false));
      });
    });

    group('isFailed()', () {
      test('should return true when status is failed', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.status = ChallengeStatusEnum.failed;

        // Act
        bool isFailed = challenge.isFailed();

        // Assert
        expect(isFailed, equals(true));
      });

      test('should return false when status is not failed', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.status = ChallengeStatusEnum.backlog;

        // Act
        bool isFailed = challenge.isFailed();

        // Assert
        expect(isFailed, equals(false));
      });
    });

    group('isEditable()', () {
      test('should return true when status is backlog', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.status = ChallengeStatusEnum.backlog;

        // Act
        bool isEditable = challenge.isEditable();

        // Assert
        expect(isEditable, equals(true));
      });

      test('should return true when status is inProgress', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.status = ChallengeStatusEnum.inProgress;

        // Act
        bool isEditable = challenge.isEditable();

        // Assert
        expect(isEditable, equals(true));
      });

      test('should return false when status is not backlog or inProgress', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.status = ChallengeStatusEnum.failed;

        // Act
        bool isEditable = challenge.isEditable();

        // Assert
        expect(isEditable, equals(false));
      });
    });

    group('getCurrentPercentage()', () {
      test('should return 0 when there is no repetition', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.repetitions = [];

        // Act
        double currentPercentage = challenge.getCurrentPercentage();

        // Assert
        expect(currentPercentage, equals(0));
      });

      test('should return 0 when there is no progress in repetition', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        RepetitionModel repetition = createMockRepetitionModel();
        repetition.progressList.clear();
        challenge.repetitions.add(repetition);

        // Act
        double currentPercentage = challenge.getCurrentPercentage();

        // Assert
        expect(currentPercentage, equals(0));
      });

      test('should return 0 when current repetition number is 0', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = null;
        challenge.status = ChallengeStatusEnum.backlog;

        // Act
        double currentPercentage = challenge.getCurrentPercentage();

        // Assert
        expect(currentPercentage, equals(0));
      });

      test('should return 0.5 when there is 1 progress in repetition', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        RepetitionModel repetition = createMockRepetitionModel();
        repetition.progressList.add(ProgressModel(
            progress: 0.5,
            mediaIds: [],
            date: DateTime.now(),
            repetitionNumber: 1,
            goal: repetition.goalAmount));
        challenge.repetitions.add(repetition);

        // Act
        double currentPercentage = challenge.getCurrentPercentage();

        // Assert
        expect(currentPercentage, equals(0.5));
      });

      test(
          'should return 1 when there is 1 progress in repetition and progress is 1',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        RepetitionModel repetition = createMockRepetitionModel();
        repetition.progressList.add(ProgressModel(
            progress: 1,
            mediaIds: [],
            date: DateTime.now(),
            repetitionNumber: 1,
            goal: repetition.goalAmount));
        challenge.repetitions.add(repetition);

        // Act
        double currentPercentage = challenge.getCurrentPercentage();

        // Assert
        expect(currentPercentage, equals(1));
      });

      test('should return current percentage when frequency amount is null',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency.amount = null;
        RepetitionModel repetition1 = createMockRepetitionModel();
        repetition1.progressList.add(ProgressModel(
            progress: 1,
            mediaIds: [],
            date: DateTime.now(),
            repetitionNumber: 1,
            goal: repetition1.goalAmount));

        RepetitionModel repetition2 = createMockRepetitionModel();
        repetition2.progressList.clear();

        challenge.repetitions.add(repetition1);
        challenge.repetitions.add(repetition2);

        // Act
        double currentPercentage = challenge.getCurrentPercentage();

        // Assert
        expect(currentPercentage, equals(0.5));
      });
    });

    group('canEndRepetition()', () {
      test('should return true when repetition is in progress', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency.type = FrequencyTypeEnum.time;
        challenge.frequency.amount = 2;
        RepetitionModel repetition = createMockRepetitionModel();
        repetition.repetitionStatus = RepetitionStatusEnum.inProgress;
        challenge.repetitions.add(repetition);

        // Act
        bool canEndRepetition = challenge.canEndRepetition();

        // Assert
        expect(canEndRepetition, equals(true));
      });

      test('should return false when repetition is not in progress', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        RepetitionModel repetition = createMockRepetitionModel();
        repetition.repetitionStatus = RepetitionStatusEnum.failed;
        challenge.repetitions.add(repetition);

        // Act
        bool canEndRepetition = challenge.canEndRepetition();

        // Assert
        expect(canEndRepetition, equals(false));
      });
    });

    group('nextIn()', () {
      test('should return "" when frequency type is time', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency.type = FrequencyTypeEnum.time;

        // Act
        String nextIn = challenge.endsIn();

        // Assert
        expect(nextIn, equals(''));
      });

      test('should return "0 min" when there is no current repetition', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency.type = FrequencyTypeEnum.daily;
        challenge.startDate = null;
        challenge.repetitions = [];

        // Act
        String nextIn = challenge.endsIn();

        // Assert
        expect(nextIn, equals('0 min'));
      });

      test('should return next in h when there is a current repetition', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.frequency.type = FrequencyTypeEnum.daily;
        challenge.startDate =
            DateTime.now().subtract(const Duration(minutes: 59));
        challenge.repetitions = [];

        // Act
        String nextIn = challenge.endsIn();

        // Assert
        expect(nextIn, equals('23 h'));
      });
    });

    group('removeMedia()', () {
      test('should remove media from media list', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        MediaModel media = MediaModel(
            source: 'source', type: MediaTypeEnum.image, title: 'title');
        RepetitionModel repetition = createMockRepetitionModel();
        repetition.progressList.clear();
        repetition.progressList.add(ProgressModel(
            progress: 1,
            mediaIds: [media.id!],
            date: DateTime.now(),
            repetitionNumber: 1,
            goal: repetition.goalAmount));

        challenge.media.add(media);
        challenge.repetitions.add(repetition);

        // Act
        challenge.removeMedia(media);

        // Assert
        expect(challenge.media, equals([]));
        expect(repetition.progressList.first.mediaIds, equals([]));
      });
    });

    group('sortChallenges()', () {
      test('should sort Challenges by status and percentage', () {
        // Arrange
        ChallengeModel challengeInBacklog = createMockChallengeModel(
            status: ChallengeStatusEnum.backlog,
            startDate: DateTime.now().add(const Duration(days: 1)));

        ChallengeModel challengeInProgress = createMockChallengeModel(
            status: ChallengeStatusEnum.inProgress,
            startDate: DateTime.now().subtract(const Duration(days: 1)));

        ChallengeModel challengeSuccess = createMockChallengeModel(
            status: ChallengeStatusEnum.success,
            startDate: DateTime.now().subtract(const Duration(days: 2)),
            endDate: DateTime.now().subtract(const Duration(days: 1)));
        challengeSuccess.repetitions.add(createMockRepetitionModel());

        ChallengeModel challengeFailed = createMockChallengeModel(
            status: ChallengeStatusEnum.failed,
            startDate: DateTime.now().subtract(const Duration(days: 2)),
            endDate: DateTime.now().subtract(const Duration(days: 1)));

        List<ChallengeModel> challenges = [
          challengeFailed,
          challengeSuccess,
          challengeInProgress,
          challengeInBacklog
        ];

        // Act
        List<ChallengeModel> sortedChallenges =
            ChallengeModel.sortChallengeList(challenges: challenges);

        // Assert
        expect(sortedChallenges[0].status, equals(ChallengeStatusEnum.backlog));
        expect(
            sortedChallenges[1].status, equals(ChallengeStatusEnum.inProgress));
        expect(sortedChallenges[2].status, equals(ChallengeStatusEnum.failed));
        expect(sortedChallenges[3].status, equals(ChallengeStatusEnum.success));
      });

      test('should sort Challenges by status and percentage with two backlogs',
          () {
        // Arrange
        ChallengeModel challengeInBacklog = createMockChallengeModel(
            status: ChallengeStatusEnum.backlog,
            startDate: DateTime.now().add(const Duration(days: 1)));

        ChallengeModel challengeInProgress = createMockChallengeModel(
            status: ChallengeStatusEnum.inProgress,
            startDate: DateTime.now().subtract(const Duration(days: 1)));

        ChallengeModel challengeSuccess = createMockChallengeModel(
            status: ChallengeStatusEnum.success,
            startDate: DateTime.now().subtract(const Duration(days: 2)),
            endDate: DateTime.now().subtract(const Duration(days: 1)));
        challengeSuccess.repetitions.add(createMockRepetitionModel());

        List<ChallengeModel> challenges = [
          challengeInBacklog,
          challengeSuccess,
          challengeInProgress,
          challengeInBacklog
        ];

        // Act
        List<ChallengeModel> sortedChallenges =
            ChallengeModel.sortChallengeList(challenges: challenges);

        // Assert
        expect(sortedChallenges[0].status, equals(ChallengeStatusEnum.backlog));
        expect(sortedChallenges[1].status, equals(ChallengeStatusEnum.backlog));
        expect(
            sortedChallenges[2].status, equals(ChallengeStatusEnum.inProgress));
        expect(sortedChallenges[3].status, equals(ChallengeStatusEnum.success));
      });
    });

    group('setRepetitionGoals()', () {
      test('should set goal amount to acceptance criteria amount', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        RepetitionModel repetition = createMockRepetitionModel();
        double newGoalAmount = 10;
        repetition.goalAmount = 0;
        challenge.repetitions.add(repetition);

        // Act
        challenge.setGoals(newGoalAmount);

        // Assert
        expect(repetition.goalAmount, equals(newGoalAmount));
      });
    });

    group('getRepetitionGoal()', () {
      test('should return acceptance criteria amount for repetition goal', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel(
            acceptanceCriteria:
                AcceptanceCriteriaModel(amount: 2, unit: 'unit'));

        // Act
        double goalAmount = challenge.getCalculatedRepetitionGoal(1);

        // Assert
        expect(goalAmount, equals(challenge.acceptanceCriteria.amount));
      });
    });
  });
}
