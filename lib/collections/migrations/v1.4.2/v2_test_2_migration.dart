// import 'dart:developer';

// import 'package:challenge/collections/migrations/migration.dart';
// import 'package:challenge/collections/user_challenges_collection.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class Test2Migration extends Migration {
//   Test2Migration()
//       : super(
//             migrationNumber: 2,
//             description: 'Change startDate type from String to DateTime',
//             appVersion: '1.5.3');

//   @override
//   Future<void> run() async {
//     final querySnapshot =
//         await db.collection(UserChallengesCollection.collectionName).get();

//     for (DocumentSnapshot doc in querySnapshot.docs) {
//       log('[${DateTime.now()}] migration user challenge ${doc['title']}');
//       final data = doc.data() as Map<String, dynamic>;
//       if (data['startDate'] is DateTime) {
//         continue;
//       } else if (data['startDate'] == 'null') {
//         data['startDate'] = null;
//       } else if (data['startDate'] is String) {
//         data['startDate'] = DateTime.parse(data['startDate']);
//       } else {
//         log('${DateTime.now()}] migration user challenge ${doc['title']} failed');
//       }
//       await db
//           .collection(UserChallengesCollection.collectionName)
//           .doc(doc.id)
//           .update(data);
//     }
//   }

//   // Future<void> updateMany(List<Object> userChallenges) async {
//   //   final batch = db.batch();
//   //   for (var userChallenge in userChallenges) {
//   //     final ref = db.collection(UserChallengesDatabase.collectionName).doc();
//   //     batch.set(userChallenge.id, userChallenge.toDoc());
//   //   }
//   //   await batch.commit();
//   // }
// }
