import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { createMigration, getLastMigration } from './collection/migrationsCollection';
import { FirstMigration } from './migrations/0001firstMigration';
import { FixGroupChallengesTypo } from './migrations/0002fixGroupChallengesTypo';

if (!admin.apps.length) {
  admin.initializeApp();
}

export const runMigrationsDefinition = functions.https.onCall(async (_) => {
  const localMigrations = [ new FirstMigration(), new FixGroupChallengesTypo() ];
  const lastMigration = await getLastMigration();
  const localMigrationsToRun = localMigrations.filter((localMigration) => {
    return localMigration.migrationNumber > lastMigration.migrationNumber;
  });

  localMigrationsToRun.forEach(async (localMigration) => {
    await localMigration.run();
    await createMigration(localMigration);
  });

  return 'Migrations run successfully';
});