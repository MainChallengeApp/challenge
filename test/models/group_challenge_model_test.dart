import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/models/challenge/acceptance_criteria_model.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_options_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/challenge/thumbnail_model.dart';
import 'package:challenge/services/time_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../services/faker_service.dart';
import 'acceptance_criteria_model_test.dart';
import 'attempt_model_test.dart';
import 'frequency_model_test.dart';
import 'group_challenge_options_model_test.dart';
import 'media_model_test.dart';
import 'participant_model_test.dart';
import 'thumbnail_model_test.dart';

GroupChallengeModel mockGroupChallengeModel({
  String? id,
  String? userId,
  List<ParticipantModel>? participants,
  ChallengeStatusEnum? status,
  String? title,
  String? titleLowerCase,
  String? description,
  ThumbnailModel? thumbnail,
  DateTime? startDate,
  DateTime? endDate,
  AcceptanceCriteriaModel? acceptanceCriteria,
  FrequencyModel? frequency,
  List<MediaModel>? media,
  List<ChallengeCategoryEnum>? categories,
  GroupChallengeOptionsModel? groupChallengeOptions,
  DateTime? createdAt,
}) {
  return GroupChallengeModel(
    id: id ?? FakerService.guid(),
    userId: userId ?? FakerService.guid(),
    participants:
        participants ?? FakerService.list((_) => mockParticipantModel()),
    status: status ?? FakerService.randomObject(ChallengeStatusEnum.values),
    title: title ?? FakerService.word(),
    titleLowerCase: titleLowerCase ?? FakerService.word(),
    description: description ?? FakerService.word(),
    thumbnail: thumbnail ?? mockThumbnailModel(),
    startDate: startDate ?? FakerService.dateTime(),
    endDate: endDate ?? FakerService.dateTime(),
    acceptanceCriteria: acceptanceCriteria ?? mockAcceptanceCriteriaModel(),
    frequency: frequency ?? mockFrequencyModel(),
    media: media ?? FakerService.list((_) => mockMediaModel()),
    categories: categories ??
        List.from(Set.from(FakerService.list(
                (_) => FakerService.randomObject(ChallengeCategoryEnum.values),
                max: 2))
            .toList()),
    groupChallengeOptions:
        groupChallengeOptions ?? mockGroupChallengeOptionsModel(),
    createdAt: createdAt ?? FakerService.dateTime(),
  );
}

void main() {
  group('GroupChallengeModel', () {
    group('toDoc()', () {
      test('should return document of group challenge model', () {
        // arrange
        // act
        // assert
      });
    });

    group('getPositionOf()', () {
      test('should return position of participant', () {
        // arrange
        final userId = FakerService.guid();
        final DateTime startDate = TimeService.now()
            .subtract(Duration(days: FakerService.integer(max: 20)));
        final DateTime endDate = TimeService.now();
        final groupChallenge = mockGroupChallengeModel(
          startDate: startDate,
          endDate: endDate,
          participants: [
            mockParticipantModel(id: userId, userId: userId, attempts: [
              mockAttemptModel(startDate: startDate, endDate: endDate)
            ]),
            mockParticipantModel(id: '1', userId: '1', attempts: [
              mockAttemptModel(startDate: startDate, endDate: endDate)
            ]),
            mockParticipantModel(id: '2', userId: '2', attempts: [
              mockAttemptModel(startDate: startDate, endDate: endDate)
            ]),
            mockParticipantModel(id: '3', userId: '3', attempts: [
              mockAttemptModel(startDate: startDate, endDate: endDate)
            ]),
          ],
        );
        groupChallenge.sortParticipants();
        // act
        final position = groupChallenge.getPositionOf(userId);
        // assert
        expect(
            position,
            groupChallenge.participants.indexWhere(
                  (participant) => participant.userId == userId,
                ) +
                1);
      });

      test('should throw error if participant not found', () {
        // arrange
        final DateTime startDate = TimeService.now()
            .subtract(Duration(days: FakerService.integer(max: 20)));
        final DateTime endDate = TimeService.now();
        final groupChallenge = mockGroupChallengeModel(
          startDate: startDate,
          endDate: endDate,
          participants: [
            mockParticipantModel(id: '1', userId: '1', attempts: [
              mockAttemptModel(startDate: startDate, endDate: endDate)
            ]),
            mockParticipantModel(id: '2', userId: '2', attempts: [
              mockAttemptModel(startDate: startDate, endDate: endDate)
            ]),
            mockParticipantModel(id: '3', userId: '3', attempts: [
              mockAttemptModel(startDate: startDate, endDate: endDate)
            ]),
          ],
        );
        // assert
        expect(() => groupChallenge.getPositionOf('4'), throwsException);
      });
    });
  });
}
