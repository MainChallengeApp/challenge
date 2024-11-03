import 'package:challenge/collections/group_challenges_collection.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/services/storage_service.dart';
import 'package:flutter/material.dart';

class GroupChallengesProvider with ChangeNotifier {
  final groupChallengesCollection = GroupChallengesCollection();
  final authService = AuthService();
  final storageService = StorageService();
  final mediaService = MediaService();

  List<GroupChallengeModel> _groupChallenges = [];
  List<GroupChallengeModel> get groupChallenges => _groupChallenges;

  Future<void> create(ChallengeModel challenge, List<UserModel> members) async {
    final groupChallenge = GroupChallengeModel.fromChallengeModelWithMembers(
      challenge: challenge,
      userId: authService.getCurrentUserId(),
      members: members,
    );
    _groupChallenges.insert(0, groupChallenge);
    // sortLocalList();
    notifyListeners();
    try {
      await createOnline(groupChallenge);
    } on Exception {
      rethrow;
    }
  }

  Future<void> createOnline(GroupChallengeModel groupChallenge) async {
    try {
      // GroupChallengeModel newGroupChallenge =
      // await groupChallengesCollection.create(groupChallenge);

      // if (newGroupChallenge.hasThumbnail() &&
      //     mediaService.isUrlLocal(newGroupChallenge.thumbnail!.url)) {
      //   newGroupChallenge.thumbnail!.url =
      //       await mediaService.uploadLocalThumbnail(
      //           newGroupChallenge.id, newGroupChallenge.thumbnail!.url);
      //   update(newGroupChallenge);
      // }

      // _groupChallenges = await getAllOfUser();
      // sortLocalList();
      await groupChallengesCollection.create(groupChallenge);
    } on Exception {
      rethrow;
    }
  }

  getAllOfUser() async {
    try {
      _groupChallenges = await groupChallengesCollection.getAllByUserId(
          userId: authService.getCurrentUserId());
      // sortLocalList();
      notifyListeners();
      return _groupChallenges;
    } on Exception {
      rethrow;
    }
  }

  // TODO
  delete(GroupChallengeModel challenge) {}

  void resetLocalList() {
    _groupChallenges = [];
    notifyListeners();
  }

  // update(UserChallengeModel userChallenge) async {
  //   try {
  //     if (userChallenge.hasThumbnail() &&
  //         mediaService.isUrlLocal(userChallenge.thumbnail!.url)) {
  //       userChallenge.thumbnail!.url = await mediaService.uploadLocalThumbnail(
  //           userChallenge.id, userChallenge.thumbnail!.url);
  //     }

  //     for (var media in userChallenge.media) {
  //       if (media.isLocal()) {
  //         mediaService.uploadLocalMedia(media, userChallenge).then((newMedia) {
  //           if (newMedia != null) {
  //             media.source = newMedia.source;
  //             update(userChallenge);
  //           }
  //         });
  //       }
  //     }

  //     int index = _groupChallenges.indexWhere((uc) => uc.id == userChallenge.id);
  //     if (index != -1) {
  //       _groupChallenges[index] = userChallenge;
  //       sortLocalList();
  //     }

  //     groupChallengesCollection.update(userChallenge);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<void> delete(UserChallengeModel userChallenge) async {
  //   try {
  //     int index = _groupChallenges.indexWhere((uc) => uc.id == userChallenge.id);
  //     if (index != -1) {
  //       _groupChallenges.removeAt(index);
  //       notifyListeners();
  //     }
  //     groupChallengesCollection.delete(userChallenge);
  //     storageService.deleteFolderByPath(
  //         '${UserChallengesCollection.collectionName}/${userChallenge.id}');
  //   } on Exception {
  //     rethrow;
  //   }
  // }

  // start(UserChallengeModel userChallenge) {
  //   userChallenge.start();
  //   update(userChallenge);
  // }

  // end(UserChallengeModel userChallenge) {
  //   userChallenge.end();
  //   update(userChallenge);
  // }

  // void sortLocalList() {
  //   _groupChallenges =
  //       GroupChallengeModel.sortChallengeList(challenges: _groupChallenges);
  //   notifyListeners();
  // }

  // void resetLocalList() {
  //   _groupChallenges = [];
  //   notifyListeners();
  // }

  // Future<int> getAmountOfChallengesByUserId(String userId) async {
  //   return await groupChallengesCollection.getAmountOfChallengesByUserId(userId);
  // }
}
