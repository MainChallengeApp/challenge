import 'package:challenge/collections/group_challenges_collection.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_options_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/notification/group_challenge_request_notification_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/simple_components/snack_bar_component.dart';
import 'package:flutter/material.dart';

class GroupChallengesProvider with ChangeNotifier {
  final _groupChallengesCollection = GroupChallengesCollection();
  final _authService = AuthService();
  final mediaService = MediaService();

  List<GroupChallengeModel> _groupChallenges = [];
  List<GroupChallengeModel> get groupChallenges => _groupChallenges;

  NotificationsProvider notificationsProvider;

  GroupChallengesProvider({required this.notificationsProvider});

  Future<String> create(
      ChallengeModel challenge,
      List<UserModel> participantUsers,
      UserModel currentUser,
      GroupChallengeOptionsModel groupChallengeOptions) async {
    final groupChallenge =
        GroupChallengeModel.fromChallengeWithParticipantUsers(
      challenge: challenge,
      userId: _authService.getCurrentUserId(),
      participantUsers: participantUsers,
      groupChallengeOptions: groupChallengeOptions,
    );
    _groupChallenges.insert(0, groupChallenge);
    sortLocalList();
    try {
      String groupChallengeId = await createOnline(groupChallenge);
      for (var participant in groupChallenge.participants) {
        if (participant.user.id == groupChallenge.userId) {
          continue;
        }
        await notificationsProvider.sendGroupChallengeRequestNotification(
            participant.user, currentUser, groupChallenge);
      }
      return groupChallengeId;
    } on Exception {
      rethrow;
    }
  }

  Future<String> createOnline(GroupChallengeModel groupChallenge) async {
    try {
      groupChallenge.id =
          await _groupChallengesCollection.create(groupChallenge);

      if (groupChallenge.hasThumbnail() &&
          mediaService.isUrlLocal(groupChallenge.thumbnail!.url)) {
        groupChallenge.thumbnail!.url = await mediaService.uploadLocalThumbnail(
            groupChallenge.id, groupChallenge.thumbnail!.url);
        update(groupChallenge);
      }

      _groupChallenges = await getAllOfUser();
      sortLocalList();
      return groupChallenge.id;
    } on Exception {
      rethrow;
    }
  }

  Future<GroupChallengeModel> getById(String id) async {
    try {
      GroupChallengeModel groupChallenge =
          await _groupChallengesCollection.getById(id);
      int index = _groupChallenges.indexWhere(
          (groupChallengeEntry) => groupChallengeEntry.id == groupChallenge.id);
      if (index != -1) {
        _groupChallenges[index] = groupChallenge;
        sortLocalList();
      }
      return groupChallenge;
    } on Exception {
      rethrow;
    }
  }

  getAllOfUser() async {
    try {
      _groupChallenges = await _groupChallengesCollection.getAllByUserId(
          userId: _authService.getCurrentUserId());
      sortLocalList();
      return _groupChallenges;
    } on Exception {
      rethrow;
    }
  }

  Future<void> deleteParticipant(GroupChallengeModel groupChallenge) async {
    await _groupChallengesCollection.deleteParticipant(
        groupChallenge: groupChallenge,
        participantId: _authService.getCurrentUserId());
    _groupChallenges.removeWhere(
        (groupChallengeEntry) => groupChallengeEntry.id == groupChallenge.id);
    notifyListeners();
  }

  void resetLocalList() {
    _groupChallenges = [];
    notifyListeners();
  }

  Future<void> startAttemptOrChallenge(
      GroupChallengeModel groupChallenge,
      ParticipantModel participant,
      AttemptModel attempt,
      BuildContext context) async {
    DateTime? startDate = attempt.getStartDate(groupChallenge);
    if (startDate == null) {
      attempt.start(groupChallenge);
      await updateAttempt(groupChallenge, participant, attempt);
      return;
    }
    if (groupChallenge.userId == _authService.getCurrentUserId()) {
      groupChallenge.startDate = TimeService.now();
      await update(groupChallenge);
      return;
    }
    SnackBarComponent.showSnackBar(context,
        'The Challenge start date is ${UtilService.dateFormat(startDate)}, ${UtilService.timeFormat(startDate)}');
  }

  Future<void> endAttempt(GroupChallengeModel groupChallenge,
      ParticipantModel participant, AttemptModel attempt) async {
    attempt.end(groupChallenge);
    await updateAttempt(groupChallenge, participant, attempt);
  }

  Future<void> update(GroupChallengeModel groupChallengeCopy) async {
    await _groupChallengesCollection.update(groupChallengeCopy);
    updateLocalList(groupChallengeCopy);
  }

  Future<void> updateParticipant(
      GroupChallengeModel groupChallenge, ParticipantModel participant) async {
    int index = groupChallenge.participants.indexWhere(
        (participantEntry) => participantEntry.id == participant.id);
    groupChallenge.participants[index] = participant;
    await _groupChallengesCollection.updateParticipant(
        participant, groupChallenge);
    updateLocalList(groupChallenge);
  }

  Future<void> updateAttempt(GroupChallengeModel groupChallenge,
      ParticipantModel participant, AttemptModel attempt) async {
    participant.attempts = [
      ...participant.attempts
          .where((attemptEntry) => attemptEntry.number != attempt.number),
      attempt
    ];
    try {
      for (var attempt in participant.attempts) {
        for (var media in attempt.media) {
          if (media.isLocal()) {
            mediaService
                .uploadLocalMedia(media, groupChallenge, participant.user.id)
                .then((newMedia) {
              if (newMedia != null) {
                media.source = newMedia.source;
                updateAttempt(groupChallenge, participant, attempt);
              }
            });
          }
        }
      }

      int index = _groupChallenges.indexWhere(
          (groupChallengeEntry) => groupChallengeEntry.id == groupChallenge.id);
      _groupChallenges[index] = groupChallenge;
      sortLocalList();

      await _groupChallengesCollection.updateParticipant(
          participant, groupChallenge);
    } catch (e) {
      rethrow;
    }
  }

  void sortLocalList() async {
    _groupChallenges = GroupChallengeModel.sortChallengeList(
        groupChallenges: _groupChallenges,
        userId: _authService.getCurrentUserId());
    notifyListeners();
  }

  void updateLocalList(GroupChallengeModel groupChallenge) {
    int index = _groupChallenges.indexWhere(
        (groupChallengeEntry) => groupChallengeEntry.id == groupChallenge.id);
    _groupChallenges[index] = groupChallenge;
    sortLocalList();
  }

  Future<void> acceptChallengeRequest(
      GroupChallengeRequestNotificationModel
          groupChallengeRequestNotification) async {
    ParticipantModel participant = groupChallengeRequestNotification
        .groupChallenge.participants
        .firstWhere((participant) =>
            participant.user.id == _authService.getCurrentUserId());
    participant.acceptChallengeRequest();
    await updateParticipant(
        groupChallengeRequestNotification.groupChallenge, participant);
    await notificationsProvider
        .deleteNotification(groupChallengeRequestNotification.id);
  }

  Future<void> declineChallengeRequest(
      GroupChallengeRequestNotificationModel
          groupChallengeRequestNotification) async {
    await deleteParticipant(groupChallengeRequestNotification.groupChallenge);
    await notificationsProvider
        .deleteNotification(groupChallengeRequestNotification.id);
  }
}
