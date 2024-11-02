import 'package:challenge/collections/collection.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChallengesCollection extends Collection {
  static String collectionName = 'group_challenges';
  static String userChallengesSubCollectionName =
      'group_challenge_user_challenges';

  // late CollectionReference<UserChallengeModel> collection = db
  //     .collection(collectionName)
  //     .withConverter<UserChallengeModel>(
  //         fromFirestore: (snapshot, _) => UserChallengeModel.fromDoc(snapshot),
  //         toFirestore: (userChallenge, _) => userChallenge.toDoc());

  GroupChallengesCollection() : super(name: collectionName);

  Future<String> create(GroupChallengeModel groupChallenge) async {
    groupChallenge.titleLowerCase = groupChallenge.title.toLowerCase();

    final batch = FirebaseFirestore.instance.batch();
    final groupChallengeRef =
        FirebaseFirestore.instance.collection(collectionName).doc();
    batch.set(groupChallengeRef, groupChallenge.toDoc());

    for (var userChallenge in groupChallenge.userChallenges) {
      final userChallengeRef =
          groupChallengeRef.collection(userChallengesSubCollectionName).doc();
      batch.set(userChallengeRef, userChallenge.toDoc());
    }

    await batch.commit();

    return groupChallengeRef.id;
  }

  Future<List<GroupChallengeModel>> getAllByUserId(
      {required String userId}) async {
    // Perform a collection group query
    final querySnapshot = await db
        .collectionGroup(userChallengesSubCollectionName)
        .where(UserChallengeModel.userIdField, isEqualTo: userId)
        .get();

    // Set to store unique group challenge IDs
    final Set<String> groupChallengeIds = {};

    // Extract the parent (group challenge) IDs
    for (var doc in querySnapshot.docs) {
      String groupChallengeId = doc.reference.parent.parent!.id;
      groupChallengeIds.add(groupChallengeId);
    }

    // Fetch the actual group challenges
    List<GroupChallengeModel> groupChallenges = [];
    for (var id in groupChallengeIds) {
      final groupChallengeDoc =
          await db.collection(collectionName).doc(id).get();
      if (groupChallengeDoc.exists) {
        final userChallengesQuerySnapshot = await groupChallengeDoc.reference
            .collection(userChallengesSubCollectionName)
            .get();
        groupChallenges.add(GroupChallengeModel.fromDoc(
            groupChallengeDoc, userChallengesQuerySnapshot));
      }
    }

    return groupChallenges;
  }

  // Future<void> update(UserChallengeModel userChallenge) async {
  //   userChallenge.titleLowerCase = userChallenge.title.toLowerCase();
  //   try {
  //     await db
  //         .collection(name)
  //         .doc(userChallenge.id)
  //         .update(userChallenge.toDoc());
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<void> delete(UserChallengeModel userChallenge) {
  //   return db.collection(name).doc(userChallenge.id).delete();
  // }

  // Future<int> getAmountOfChallengesByUserId(String userId) async {
  //   try {
  //     final querySnapshot = await db
  //         .collection(name)
  //         .where(UserChallengeModel.userIdField, isEqualTo: userId)
  //         .get();
  //     return querySnapshot.docs.length;
  //   } on Exception {
  //     rethrow;
  //   }
  // }
}
