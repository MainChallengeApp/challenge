import 'package:challenge/collections/group_challenges_collection.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<GroupChallengesCollection>(
      GroupChallengesCollection());
}
