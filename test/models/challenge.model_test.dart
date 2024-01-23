import 'package:challenge/enums/challenge_status.enum.dart';
import 'package:challenge/models/challenge.model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Challenge Model', () {
    test('check challenge status', () {
      // Arrange
      ChallengeModel challenge = ChallengeModel(
          status: ChallengeStatusEnum.inProgress,
          title: 'title',
          description: 'description',
          thumbnailPath: 'thumbnailPath',
          acceptanceCriterias: [],
          media: []);
      // Act
      // Assert
      expect(challenge.status, equals(ChallengeStatusEnum.inProgress));
    });

    // You can add more tests here
  });
}
