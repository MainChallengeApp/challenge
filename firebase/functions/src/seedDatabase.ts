import * as admin from 'firebase-admin';
import { getDownloadURL } from 'firebase-admin/storage';
import * as functions from 'firebase-functions';
import * as fs from 'fs';
import { SearchChallengeType } from './types/searchChallenge.type';

if (!admin.apps.length) {
  admin.initializeApp();
}

export const seedDatabaseDefinition = functions.https.onRequest(async (request, response) => {
  if (
    process.env.SEED_DATABASE_TOKEN == undefined ||
    request.query.token == undefined ||
    request.query.token !== process.env.SEED_DATABASE_TOKEN
  ) {
    response.status(401).send();
    return;
  }

  const seedDataString = fs.readFileSync('assets/search_challenges.json');
  const seedData = JSON.parse(seedDataString.toString());
  const db = admin.firestore();
  const searchChallengesSnapshot = await db.collection('search_challenges').get();

  await Promise.all(
    seedData.map(async (searchChallenge: SearchChallengeType) => {
      const oldSearchChallenge = searchChallengesSnapshot.docs.find(
        (doc) => doc.data().titleLowerCase === searchChallenge.titleLowerCase // id would be better
      );

      if (oldSearchChallenge) {
        searchChallenge.thumbnail.url = oldSearchChallenge?.data().thumbnail.url;
      } else {
        searchChallenge.thumbnail.url = await uploadThumbnail(searchChallenge);
      }

      searchChallenge.createdAt = new Date();
      await db.collection('search_challenges').add(searchChallenge);
    })
  );

  // delete all old search challenges
  await searchChallengesSnapshot.forEach(async (doc) => {
    await db.collection('search_challenges').doc(doc.id).delete();
  });

  response.status(200).send({ message: 'Database seeded successfully' });
});

async function uploadThumbnail(searchChallenge: SearchChallengeType) {
  const bucket = admin.storage().bucket();
  const fileBuffer = fs.readFileSync(searchChallenge.thumbnail.url);
  const fileName = `search_challenges/${searchChallenge.id}/thumbnail.jpg`;
  const file = bucket.file(fileName);
  await file.save(fileBuffer, {
    metadata: {
      contentType: 'image/jpeg', // Adjust this based on your file type
    },
  });
  return await getDownloadURL(file);
}
