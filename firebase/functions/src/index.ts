import { pushNotificationDefinition } from './pushNotifications';
import { runMigrationsDefinition } from './runMigrations';
import { seedDatabaseDefinition } from './seedDatabase';

export const pushNotification = pushNotificationDefinition;
export const seedDatabase = seedDatabaseDefinition;
export const runMigrations = runMigrationsDefinition;
