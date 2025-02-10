import 'dart:io';

import 'package:challenge/collections/group_challenges_collection.dart';
import 'package:challenge/enums/participant_status_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_options_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/notification/group_challenge_request_notification_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/simple_components/snack_bar_component.dart';
import 'package:challenge/ui/dialogs/error_occurred_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupChallengesProvider with ChangeNotifier {
  final _groupChallengesCollection = GroupChallengesCollection();
  final _authService = AuthService();
  final _mediaService = MediaService();

  List<GroupChallengeModel> _groupChallenges = [];
  List<GroupChallengeModel> get groupChallenges => _groupChallenges;

  final BuildContext context;

  late final notificationsProvider =
      Provider.of<NotificationsProvider>(context, listen: false);

  GroupChallengesProvider({required this.context});

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
      await notificationsProvider.sendGroupChallengeRequestNotificationToAll(
          currentUser, groupChallenge);
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
          _mediaService.isUrlLocal(groupChallenge.thumbnail!.url)) {
        groupChallenge.thumbnail!.url =
            await _mediaService.uploadLocalThumbnail(
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

  Future<List<GroupChallengeModel>> getAllOfUser() async {
    try {
      _groupChallenges = await _groupChallengesCollection.getAllByUserId(
          userId: _authService.getCurrentUserId());
      sortLocalList();
      return _groupChallenges;
    } on Exception {
      rethrow;
    }
  }

  Future<void> addParticipant(GroupChallengeModel groupChallenge,
      UserModel currentUser, UserModel participantUser) async {
    ParticipantModel participant = ParticipantModel(
        id: participantUser.id,
        user: participantUser,
        status: ParticipantStatusEnum.invited,
        attempts: []);
    groupChallenge.participants.add(participant);
    await _groupChallengesCollection.addParticipant(
        groupChallenge: groupChallenge, participant: participant);
    await notificationsProvider.sendGroupChallengeRequestNotification(
        participantUser, currentUser, groupChallenge);
    updateLocalList(groupChallenge);
  }

  Future<void> deleteParticipant(GroupChallengeModel groupChallenge,
      {String? participantId}) async {
    await _groupChallengesCollection.deleteParticipant(
        groupChallenge: groupChallenge,
        participantId: participantId ?? _authService.getCurrentUserId());
    await notificationsProvider.deleteNotifications(
        userId: participantId ?? _authService.getCurrentUserId(),
        groupChallengeId: groupChallenge.id);
    if (participantId == null ||
        _authService.getCurrentUserId() == participantId) {
      _groupChallenges.removeWhere(
          (groupChallengeEntry) => groupChallengeEntry.id == groupChallenge.id);
      notifyListeners();
    } else {
      groupChallenge.participants
          .removeWhere((participant) => participant.user.id == participantId);
      updateLocalList(groupChallenge);
    }
  }

  void resetLocalList() {
    _groupChallenges = [];
    notifyListeners();
  }

  Future<void> startAttemptOrChallenge(GroupChallengeModel groupChallenge,
      ParticipantModel participant, AttemptModel attempt) async {
    if (groupChallenge.startDate == null ||
        attempt.getStartDate(groupChallenge) == null ||
        groupChallenge.startDate!
            .isBefore(attempt.getStartDate(groupChallenge)!)) {
      attempt.start(groupChallenge);
      await updateAttempt(groupChallenge, participant, attempt);
      return;
    }
    if (groupChallenge.userId == _authService.getCurrentUserId()) {
      SnackBarComponent.showSnackBar(
          'The challenge start date is ${UtilService.dateFormat(groupChallenge.startDate!)}, ${UtilService.timeFormat(groupChallenge.startDate!)}. You can edit the challenge start date in the challenge settings.');
      return;
    }
    SnackBarComponent.showSnackBar(
        'The challenge start date is ${UtilService.dateFormat(groupChallenge.startDate!)}, ${UtilService.timeFormat(groupChallenge.startDate!)}. The admin can edit the challenge start date.');
  }

  Future<void> endAttempt(GroupChallengeModel groupChallenge,
      ParticipantModel participant, AttemptModel attempt) async {
    attempt.end(groupChallenge);
    await updateAttempt(groupChallenge, participant, attempt);
  }

  Future<AttemptModel?> tryAgain(
      GroupChallengeModel groupChallenge, ParticipantModel participant) async {
    if (groupChallenge.endDate?.isBefore(TimeService.now()) ?? false) {
      SnackBarComponent.showSnackBar(
          'The Challenge has ended. Change the challenge end date or create a new challenge');
      return null;
    }
    AttemptModel addedAttempt = participant.addAttempt(groupChallenge);
    await updateParticipant(groupChallenge, participant);
    return addedAttempt;
  }

  Future<void> deleteAttempt(GroupChallengeModel groupChallenge,
      ParticipantModel participant, AttemptModel attempt) async {
    participant.deleteAttempt(attemptNumber: attempt.number);
    await updateParticipant(groupChallenge, participant);
  }

  Future<void> update(GroupChallengeModel groupChallengeCopy) async {
    if (groupChallengeCopy.hasThumbnail() &&
        _mediaService.isUrlLocal(groupChallengeCopy.thumbnail!.url)) {
      groupChallengeCopy.thumbnail!.url =
          await _mediaService.uploadLocalThumbnail(
              groupChallengeCopy.id, groupChallengeCopy.thumbnail!.url);
    }
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
          if (_mediaService.isUrlLocal(media.source)) {
            MediaModel? uploadedMedia = await _mediaService.uploadLocalMedia(
                media, groupChallenge, participant.user.id);
            if (uploadedMedia == null) {
              ErrorOccurredDialog.show(
                  errorText:
                      'Error occurred during media upload. Uploaded media is empty');
              return;
            }
            media.source = uploadedMedia.source;
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
      ErrorOccurredDialog.show(errorText: 'Error occurred during media upload');
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
    if (index == -1) {
      _groupChallenges.insert(0, groupChallenge);
    } else {
      _groupChallenges[index] = groupChallenge;
    }
    sortLocalList();
  }

  Future<void> acceptChallengeRequest(
      GroupChallengeRequestNotificationModel
          groupChallengeRequestNotification) async {
    GroupChallengeModel groupChallenge =
        groupChallengeRequestNotification.groupChallenge;
    ParticipantModel participant = groupChallenge.participants.firstWhere(
        (participant) =>
            participant.user.id == _authService.getCurrentUserId());
    participant.acceptChallengeRequest();
    await updateParticipant(groupChallenge, participant);
    await notificationsProvider
        .deleteNotification(groupChallengeRequestNotification.id);
    await notificationsProvider.sendGroupChallengeAcceptedNotification(
        groupChallengeRequestNotification.fromUser,
        groupChallengeRequestNotification.user,
        groupChallenge);
  }

  Future<void> declineChallengeRequest(
      GroupChallengeRequestNotificationModel
          groupChallengeRequestNotification) async {
    await deleteParticipant(groupChallengeRequestNotification.groupChallenge);
  }

  Future<void> uploadMediaToAttempt(
      GroupChallengeModel groupChallenge,
      ParticipantModel participant,
      AttemptModel attempt,
      MediaModel media) async {
    if (!_mediaService.isUrlLocal(media.source)) {
      return;
    }
    MediaModel? uploadedMedia = await _mediaService.uploadLocalMedia(
        media, groupChallenge, participant.user.id);
    if (uploadedMedia == null) {
      return;
    }
    attempt.media.add(uploadedMedia);
    await updateAttempt(groupChallenge, participant, attempt);
  }

  void deleteMediaFromAttempt(
      GroupChallengeModel groupChallenge,
      ParticipantModel participant,
      AttemptModel attempt,
      MediaModel media) async {
    File file = File(media.source);
    file.exists().then((value) {
      if (value) {
        file.delete();
      }
    });
    await _mediaService.deleteMedia(media);
    attempt.removeMedia(media);
    await updateAttempt(groupChallenge, participant, attempt);
  }
}
