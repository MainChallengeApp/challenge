import 'dart:developer';
import 'dart:io';

import 'package:challenge/collections/migrations/run_migrations.dart'
    as run_migrations;
import 'package:challenge/collections/seeds/collection_seed_model.dart';
import 'package:challenge/collections/seeds/collection_seeds/search_challenges_collection_seed.dart';
import 'package:challenge/collections/seeds/collection_seeds/users_collection_seed.dart';
import 'package:challenge/environments/firebase_options_dev.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

List<CollectionSeedModel> collectionSeeds = [
  UsersCollectionSeed(),
  SearchChallengesCollectionSeed()
];

void main() async {
  log('[${DateTime.now()}]: start seeding dev database...');

  await initializeDevBackend();

  for (var collectionSeed in collectionSeeds) {
    log('[${DateTime.now()}]: seed collection ${collectionSeed.collectionName}');
    await collectionSeed.run();
  }

  log('[${DateTime.now()}] end seeding dev database.');

  await run_migrations.main();

  exit(0);
}

Future<void> initializeDevBackend() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, name: 'challenge-dev');
}
