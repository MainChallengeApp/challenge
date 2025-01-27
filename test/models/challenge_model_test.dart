import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/models/challenge/acceptance_criteria_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/thumbnail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../services/faker_service.dart';
import 'acceptance_criteria_model_test.dart';
import 'frequency_model_test.dart';
import 'media_model_test.dart';
import 'thumbnail_model_test.dart';

void main() {
  group('ChallengeModel', () {
    ChallengeModel createMockChallengeModel(
        {String? id,
        ChallengeStatusEnum? status,
        String? title,
        String? titleLowerCase,
        String? description,
        DateTime? startDate,
        DateTime? endDate,
        AcceptanceCriteriaModel? acceptanceCriteria,
        ThumbnailModel? thumbnail,
        FrequencyModel? frequency,
        List<MediaModel>? media,
        List<ChallengeCategoryEnum>? categories}) {
      return ChallengeModel(
        id: id ?? FakerService.guid(),
        status: status ?? FakerService.randomObject(ChallengeStatusEnum.values),
        title: title ?? FakerService.word(),
        titleLowerCase: titleLowerCase ?? FakerService.word(),
        description: description ?? FakerService.word(),
        thumbnail: thumbnail ?? mockThumbnailModel(),
        acceptanceCriteria: acceptanceCriteria ?? mockAcceptanceCriteriaModel(),
        frequency: frequency ?? mockFrequencyModel(),
        media: media ?? FakerService.list((_) => mockMediaModel()),
        categories: categories ??
            List.from(Set.from(FakerService.list(
                    (_) =>
                        FakerService.randomObject(ChallengeCategoryEnum.values),
                    max: 2))
                .toList()),
        startDate: startDate ?? FakerService.dateTime(),
        endDate: endDate ?? FakerService.dateTime(),
      );
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
          ChallengeModel.statusField: challenge.status.status,
          ChallengeModel.titleField: challenge.title,
          ChallengeModel.titleLowerCaseField: challenge.title.toLowerCase(),
          ChallengeModel.descriptionField: challenge.description,
          ChallengeModel.thumbnailField: challenge.thumbnail!.toDoc(),
          ChallengeModel.acceptanceCriteriaField:
              challenge.acceptanceCriteria.toDoc(),
          ChallengeModel.frequencyField: challenge.frequency.toDoc(),
          ChallengeModel.mediaField:
              challenge.media.map((media) => media.toDoc()).toList(),
          ChallengeModel.categoriesField:
              ChallengeCategoryEnum.toDocs(challenge.categories),
          ChallengeModel.startDateField: challenge.startDate,
          ChallengeModel.endDateField: challenge.endDate,
          ChallengeModel.createdAtField: challenge.createdAt
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
        ChallengeModel copiedChallenge = challenge.copy(withId: true);

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
        expect(copiedChallenge.media.length, equals(challenge.media.length));
        expect(copiedChallenge.categories, equals(challenge.categories));
        expect(copiedChallenge.startDate, equals(challenge.startDate));
        expect(copiedChallenge.endDate, equals(challenge.endDate));
      });

      test('should copy challenge without id when challenge is passed', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();

        // Act
        ChallengeModel copiedChallenge = challenge.copy(withId: false);

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
        expect(copiedChallenge.media.length, equals(challenge.media.length));
        expect(copiedChallenge.categories, equals(challenge.categories));
        expect(copiedChallenge.startDate, equals(challenge.startDate));
        expect(copiedChallenge.endDate, equals(challenge.endDate));
      });

      test('should copy challenge with try again when challenge is passed', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();

        // Act
        ChallengeModel copiedChallenge = challenge.copy(isTryAgain: true);

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

    group('setEndDate()', () {
      test('should not change end date when start date is null', () {
        // Arrange
        ChallengeModel challenge = createMockChallengeModel();
        challenge.startDate = null;

        // Act
        challenge.calcEndDate();

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
        challenge.calcEndDate();

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
        challenge.calcEndDate();

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
  });
}
