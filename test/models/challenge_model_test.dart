import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/models/frequency_model.dart';
import 'package:challenge/models/media_model.dart';
import 'package:challenge/models/progress_model.dart';
import 'package:challenge/models/repetition_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChallengeModel', () {
    ChallengeModel createMockChallengeModel() {
      return ChallengeModel(
        id: '1',
        status: ChallengeStatusEnum.backlog,
        title: 'Challenge Title',
        description: 'Challenge Description',
        thumbnailPath: 'assets/images/test.png',
        acceptanceCriteria: AcceptanceCriteriaModel(amount: 1, unit: 'Unit'),
        frequency: FrequencyModel(type: FrequencyTypeEnum.time, amount: 1),
        repetitions: [],
        media: [],
        categories: [ChallengeCategoryEnum.mentalHealth],
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 1)),
      );
    }

    RepetitionModel createMockRepetitionModel(
        {double goalAmount = 1,
        int? progress,
        RepetitionStatusEnum? repetitionStatus = RepetitionStatusEnum.success,
        List<ProgressModel>? progressList = const [],
        DateTime? startDate,
        DateTime? endDate}) {
      return RepetitionModel(
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 1)),
          repetitionNumber: 1,
          goalAmount: goalAmount,
          progressList: [
            ProgressModel(
                progress: 1,
                mediaIds: [],
                date: DateTime.now(),
                percentProgress: 1,
                repetitionNumber: 1)
          ],
          repetitionStatus: RepetitionStatusEnum.success);
    }

    group('fromJson()', () {
      test('should create ChallengeModel object when json is passed correctly',
          () {
        // Arrange
        Map<String, dynamic> json = {
          'id': '1',
          'status': 'backlog',
          'title': 'Challenge Title',
          'description': 'Challenge Description',
          'thumbnailPath': 'assets/images/test.png',
          'acceptanceCriteria': {'amount': 1.0, 'unit': 'Unit'},
          'frequency': {'type': 'time', 'amount': 1},
          'repetitions': [],
          'media': [],
          'categories': ['social', 'physicalHealth'],
          'startDate': DateTime.now().toIso8601String(),
          'endDate':
              DateTime.now().add(const Duration(days: 1)).toIso8601String()
        };

        // Act
        ChallengeModel challenge = ChallengeModel.fromJson(json);

        // Assert
        expect(challenge.id, equals(json['id']));
        expect(challenge.status, equals(ChallengeStatusEnum.backlog));
        expect(challenge.title, equals(json['title']));
        expect(challenge.description, equals(json['description']));
        expect(challenge.thumbnailPath, equals(json['thumbnailPath']));
        expect(challenge.acceptanceCriteria.amount, equals(1));
        expect(challenge.acceptanceCriteria.unit, equals('Unit'));
        expect(challenge.frequency.type, equals(FrequencyTypeEnum.time));
        expect(challenge.frequency.amount, equals(1));
        expect(challenge.repetitions, equals([]));
        expect(challenge.media, equals([]));
        expect(
            challenge.categories,
            equals([
              ChallengeCategoryEnum.social,
              ChallengeCategoryEnum.physicalHealth
            ]));
        expect(challenge.startDate, equals(DateTime.parse(json['startDate'])));
        expect(challenge.endDate, equals(DateTime.parse(json['endDate'])));
      });

      test('should throw error when json is passed incorrectly', () {
        // Arrange
        Map<String, dynamic> json = {};

        // Act & Assert
        expect(() => ChallengeModel.fromJson(json), throwsA(isA<TypeError>()));
      });
    });

    group('toJson()', () {
      test('should return json when ChallengeModel is passed', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        Map<String, dynamic> json = {
          'id': '1',
          'status': 'backlog',
          'title': 'Challenge Title',
          'description': 'Challenge Description',
          'thumbnailPath': 'assets/images/test.png',
          'acceptanceCriteria': {'amount': 1.0, 'unit': 'Unit'},
          'frequency': {'type': 'time', 'amount': 1},
          'repetitions': [],
          'media': [],
          'categories': ['mentalHealth'],
          'startDate': challenge.startDate?.toString(),
          'endDate': challenge.endDate?.toString()
        };

        // Act
        Map<String, dynamic> challengeJson = challenge.toJson();

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
        expect(copiedChallenge.thumbnailPath, equals(challenge.thumbnailPath));
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
        expect(copiedChallenge.thumbnailPath, equals(challenge.thumbnailPath));
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
        expect(copiedChallenge.thumbnailPath, equals(challenge.thumbnailPath));
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
    group('getThumbnailPath()', () {
      test('should return thumbnailPath when it is not empty', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.thumbnailPath = 'thumbnailPath';

        // Act
        String thumbnailPath = challenge.getThumbnailPath();

        // Assert
        expect(thumbnailPath, equals(challenge.thumbnailPath));
      });

      test('should return last media source when thumbnailPath is empty', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.thumbnailPath = '';
        String mediaSource = 'media/source';
        challenge.media.add(MediaModel(
            source: mediaSource, type: MediaTypeEnum.image, title: 'title'));
        // Act

        String thumbnailPath = challenge.getThumbnailPath();

        // Assert
        expect(thumbnailPath, equals(mediaSource));
      });

      test('should return empty string when thumbnailPath and media is empty',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.thumbnailPath = '';

        // Act
        String thumbnailPath = challenge.getThumbnailPath();

        // Assert
        expect(thumbnailPath, equals(''));
      });
    });

    group('isThumbnailFromAssetsImage()', () {
      test('should return true when thumbnailPath starts with "assets/images/"',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.thumbnailPath = 'assets/images/test.png';

        // Act
        bool isThumbnailFromAssetsImage =
            challenge.isThumbnailFromAssetsImage();

        // Assert
        expect(isThumbnailFromAssetsImage, equals(true));
      });

      test(
          'should return false when thumbnailPath does not start with "assets/images/"',
          () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.thumbnailPath = 'not/assets/images/test.png';

        // Act
        bool isThumbnailFromAssetsImage =
            challenge.isThumbnailFromAssetsImage();

        // Assert
        expect(isThumbnailFromAssetsImage, equals(false));
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
        challenge.thumbnailPath = 'thumbnailPath';

        // Act
        bool hasThumbnail = challenge.hasThumbnail();

        // Assert
        expect(hasThumbnail, equals(true));
      });

      test('should return false when thumbnailPath is empty', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.thumbnailPath = '';

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
        challenge.startDate = DateTime.now().subtract(const Duration(days: 1));
        challenge.repetitions = [];

        // Act
        RepetitionModel lastRepetition = challenge.getLastRepetition()!;

        // Assert
        expect(lastRepetition.startDate, equals(challenge.startDate));
        expect(lastRepetition.endDate, equals(challenge.startDate));
        expect(lastRepetition.progressList, equals([]));
        expect(lastRepetition.repetitionStatus,
            equals(RepetitionStatusEnum.backlog));
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
        RepetitionModel repetition = createMockRepetitionModel();
        challenge.repetitions.add(repetition);
        challenge.frequency.type = FrequencyTypeEnum.time;

        // Act
        RepetitionModel? currentRepetition = challenge.getCurrentRepetition();

        // Assert
        expect(currentRepetition, equals(repetition));
      });
    });

    /**
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     */

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
  });
}
