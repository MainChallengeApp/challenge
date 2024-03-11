import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/models/frequency_model.dart';
import 'package:challenge/models/media_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('searchInChallenge()', () {
    test('should be in search when all title is passed to function', () {
      // Arrange
      ChallengeModel challenge = ChallengeModel(
          status: ChallengeStatusEnum.inProgress,
          title: 'title',
          description: 'description',
          thumbnailPath: 'thumbnailPath',
          acceptanceCriterias: [
            AcceptanceCriteriaModel(
                id: 1,
                title: 'title',
                amount: 2,
                unit: 'unit',
                frequency: FrequencyModel(
                    type: FrequencyTypeEnum.daily, currentAmount: 0),
                tracking: 'tracking',
                currentProgress: 2,
                repetitions: [])
          ],
          media: []);
      // Act
      bool isInSearch = challenge.searchInChallenge('title');
      // Assert
      expect(isInSearch, equals(true));
    });

    test(
        'should not be in search when passed string is not in any Challenge property',
        () {
      // Arrange
      ChallengeModel challenge = ChallengeModel(
          status: ChallengeStatusEnum.inProgress,
          title: 'title',
          description: 'description',
          thumbnailPath: 'thumbnailPath',
          acceptanceCriterias: [
            AcceptanceCriteriaModel(
                id: 1,
                title: 'title',
                amount: 2,
                unit: 'unit',
                frequency: FrequencyModel(
                    type: FrequencyTypeEnum.daily, currentAmount: 0),
                tracking: 'tracking',
                currentProgress: 2,
                repetitions: [])
          ],
          media: []);
      // Act
      bool isInSearch = challenge.searchInChallenge('x');
      // Assert
      expect(isInSearch, equals(false));
    });
  });
  group('isChallengeCompleted()', () {
    test('should be completed when all acceptance criteras are completed', () {
      // Arrange
      ChallengeModel challenge = ChallengeModel(
          status: ChallengeStatusEnum.inProgress,
          title: 'title',
          description: 'description',
          thumbnailPath: 'thumbnailPath',
          acceptanceCriterias: [
            AcceptanceCriteriaModel(
                id: 1,
                title: 'title',
                amount: 2,
                unit: 'unit',
                frequency: FrequencyModel(
                    type: FrequencyTypeEnum.daily, currentAmount: 0),
                tracking: 'tracking',
                currentProgress: 2,
                repetitions: []),
            AcceptanceCriteriaModel(
                id: 2,
                title: 'title',
                amount: 1,
                unit: 'unit',
                frequency: FrequencyModel(
                    type: FrequencyTypeEnum.daily, currentAmount: 0),
                tracking: 'tracking',
                currentProgress: 1,
                repetitions: [])
          ],
          media: []);
      // Act
      bool isCompleted = challenge.isChallengeCompleted();
      // Assert
      expect(isCompleted, equals(true));
    });

    test(
        'should not be completed when one acceptance criteras is not completed',
        () {
      // Arrange
      ChallengeModel challenge = ChallengeModel(
          status: ChallengeStatusEnum.inProgress,
          title: 'title',
          description: 'description',
          thumbnailPath: 'thumbnailPath',
          acceptanceCriterias: [
            AcceptanceCriteriaModel(
                id: 1,
                title: 'title',
                amount: 2,
                unit: 'unit',
                frequency: FrequencyModel(
                    type: FrequencyTypeEnum.daily, currentAmount: 0),
                tracking: 'tracking',
                currentProgress: 1,
                repetitions: []),
            AcceptanceCriteriaModel(
                id: 2,
                title: 'title',
                amount: 1,
                unit: 'unit',
                frequency: FrequencyModel(
                    type: FrequencyTypeEnum.daily, currentAmount: 0),
                tracking: 'tracking',
                currentProgress: 1,
                repetitions: [])
          ],
          media: []);
      // Act
      bool isCompleted = challenge.isChallengeCompleted();
      // Assert
      expect(isCompleted, equals(false));
    });
  });

  group('checkChallengeStatus()', () {
    test('should be success when all acceptance criteras are completed', () {
      // Arrange
      ChallengeModel challenge = ChallengeModel(
          status: ChallengeStatusEnum.inProgress,
          title: 'title',
          description: 'description',
          thumbnailPath: 'thumbnailPath',
          endDate: DateTime.now().add(const Duration(days: 1)),
          acceptanceCriterias: [
            AcceptanceCriteriaModel(
                id: 1,
                title: 'title',
                amount: 2,
                unit: 'unit',
                frequency: FrequencyModel(
                    type: FrequencyTypeEnum.daily, currentAmount: 0),
                tracking: 'tracking',
                currentProgress: 2,
                repetitions: []),
            AcceptanceCriteriaModel(
                id: 2,
                title: 'title',
                amount: 1,
                unit: 'unit',
                frequency: FrequencyModel(
                    type: FrequencyTypeEnum.daily, currentAmount: 0),
                tracking: 'tracking',
                currentProgress: 1,
                repetitions: [])
          ],
          media: []);
      // Act
      challenge.checkChallengeStatus();
      // Assert
      expect(challenge.status, equals(ChallengeStatusEnum.success));
    });

    test(
        'should be failed when one acceptance criteras is not completed and endDate is before now',
        () {
      // Arrange
      ChallengeModel challenge = ChallengeModel(
          status: ChallengeStatusEnum.inProgress,
          title: 'title',
          description: 'description',
          thumbnailPath: 'thumbnailPath',
          acceptanceCriterias: [
            AcceptanceCriteriaModel(
                id: 1,
                title: 'title',
                amount: 2,
                unit: 'unit',
                frequency: FrequencyModel(
                    type: FrequencyTypeEnum.daily, currentAmount: 0),
                tracking: 'tracking',
                currentProgress: 1,
                repetitions: []),
            AcceptanceCriteriaModel(
                id: 2,
                title: 'title',
                amount: 1,
                unit: 'unit',
                frequency: FrequencyModel(
                    type: FrequencyTypeEnum.daily, currentAmount: 0),
                tracking: 'tracking',
                currentProgress: 1,
                repetitions: [])
          ],
          endDate: DateTime.now().subtract(const Duration(days: 1)),
          media: []);
      // Act
      challenge.checkChallengeStatus();
      // Assert
      expect(challenge.status, equals(ChallengeStatusEnum.failed));
    });

    test(
        'should be backlog when one acceptance criteras is not completed and startDate is after now',
        () {
      // Arrange
      ChallengeModel challenge = ChallengeModel(
          status: ChallengeStatusEnum.inProgress,
          title: 'title',
          description: 'description',
          thumbnailPath: 'thumbnailPath',
          acceptanceCriterias: [
            AcceptanceCriteriaModel(
                id: 1,
                title: 'title',
                amount: 2,
                unit: 'unit',
                frequency: FrequencyModel(
                    type: FrequencyTypeEnum.daily, currentAmount: 0),
                tracking: 'tracking',
                currentProgress: 1,
                repetitions: []),
            AcceptanceCriteriaModel(
                id: 2,
                title: 'title',
                amount: 1,
                unit: 'unit',
                frequency: FrequencyModel(
                    type: FrequencyTypeEnum.daily, currentAmount: 0),
                tracking: 'tracking',
                currentProgress: 1,
                repetitions: [])
          ],
          startDate: DateTime.now().add(const Duration(days: 1)),
          media: []);
      // Act
      challenge.checkChallengeStatus();
      // Assert
      expect(challenge.status, equals(ChallengeStatusEnum.backlog));
    });

    test(
        'should be inProgress when one acceptance criteras is not completed and startDate is before now and endDate is after now',
        () {
      // Arrange
      ChallengeModel challenge = ChallengeModel(
          status: ChallengeStatusEnum.inProgress,
          title: 'title',
          description: 'description',
          thumbnailPath: 'thumbnailPath',
          acceptanceCriterias: [
            AcceptanceCriteriaModel(
                id: 1,
                title: 'title',
                amount: 2,
                unit: 'unit',
                frequency: FrequencyModel(
                    type: FrequencyTypeEnum.daily, currentAmount: 0),
                tracking: 'tracking',
                currentProgress: 1,
                repetitions: []),
            AcceptanceCriteriaModel(
                id: 2,
                title: 'title',
                amount: 1,
                unit: 'unit',
                frequency: FrequencyModel(
                    type: FrequencyTypeEnum.daily, currentAmount: 0),
                tracking: 'tracking',
                currentProgress: 1,
                repetitions: [])
          ],
          startDate: DateTime.now().subtract(const Duration(days: 1)),
          endDate: DateTime.now().add(const Duration(days: 1)),
          media: []);
      // Act
      challenge.checkChallengeStatus();
      // Assert
      expect(challenge.status, equals(ChallengeStatusEnum.inProgress));
    });
  });

  group('getThumbnailPath()', () {
    test('should return thumbnailPath when it is not empty', () {
      // Arrange
      ChallengeModel challenge = ChallengeModel(
          status: ChallengeStatusEnum.inProgress,
          title: 'title',
          description: 'description',
          thumbnailPath: 'thumbnailPath',
          acceptanceCriterias: [],
          media: []);
      // Act
      String thumbnailPath = challenge.getThumbnailPath();
      // Assert
      expect(thumbnailPath, equals('thumbnailPath'));
      expect(thumbnailPath, equals(challenge.thumbnailPath));
    });

    test('should return last media source when thumbnailPath is empty', () {
      // Arrange
      ChallengeModel challenge = ChallengeModel(
          status: ChallengeStatusEnum.inProgress,
          title: 'title',
          description: 'description',
          thumbnailPath: '',
          acceptanceCriterias: [],
          media: [
            MediaModel(
                id: '1',
                title: 'media1',
                source: 'source1',
                type: MediaTypeEnum.image),
            MediaModel(
                id: '2',
                title: 'media2',
                source: 'source2',
                type: MediaTypeEnum.image)
          ]);
      // Act
      String thumbnailPath = challenge.getThumbnailPath();
      // Assert
      expect(thumbnailPath, equals('source2'));
      expect(thumbnailPath, equals(challenge.thumbnailPath));
    });

    test('should return empty string when thumbnailPath and media is empty',
        () {
      // Arrange
      ChallengeModel challenge = ChallengeModel(
          status: ChallengeStatusEnum.inProgress,
          title: 'title',
          description: 'description',
          thumbnailPath: '',
          acceptanceCriterias: [],
          media: []);
      // Act
      String thumbnailPath = challenge.getThumbnailPath();
      // Assert
      expect(thumbnailPath, equals(''));
      expect(thumbnailPath, equals(challenge.thumbnailPath));
    });
  });

  group('isThumbnailFromAssetsImage()', () {
    test('should return true when starts with "assets/images/"', () {
      // Arrange
      ChallengeModel challenge = ChallengeModel(
          status: ChallengeStatusEnum.inProgress,
          title: 'title',
          description: 'description',
          thumbnailPath: 'assets/images/image.png',
          acceptanceCriterias: [],
          media: []);
      // Act
      bool isThumbnailFromAssetsImage = challenge.isThumbnailFromAssetsImage();
      // Assert
      expect(isThumbnailFromAssetsImage, equals(true));
    });

    test('should return false when not starts with "assets/images/"', () {
      // Arrange
      ChallengeModel challenge = ChallengeModel(
          status: ChallengeStatusEnum.inProgress,
          title: 'title',
          description: 'description',
          thumbnailPath: 'assets/ima',
          acceptanceCriterias: [],
          media: []);
      // Act
      bool isThumbnailFromAssetsImage = challenge.isThumbnailFromAssetsImage();
      // Assert
      expect(isThumbnailFromAssetsImage, equals(false));
    });
  });
}
