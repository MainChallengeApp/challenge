import 'package:challenge/collections/user_challenges_collection.dart';
import 'package:challenge/collections/users_collection.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final db = FirebaseFirestore.instance;

  Future<void> deleteUserDocuments(String currentUserId) async {
    WriteBatch batch = db.batch();

    DocumentReference userDocRef =
        db.collection(UsersCollection.collectionName).doc(currentUserId);
    batch.delete(userDocRef);

    QuerySnapshot querySnapshot = await db
        .collection(UserChallengesCollection.collectionName)
        .where(UserChallengeModel.userIdField, isEqualTo: currentUserId)
        .get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
