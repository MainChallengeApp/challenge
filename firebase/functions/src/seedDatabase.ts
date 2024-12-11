import * as admin from "firebase-admin";
import { getDownloadURL } from "firebase-admin/storage";
import * as functions from "firebase-functions";
import * as fs from "fs";

if (!admin.apps.length) {
  admin.initializeApp();
}

export const seedDatabaseDefinition = functions.https.onRequest(
  async (req, res) => {
    const seedDataString = fs.readFileSync(
      "../../assets/search_challenges2.json"
    );
    const seedData = JSON.parse(seedDataString.toString());
    const db = admin.firestore();
    const searchChallengesSnapshot = await db
      .collection("search_challenges")
      .get();

    // delete all search challenges
    await searchChallengesSnapshot.forEach(async (doc) => {
      await db.collection("search_challenges").doc(doc.id).delete();
    });

    const batch = db.batch();
    const bucket = admin.storage().bucket();

    seedData.forEach(async (searchChallenge: any) => {
      searchChallenge.createdAt = new Date();
      const searchChallengeRef = db.collection("search_challenges").doc();

      // Path to your asset file
      const assetPath = `../../${searchChallenge.thumbnail.url}`;

      // Read the file
      const fileBuffer = fs.readFileSync(assetPath);

      // Generate a unique filename
      const fileName = `search_challenges/${searchChallengeRef.id}/thumbnail.jpg`;

      // Get a reference to the storage bucket

      // Upload the file to Firebase Storage
      const file = bucket.file(fileName);
      await file.save(fileBuffer, {
        metadata: {
          contentType: "image/jpeg", // Adjust this based on your file type
        },
      });

      // Update the searchChallenge object with the new URL
      searchChallenge.thumbnail.url = await getDownloadURL(file);

      await db
        .collection("search_challenges")
        .doc(searchChallengeRef.id)
        .set(searchChallenge);

      // batch.set(searchChallengeRef, searchChallenge);
    });

    //   seedData.groupChallenges.forEach((groupChallenge: any) => {
    //     const groupChallengeRef = db.collection("groupChallenges").doc(groupChallenge.id);
    //     batch.set(groupChallengeRef, groupChallenge);
    //   });

    //   seedData.notifications.forEach((notification: any) => {
    //     const notificationRef = db.collection("notifications").doc(notification.id);
    //     batch.set(notificationRef, notification);
    //   });

    await batch.commit();
    res.send("Database seeded successfully");
  }
);
