import 'package:challenge/database/seeds/collection_seed_model.dart';
import 'package:challenge/database/users_database.dart';

class UsersCollectionSeed extends CollectionSeedModel {
  UsersCollectionSeed() : super(collectionName: 'users');

  @override
  Future<void> run() async {
    await clearCollection();

    List<Map<String, dynamic>> users = [
      {'email': '1.user@dev.db'},
      {
        'email': 'tester@test.test',
        'username': 'test@test.test',
        'name': 'test@test.test',
      },
    ];

    db.collection(UsersDatabase.collectionName).add(users[0]);
  }
}
