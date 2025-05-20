import * as admin from 'firebase-admin';
import { Migration } from './migration';

export class FixGroupChallengesTypo extends Migration {
  constructor() {
    super(2, 'Fix typo in groupChallenges collection', '1.16.0', new Date());
  }

  async run() {
    if (!admin.apps.length) {
      admin.initializeApp();
    }

    const db = admin.firestore();
    const batch = db.batch();
    const count = 0;
    const batchSize = 500; // Firestore batch limit is 500

    // Get all documents from groupChallenges collection
    const snapshot = await db.collection('groupChallenges').get();
    
    for (const doc of snapshot.docs) {
      const data = doc.data()['groupChallengeOptions'];
      console.log('data', data);
      // Check if the document has the typo
      //   if (Object.prototype.hasOwnProperty.call(data, 'incorrectPropertyName')) {
      //     // Create a new object with the correct property name
      //     const correctedData = {
      //       ...data,
      //       correctPropertyName: data['incorrectPropertyName']
      //     };
      //     delete correctedData['incorrectPropertyName'];

      //     // Add the update to the batch
      //     batch.update(doc.ref, correctedData);
      //     count++;

    //     // If we reach the batch limit, commit and create a new batch
    //     if (count === batchSize) {
    //       await batch.commit();
    //       count = 0;
    //     }
    //   }
    }

    // Commit any remaining updates
    if (count > 0) {
      await batch.commit();
    }

    console.log('Fixed typos in groupChallenges collection');
  }
} 