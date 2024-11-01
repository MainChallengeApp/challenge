import 'package:challenge/collections/user_challenges_collection.dart';
import 'package:challenge/collections/users_collection.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static int maxCharactersShort = 50;
  static int maxCharactersMedium = 100;
  static int maxCharactersLong = 500;

  final db = FirebaseFirestore.instance;

  Future<void> deleteUserFromDatabase(String currentUserId) async {
    WriteBatch batch = db.batch();

    deleteUserConnections(currentUserId, batch);

    deleteUser(currentUserId, batch);

    await deleteUserChallenges(currentUserId, batch);

    await batch.commit();
  }

  Future<void> deleteUserChallenges(
      String currentUserId, WriteBatch batch) async {
    QuerySnapshot querySnapshot = await db
        .collection(UserChallengesCollection.collectionName)
        .where(UserChallengeModel.userIdField, isEqualTo: currentUserId)
        .get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
  }

  void deleteUser(String currentUserId, WriteBatch batch) async {
    DocumentReference userDocRef =
        db.collection(UsersCollection.collectionName).doc(currentUserId);
    batch.delete(userDocRef);
  }

  Future<void> deleteUserConnections(
      String currentUserId, WriteBatch batch) async {
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
