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
  ChallengeModel createMockChallengeModel() {
    return ChallengeModel(
      id: "1",
      status: ChallengeStatusEnum.backlog,
      title: "Challenge Title",
      description: "Challenge Description",
      thumbnailPath: "assets/images/test.png",
      acceptanceCriteria: AcceptanceCriteriaModel(amount: 1, unit: "Unit"),
      frequency: FrequencyModel(type: FrequencyTypeEnum.time, amount: 1),
      repetitions: [],
      media: [],
      categories: [],
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
  group('isChallengeCompleted()', () {
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
    test(
        'should return true when  challenge.thumbnailPath starts with "assets/images/"',
        () {
      // Arrange
      ChallengeModel challenge = createMockChallengeModel();
      challenge.thumbnailPath = 'assets/images/test.png';

      // Act
      bool isThumbnailFromAssetsImage = challenge.isThumbnailFromAssetsImage();

      // Assert
      expect(isThumbnailFromAssetsImage, equals(true));
    });

    test(
        'should return false when  challenge.thumbnailPath does not start with "assets/images/"',
        () {
      // Arrange
      ChallengeModel challenge = createMockChallengeModel();
      challenge.thumbnailPath = 'not/assets/images/test.png';

      // Act
      bool isThumbnailFromAssetsImage = challenge.isThumbnailFromAssetsImage();

      // Assert
      expect(isThumbnailFromAssetsImage, equals(false));
    });
  });
}
