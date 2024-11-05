// import 'dart:developer';

// import 'package:challenge/collections/migrations/migration.dart';
// import 'package:challenge/collections/user_challenges_collection.dart';

// class V3AddTitleLowerCaseUserChallenges extends Migration {
//   V3AddTitleLowerCaseUserChallenges()
//       : super(
//             migrationNumber: 3,
//             description: 'add title lower case to user challenges',
//             appVersion: '1.5.3');

//   @override
//   Future<void> run() async {
//     final querySnapshot =
//         await db.collection(UserChallengesCollection.collectionName).get();

//     final Map<String, dynamic> idDataMap = {};

//     for (var doc in querySnapshot.docs) {
//       log('[${DateTime.now()}] migrating user challenge ${doc.id}');
//       final data = doc.data();
//       data['titleLowerCase'] = (data['title'] as String).toLowerCase();
//       idDataMap[doc.id] = data;
//     }

//     await updateMany(UserChallengesCollection.collectionName, idDataMap);
//   }
// }
