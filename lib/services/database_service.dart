import 'package:challenge/collections/group_challenges_collection.dart';
import 'package:challenge/collections/users_collection.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static int maxCharactersShort = 50;
  static int maxCharactersMedium = 100;
  static int maxCharactersLong = 500;
  static int maxGroupChallengeMember = 100;

  final db = FirebaseFirestore.instance;
  final groupChallengesCollection = GroupChallengesCollection();

  Future<void> deleteUserFromDatabase(String currentUserId) async {
    WriteBatch batch = db.batch();

    deleteConnections(currentUserId, batch);

    deleteUser(currentUserId, batch);

    await deleteChallenges(currentUserId);

    await batch.commit();
  }

  Future<void> deleteChallenges(String currentUserId) async {
    List<GroupChallengeModel> groupChallenges =
        await groupChallengesCollection.getAllByUserId(userId: currentUserId);

    for (var groupChallenge in groupChallenges) {
      groupChallengesCollection.deleteParticipant(
          groupChallenge: groupChallenge, participantId: currentUserId);
    }
  }

  void deleteUser(String currentUserId, WriteBatch batch) async {
    DocumentReference userDocRef =
        db.collection(UsersCollection.collectionName).doc(currentUserId);
    batch.delete(userDocRef);
  }

  Future<void> deleteConnections(String currentUserId, WriteBatch batch) async {
    QuerySnapshot querySnapshot = await db
        .collection(UsersCollection.collectionName)
        .where(UserModel.connectionIdsField, arrayContains: currentUserId)
        .get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      UserModel user = UserModel.fromDoc(doc);
      user.disconnect(currentUserId);
      batch.update(doc.reference, user.toDoc());
    }
  }
}
