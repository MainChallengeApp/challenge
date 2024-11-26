import 'package:challenge/collections/collection.dart';
import 'package:challenge/collections/users_collection.dart';
import 'package:challenge/exceptions/group_challenge_not_found_exception.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChallengesCollection extends Collection {
  static String collectionName = 'group_challenges';
  static String participantsSubCollection = 'participants';

  final _usersCollection = UsersCollection();

  GroupChallengesCollection() : super(name: collectionName);

  final _storageService = StorageService();

  Future<String> create(GroupChallengeModel groupChallenge) async {
    groupChallenge.titleLowerCase = groupChallenge.title.toLowerCase();

    final batch = FirebaseFirestore.instance.batch();
    final groupChallengeRef =
        FirebaseFirestore.instance.collection(collectionName).doc();
    batch.set(groupChallengeRef, groupChallenge.toDoc());

    for (var participant in groupChallenge.participants) {
      final participantRef = groupChallengeRef
          .collection(participantsSubCollection)
          .doc(participant.user.id);
      batch.set(participantRef, participant.toDoc());
    }

    await batch.commit();

    return groupChallengeRef.id;
  }

  Future<void> addParticipant(
      {required GroupChallengeModel groupChallenge,
      required ParticipantModel participant}) async {
    try {
      await db
          .collection(collectionName)
          .doc(groupChallenge.id)
          .collection(participantsSubCollection)
          .doc(participant.user.id)
          .set(participant.toDoc());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GroupChallengeModel>> getAllByUserId(
      {required String userId}) async {
    // Perform a collection group query
    final querySnapshot = await db
        .collectionGroup(participantsSubCollection)
        .where(ParticipantModel.userIdField, isEqualTo: userId)
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
        final participantsQuerySnapshot = await groupChallengeDoc.reference
            .collection(participantsSubCollection)
            .get();

        List<ParticipantModel> participants =
            await Future.wait(participantsQuerySnapshot.docs.map((doc) async {
          return ParticipantModel.fromDoc(
              doc, await _usersCollection.getById(doc.id));
        }));

        groupChallenges
            .add(GroupChallengeModel.fromDoc(groupChallengeDoc, participants));
      }
    }

    return groupChallenges;
  }

  Future<GroupChallengeModel> getById(String id) async {
    try {
      final groupChallengeDoc =
          await db.collection(collectionName).doc(id).get();
      if (groupChallengeDoc.exists) {
        final participantsQuerySnapshot = await groupChallengeDoc.reference
            .collection(participantsSubCollection)
            .get();

        List<ParticipantModel> participants =
            await Future.wait(participantsQuerySnapshot.docs.map((doc) async {
          return ParticipantModel.fromDoc(
              doc, await _usersCollection.getById(doc.id));
        }));

        return GroupChallengeModel.fromDoc(groupChallengeDoc, participants);
      } else {
        throw GroupChallengeNotFoundException(id);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateParticipant(
      ParticipantModel participant, GroupChallengeModel groupChallenge) async {
    await db
        .collection(collectionName)
        .doc(groupChallenge.id)
        .collection(participantsSubCollection)
        .doc(participant.user.id)
        .update(participant.toDoc());
  }

  Future<void> update(GroupChallengeModel groupChallengeCopy) async {
    groupChallengeCopy.titleLowerCase = groupChallengeCopy.title.toLowerCase();
    try {
      await db
          .collection(collectionName)
          .doc(groupChallengeCopy.id)
          .update(groupChallengeCopy.toDoc());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String groupChallengeId) async {
    final DocumentReference groupChallengeRef =
        db.collection(name).doc(groupChallengeId);

    WriteBatch batch = db.batch();

    try {
      QuerySnapshot subDocuments =
          await groupChallengeRef.collection(participantsSubCollection).get();

      // Add delete operations for subDocuments to the batch
      for (QueryDocumentSnapshot subDocument in subDocuments.docs) {
        batch.delete(subDocument.reference);
      }

      // Add delete operation for the main document to the batch
      batch.delete(groupChallengeRef);

      // Commit the batch
      await _storageService
          .deleteFolderByPath('$collectionName/$groupChallengeId');
      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteParticipant(
      {required GroupChallengeModel groupChallenge,
      required String participantId}) async {
    try {
      groupChallenge = await getById(groupChallenge.id);
      if (groupChallenge.participants.length == 1) {
        return await delete(groupChallenge.id);
      }
      if (groupChallenge.userId == participantId) {
        groupChallenge.participants
            .removeWhere((participant) => participant.user.id == participantId);
        groupChallenge.sortParticipants();
        groupChallenge.userId = groupChallenge.participants.first.user.id;
        await update(groupChallenge);
      }

      await _storageService.deleteFolderByPath(
          '$collectionName/${groupChallenge.id}/$participantId');

      return await db
          .collection(collectionName)
          .doc(groupChallenge.id)
          .collection(participantsSubCollection)
          .doc(participantId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
