import 'package:challenge/collections/seeds/collection_seed_model.dart';
import 'package:challenge/collections/users_collection.dart';

class UsersCollectionSeed extends CollectionSeedModel {
  UsersCollectionSeed() : super(collectionName: 'users');

  @override
  Future<void> run() async {
    await clearCollection();

    createTestUser();

    List<Map<String, dynamic>> users = createData();

    for (var user in users) {
      await db.collection(UsersCollection.collectionName).add(user);
    }
  }

  void createTestUser() {
    db.collection(collectionName).doc('ZA23oy14uvgCuEUKSHlTV6IQ0oM2').set({
      'email': '1.user@dev.db',
      'username': 'FirstTestUser',
      'name': 'First Test User'
    });
  }

  @override
  List<Map<String, dynamic>> createData() {
    return [
      {
        'email': 'tester@test.test',
        'username': 'test@test.test',
        'name': 'test@test.test',
      },
    ];
  }
}
