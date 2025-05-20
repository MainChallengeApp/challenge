import * as admin from 'firebase-admin';
import { Migration } from './migration';

export class FixIsProgressIndividual extends Migration {
  constructor() {
    super(1, 'Fix Is ProgressIndividual', '1.6.16', new Date());
  }

  async run() {
    if (!admin.apps.length) {
      admin.initializeApp();
    }

    

    const groupChallenges = await admin.firestore().collection('groupChallenges').get();
  }
}