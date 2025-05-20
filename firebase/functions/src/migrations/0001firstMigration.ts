import * as admin from 'firebase-admin';
import { Migration } from './migration';

export class FirstMigration extends Migration {
  constructor() {
    super(1, 'First Migration', '1.0.0', new Date());
  }

  async run() {
    if (!admin.apps.length) {
      admin.initializeApp();
    }
    console.log('Running firstMigration');
  }
}