import * as admin from 'firebase-admin';
import { Migration } from '../migrations/migration';

const GROUP_CHALLENGES_COLLECTION = 'groupChallenges';

if (!admin.apps.length) {
  admin.initializeApp();
}

export async function getLastMigration(): Promise<Migration> {
  const migrationsSnapshot = await admin.firestore().collection(GROUP_CHALLENGES_COLLECTION)
    .orderBy('migrationNumber', 'desc').limit(1).get();
  if (migrationsSnapshot.empty) {
    return Migration.empty();
  }
  return migrationsSnapshot.docs.map(doc => doc.data() as Migration)[0];
}

export async function createMigration(migration: Migration): Promise<void> {
  await admin.firestore().collection(GROUP_CHALLENGES_COLLECTION).add(migration.toJson());
}
