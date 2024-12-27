import 'package:challenge/enums/participant_status_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../services/faker_service.dart';
import 'attempt_model_test.dart';
import 'group_challenge_model_test.dart';
import 'user/user_model_test.dart';

ParticipantModel mockParticipantModel({
  String? id,
  UserModel? user,
  List<AttemptModel>? attempts,
}) {
  return ParticipantModel(
    id: id ?? FakerService.guid(),
    user: user ?? mockUserModel(),
    status: FakerService.randomObject(ParticipantStatusEnum.values),
    attempts: attempts ?? FakerService.list((_) => mockAttemptModel()),
  );
}

void main() {
  group('ParticipantModel', () {
    group('toDoc()', () {
      test('should return document of participant model', () {
        // arrange
        ParticipantModel participant = mockParticipantModel();
        // act
        final doc = participant.toDoc();
        // assert
        expect(doc[ParticipantModel.userIdField], participant.user.id);
        expect(doc[ParticipantModel.attemptsField],
            participant.attempts.map((attempt) => attempt.toDoc()).toList());
      });
    });

    group('fromDoc()', () {
      test('should return participant model from document', () {
        // TODO: probably use fake_cloud_firestore package
        // // arrange
        // ParticipantModel participant = mockParticipantModel();
        // Map<String, dynamic> doc  = participant.toDoc();
        // // act
        // final result = ParticipantModel.fromDoc(doc);
        // // assert
        // expect(result.userId, participant.userId);
        // expect(result.attempts.length, participant.attempts.length);
      }, skip: 'mock DocumentSnapshot');
    });

    group('getLatestAttempt()', () {
      test('should return latest attempt', () {
        // arrange
        ParticipantModel participant = mockParticipantModel(
            attempts: FakerService.list(
                (index) => mockAttemptModel(number: index),
                min: 1));
        // act
        AttemptModel result = participant.getLatestAttempt();
        // assert
        expect(result, participant.attempts.last);
      });
    });

    group('copy()', () {
      test('should return copy of participant model', () {
        // arrange
        ParticipantModel participant = mockParticipantModel();
        // act
        final copy = participant.copy();
        // assert
        expect(copy.user, participant.user);
        for (int i = 0; i < participant.attempts.length; i++) {
          expect(copy.attempts[i].number, participant.attempts[i].number);
          expect(copy.attempts[i].status, participant.attempts[i].status);
        }
      });
    });

    group('copyList()', () {
      test('should return copy of participant model list', () {
        // arrange
        List<ParticipantModel> participants =
            FakerService.list((_) => mockParticipantModel());
        // act
        final copy = ParticipantModel.copyList(participants);
        // assert
        for (int i = 0; i < participants.length; i++) {
          expect(copy[i].user.id, participants[i].user.id);
          expect(copy[i].attempts.length, participants[i].attempts.length);
        }
      });
    });

    group('addAttempt()', () {
      test('should add attempt to participant model', () {
        // arrange
        ParticipantModel participant = mockParticipantModel(
            attempts: FakerService.list((_) => mockAttemptModel(), min: 1));
        int attemptsLength = participant.attempts.length;
        // act
        participant.addAttempt(mockGroupChallengeModel());
        // assert
        expect(participant.attempts.length, attemptsLength + 1);
      });
    });
  });
}
