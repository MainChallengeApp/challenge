import * as admin from 'firebase-admin';
import { Migration } from '../migrations/migration';

const MIGRATION_COLLECTION = 'migrations';

if (!admin.apps.length) {
  admin.initializeApp();
}

export async function getLastMigration(): Promise<Migration> {
  const migrationsSnapshot = await admin.firestore().collection(MIGRATION_COLLECTION)
    .orderBy('migrationNumber', 'desc').limit(1).get();
  if (migrationsSnapshot.empty) {
    return Migration.empty();
  }
  return migrationsSnapshot.docs.map(doc => doc.data() as Migration)[0];
}

export async function createMigration(migration: Migration): Promise<void> {
  await admin.firestore().collection(MIGRATION_COLLECTION).add(migration.toJson());
}
