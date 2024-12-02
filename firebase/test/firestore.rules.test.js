const fs = require("fs");
const { initializeTestEnvironment } = require("@firebase/rules-unit-testing");
const fetch = require("node-fetch");
const { loadEnv } = require("../scripts/load_env.js");

// somehow necessary for pipeline
global.fetch = fetch;

const PROJECT_ID = "challenge-dev-sdgi";
const MIGRATIONS_COLLECTION = "migrations";
const USERS_COLLECTION = "users";
const NOTIFICATIONS_COLLECTION = "notifications";
const GROUP_CHALLENGES_COLLECTION = "group_challenges";
const PARTICIPANTS_SUBCOLLECTION = "participants";
const SEARCH_CHALLENGES_COLLECTION = "search_challenges";
const REPORTS_COLLECTION = "reports";

const collections = [
  MIGRATIONS_COLLECTION,
  USERS_COLLECTION,
  NOTIFICATIONS_COLLECTION,
  GROUP_CHALLENGES_COLLECTION,
  SEARCH_CHALLENGES_COLLECTION,
  PARTICIPANTS_SUBCOLLECTION,
  REPORTS_COLLECTION,
];

let testEnv;
let migrationUserId;

beforeAll(async () => {
  // arrange
  jest.setTimeout(10000);
  loadEnv();
  migrationUserId = process.env.MIGRATION_USER_ID;

  // act
  testEnv = await initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: {
      rules: fs.readFileSync("firestore.rules", "utf8"),
      host: "127.0.0.1",
      port: 9151,
    },
  });
});

afterAll(async () => {
  for (let collection of collections) {
    await deleteCollection(collection);
  }
  await testEnv.cleanup();
});

async function deleteCollection(path) {
  // arrange
  const db = getAuthenticatedDb(migrationUserId);

  // act
  try {
    const snapshot = await db.collectionGroup(path).get();
    const deletePromises = snapshot.docs.map(async (doc) => doc.ref.delete());
    await Promise.all(deletePromises);
  } catch (error) {
    console.error(`Error deleting collection ${path}:`, error);
  }
}

const getAuthenticatedDb = (auth) =>
  testEnv.authenticatedContext(auth ?? "user-id").firestore();
const getUnauthenticatedDb = () => testEnv.unauthenticatedContext().firestore();

// Helper function to add documents without security rules
async function addDocumentWithoutRules(collectionPath, data) {
  let docId;
  await testEnv.withSecurityRulesDisabled(async (noRulesContext) => {
    const db = await noRulesContext.firestore();
    docId = await db.collection(collectionPath).add(data);
  });
  return docId;
}

describe("Firestore Security Rules", () => {
  describe("migrations collection", () => {
    describe("Read operations", () => {
      it("should allow authenticated user to read documents", async () => {
        // act & assert
        await expect(
          getAuthenticatedDb().collection(MIGRATIONS_COLLECTION).get()
        ).resolves.toBeDefined();
      });

      it("should allow unauthenticated user to read documents", async () => {
        // arrange
        const unauthDb = getUnauthenticatedDb();

        // act & assert
        await expect(
          unauthDb.collection(MIGRATIONS_COLLECTION).get()
        ).resolves.toBeDefined();
      });
    });
    describe("Write operations", () => {
      it("should not allow authenticated user to write documents", async () => {
        // act & assert
        await expect(
          getAuthenticatedDb().collection(MIGRATIONS_COLLECTION).add({})
        ).rejects.toThrow(/PERMISSION_DENIED/);
      });

      it("should not allow unauthenticated user to write documents", async () => {
        // arrange
        const unauthDb = getUnauthenticatedDb();

        // act & assert
        await expect(
          unauthDb.collection(MIGRATIONS_COLLECTION).add({})
        ).rejects.toThrow(/PERMISSION_DENIED/);
      });

      it("should allow migration user to write documents", async () => {
        // arrange
        const migrationDb = getAuthenticatedDb(migrationUserId);

        // act
        const docRef = await migrationDb
          .collection(MIGRATIONS_COLLECTION)
          .add({ migration: 1 });
        const docSnapshot = await docRef.get();

        // assert
        expect(docSnapshot.exists).toBe(true);
        expect(docSnapshot.data()).toEqual({ migration: 1 });

        // cleanup
        await docRef.delete();
      });
    });
  });

  describe("users collection", () => {
    describe("Read operations", () => {
      it("should allow authenticated users to read documents", async () => {
        const db = getAuthenticatedDb();
        await expect(
          db.collection(USERS_COLLECTION).get()
        ).resolves.toBeDefined();
      });

      it("should not allow unauthenticated users to read documents", async () => {
        const db = getUnauthenticatedDb();
        await expect(db.collection(USERS_COLLECTION).get()).rejects.toThrow();
      });
    });

    describe("Create operations", () => {
      it("should allow authenticated users to create documents when the resource id is the user id", async () => {
        const userId = "user-id2";
        const db = getAuthenticatedDb(userId);
        await db
          .collection(USERS_COLLECTION)
          .doc(userId)
          .set({ name: "user1" });
        const doc = await db.collection(USERS_COLLECTION).doc(userId).get();
        expect(doc.exists).toBe(true);
        expect(doc.data()).toEqual({ name: "user1" });
      });

      it("should not allow authenticated users to create documents when the resource id is not the user id", async () => {
        const userId = "user-id3";
        const db = getAuthenticatedDb(userId);
        await expect(
          db.collection(USERS_COLLECTION).doc("user-id4").set({ name: "user1" })
        ).rejects.toThrow(/PERMISSION_DENIED/);
      });

      it("should not allow unauthenticated users to create documents", async () => {
        const db = getUnauthenticatedDb();
        await expect(
          db.collection(USERS_COLLECTION).add({ name: "user1" })
        ).rejects.toThrow(/PERMISSION_DENIED/);
      });
    });

    describe("Update operations", () => {
      it("should allow authenticated users to update their own document", async () => {
        const userId = "user-id5";
        const db = getAuthenticatedDb(userId);
        await db
          .collection(USERS_COLLECTION)
          .doc(userId)
          .set({ name: "user5" });
        await db
          .collection(USERS_COLLECTION)
          .doc(userId)
          .update({ name: "updated user5" });
        const doc = await db.collection(USERS_COLLECTION).doc(userId).get();
        expect(doc.data().name).toBe("updated user5");
      });

      it("should allow authenticated users to update only connectionIds in their own document", async () => {
        const userId = "user-id6";
        const db = getAuthenticatedDb(userId);
        await db
          .collection(USERS_COLLECTION)
          .doc(userId)
          .set({ name: "user6", connectionIds: [] });
        await db
          .collection(USERS_COLLECTION)
          .doc(userId)
          .update({ connectionIds: ["newConnection"] });
        const doc = await db.collection(USERS_COLLECTION).doc(userId).get();
        expect(doc.data().connectionIds).toEqual(["newConnection"]);
      });

      it("should not allow authenticated users to update other users' documents", async () => {
        const userId = "user-id7";
        const otherUserId = "user-id8";
        const db = getAuthenticatedDb(userId);
        const otherUserDb = getAuthenticatedDb(otherUserId);
        await otherUserDb
          .collection(USERS_COLLECTION)
          .doc(otherUserId)
          .set({ name: "user8" });
        await expect(
          db
            .collection(USERS_COLLECTION)
            .doc(otherUserId)
            .update({ name: "updated user8" })
        ).rejects.toThrow();
      });

      it("should not allow unauthenticated users to update documents", async () => {
        const db = getUnauthenticatedDb();
        await expect(
          db
            .collection(USERS_COLLECTION)
            .doc("user-id9")
            .update({ name: "updated user9" })
        ).rejects.toThrow(/PERMISSION_DENIED/);
      });
    });

    describe("Delete operations", () => {
      it("should allow authenticated users to delete their own document", async () => {
        const userId = "user-id10";
        const db = getAuthenticatedDb(userId);
        await db
          .collection(USERS_COLLECTION)
          .doc(userId)
          .set({ name: "user10" });
        await db.collection(USERS_COLLECTION).doc(userId).delete();
        const doc = await db.collection(USERS_COLLECTION).doc(userId).get();
        expect(doc.exists).toBe(false);
      });

      it("should not allow authenticated users to delete other users' documents", async () => {
        const userId = "user-id11";
        const otherUserId = "user-id12";
        const db = getAuthenticatedDb(userId);
        const otherUserDb = getAuthenticatedDb(otherUserId);
        await otherUserDb
          .collection(USERS_COLLECTION)
          .doc(otherUserId)
          .set({ name: "user12" });
        await expect(
          db.collection(USERS_COLLECTION).doc(otherUserId).delete()
        ).rejects.toThrow();
      });

      it("should not allow unauthenticated users to delete documents", async () => {
        const db = getUnauthenticatedDb();
        await expect(
          db.collection(USERS_COLLECTION).doc("user-id13").delete()
        ).rejects.toThrow(/PERMISSION_DENIED/);
      });
    });
  });

  describe("notifications collection", () => {
    describe("Read operations", () => {
      it("should allow authenticated users to read their own notifications", async () => {
        const userId = "user-id1";
        const db = getAuthenticatedDb(userId);

        await expect(
          db
            .collection(NOTIFICATIONS_COLLECTION)
            .where("userId", "==", userId)
            .get()
        ).resolves.toBeDefined();
      });

      it("should allow authenticated users to read notifications where they are the fromUserId", async () => {
        const userId = "user-id2";
        const db = getAuthenticatedDb(userId);
        await expect(
          db
            .collection(NOTIFICATIONS_COLLECTION)
            .where("fromUserId", "==", userId)
            .get()
        ).resolves.toBeDefined();
      });

      it("should allow group challenge owners to read related notifications", async () => {
        const userId = "user-id3";
        const groupChallengeId = "groupChallenge1";
        const db = getAuthenticatedDb(userId);

        // Create a group challenge
        await db
          .collection(GROUP_CHALLENGES_COLLECTION)
          .doc(groupChallengeId)
          .set({
            userId: userId,
          });

        // Create a notification related to the group challenge
        await db.collection(NOTIFICATIONS_COLLECTION).add({
          fromUserId: userId,
          groupChallengeId: groupChallengeId,
          message: "Group challenge notification",
        });

        await expect(
          db
            .collection(NOTIFICATIONS_COLLECTION)
            .where("groupChallengeId", "==", groupChallengeId)
            .get()
        ).resolves.toBeDefined();
      });

      it("should not allow authenticated users to read unrelated notifications", async () => {
        const userId = "user-id4";
        const otherUserId = "other-user-id";
        const db = getAuthenticatedDb(userId);
        const otherDb = getAuthenticatedDb(otherUserId);

        await otherDb
          .collection(NOTIFICATIONS_COLLECTION)
          .doc("notification4")
          .set({
            fromUserId: otherUserId,
            message: "Unrelated notification",
          });

        await expect(
          db.collection(NOTIFICATIONS_COLLECTION).doc("notification4").get()
        ).rejects.toThrow();
      });

      it("should not allow unauthenticated users to read notifications", async () => {
        const db = getUnauthenticatedDb();
        await expect(
          db.collection(NOTIFICATIONS_COLLECTION).get()
        ).rejects.toThrow();
      });
    });

    describe("Create operations", () => {
      it("should allow authenticated users to create notifications when fromUserId is userId", async () => {
        const userId = "user-id5";
        const db = getAuthenticatedDb(userId);

        await expect(
          db.collection(NOTIFICATIONS_COLLECTION).add({
            fromUserId: userId,
            message: "New notification",
          })
        ).resolves.toBeDefined();
      });

      it("should not allow unauthenticated users to create notifications", async () => {
        const db = getUnauthenticatedDb();
        await expect(
          db.collection(NOTIFICATIONS_COLLECTION).add({
            fromUserId: "",
            message: "Unauthorized notification",
          })
        ).rejects.toThrow();
      });
    });

    describe("Update operations", () => {
      it("should not allow authenticated users to update notifications", async () => {
        const userId = "user-id6";
        const db = getAuthenticatedDb(userId);
        const docRef = await db.collection(NOTIFICATIONS_COLLECTION).add({
          fromUserId: userId,
          message: "Original notification",
        });

        await expect(
          docRef.update({
            message: "Updated notification",
          })
        ).rejects.toThrow();
      });

      it("should not allow unauthenticated users to update notifications", async () => {
        const db = getUnauthenticatedDb();
        await expect(
          db.collection(NOTIFICATIONS_COLLECTION).doc("someId").update({
            message: "Unauthorized update",
          })
        ).rejects.toThrow();
      });
    });

    describe("Delete operations", () => {
      it("should allow authenticated users to delete their own notifications", async () => {
        const userId = "user-id7";
        const db = getAuthenticatedDb(userId);
        const docRef = await db.collection(NOTIFICATIONS_COLLECTION).add({
          fromUserId: userId,
          message: "Deletable notification",
        });

        await expect(docRef.delete()).resolves.toBeUndefined();
      });

      it("should allow authenticated users to delete notifications where they are the fromUserId", async () => {
        const userId = "user-id8";
        const db = getAuthenticatedDb(userId);
        const docRef = await db.collection(NOTIFICATIONS_COLLECTION).add({
          fromUserId: userId,
          message: "Deletable notification",
        });

        await expect(docRef.delete()).resolves.toBeUndefined();
      });

      it("should allow group challenge owners to delete related notifications", async () => {
        const userId = "user-id9";
        const groupChallengeId = "groupChallenge2";
        const db = getAuthenticatedDb(userId);

        await db
          .collection(GROUP_CHALLENGES_COLLECTION)
          .doc(groupChallengeId)
          .set({
            userId: userId,
          });

        const docRef = await db.collection(NOTIFICATIONS_COLLECTION).add({
          fromUserId: userId,
          groupChallengeId: groupChallengeId,
          message: "Deletable group challenge notification",
        });

        await expect(docRef.delete()).resolves.toBeUndefined();
      });

      it("should not allow authenticated users to delete unrelated notifications", async () => {
        const userId = "user-id10";
        const otherUserId = "other-user-id2";
        const db = getAuthenticatedDb(userId);
        const otherDb = getAuthenticatedDb(otherUserId);

        const docRef = await otherDb.collection(NOTIFICATIONS_COLLECTION).add({
          userId: otherUserId,
          fromUserId: otherUserId,
          message: "Undeletable notification",
        });

        await expect(
          db.collection(NOTIFICATIONS_COLLECTION).doc(docRef.id).delete()
        ).rejects.toThrow();
      });

      it("should not allow unauthenticated users to delete notifications", async () => {
        const db = getUnauthenticatedDb();
        await expect(
          db.collection(NOTIFICATIONS_COLLECTION).doc("someId").delete()
        ).rejects.toThrow();
      });
    });
  });

  describe("reports collection", () => {
    describe("Read operations", () => {
      it("should not allow authenticated users to read reports", async () => {
        const userId = "user-id1";
        const db = getAuthenticatedDb(userId);
        await expect(db.collection(REPORTS_COLLECTION).get()).rejects.toThrow();
      });

      it("should not allow unauthenticated users to read reports", async () => {
        const db = getUnauthenticatedDb();
        await expect(db.collection(REPORTS_COLLECTION).get()).rejects.toThrow();
      });

      it("should not allow reading a specific report document", async () => {
        const userId = "user-id2";
        const db = getAuthenticatedDb(userId);
        await db
          .collection(REPORTS_COLLECTION)
          .add({ userId: userId, content: "Test report" });
        await expect(
          db.collection(REPORTS_COLLECTION).doc("report1").get()
        ).rejects.toThrow();
      });
    });

    describe("Create operations", () => {
      it("should allow authenticated users to create reports", async () => {
        const userId = "user-id3";
        const db = getAuthenticatedDb(userId);

        await expect(
          db.collection(REPORTS_COLLECTION).add({
            userId: userId,
            content: "New report",
          })
        ).resolves.toBeDefined();
      });

      it("should not allow unauthenticated users to create reports", async () => {
        const userId = "user-id4";
        const db = getUnauthenticatedDb();
        await expect(
          db.collection(REPORTS_COLLECTION).add({
            userId: userId,
            content: "Unauthorized report",
          })
        ).rejects.toThrow();
      });
    });

    describe("Update operations", () => {
      it("should not allow authenticated users to update reports", async () => {
        const userId = "user-id4";
        const db = getAuthenticatedDb(userId);
        const docRef = await db.collection(REPORTS_COLLECTION).add({
          userId: userId,
          content: "Original report",
        });

        await expect(
          docRef.update({
            content: "Updated report",
          })
        ).rejects.toThrow();
      });

      it("should not allow unauthenticated users to update reports", async () => {
        const db = getUnauthenticatedDb();
        await expect(
          db.collection(REPORTS_COLLECTION).doc("someId").update({
            content: "Unauthorized update",
          })
        ).rejects.toThrow();
      });
    });

    describe("Delete operations", () => {
      it("should not allow authenticated users to delete reports", async () => {
        const userId = "user-id5";
        const db = getAuthenticatedDb(userId);
        const docRef = await db.collection(REPORTS_COLLECTION).add({
          userId: userId,
          content: "Undeletable report",
        });

        await expect(docRef.delete()).rejects.toThrow();
      });

      it("should not allow unauthenticated users to delete reports", async () => {
        const db = getUnauthenticatedDb();
        await expect(
          db.collection(REPORTS_COLLECTION).doc("someId").delete()
        ).rejects.toThrow();
      });
    });
  });

  describe("group_challenges collection", () => {
    describe("Read operations", () => {
      it("should allow authenticated users to read group challenges they're participating in", async () => {
        const userId = "user-id1";
        const db = getAuthenticatedDb(userId);
        const otherUserId = "other-user-id";
        const otherDb = getAuthenticatedDb(otherUserId);

        // Create a group challenge
        const challengeRef = await otherDb
          .collection(GROUP_CHALLENGES_COLLECTION)
          .add({
            userId: otherUserId,
            name: "Test Challenge",
          });

        // Add the user as a participant
        await otherDb
          .collection(GROUP_CHALLENGES_COLLECTION)
          .doc(challengeRef.id)
          .collection(PARTICIPANTS_SUBCOLLECTION)
          .doc(userId)
          .set({
            userId: userId,
            name: "Participant",
          });

        // Try to read the group challenge
        await expect(
          db.collection(GROUP_CHALLENGES_COLLECTION).doc(challengeRef.id).get()
        ).resolves.toBeDefined();
      });

      it("should allow authenticated users to read group challenges they own", async () => {
        const userId = "user-id2";
        const db = getAuthenticatedDb(userId);

        const challengeRef = await db
          .collection(GROUP_CHALLENGES_COLLECTION)
          .add({
            userId: userId,
            name: "Owned Challenge",
          });

        await expect(challengeRef.get()).resolves.toBeDefined();
      });

      it("should not allow authenticated users to read group challenges they're not participating in", async () => {
        const userId = "user-id3";
        const db = getAuthenticatedDb(userId);
        const otherUserId = "other-user-id";
        const otherDb = getAuthenticatedDb(otherUserId);

        const challengeRef = await otherDb
          .collection(GROUP_CHALLENGES_COLLECTION)
          .add({
            userId: otherUserId,
            name: "Other User's Challenge",
          });

        await expect(
          db.collection(GROUP_CHALLENGES_COLLECTION).doc(challengeRef.id).get()
        ).rejects.toThrow();
      });

      it("should not allow unauthenticated users to read group challenges", async () => {
        const db = getUnauthenticatedDb();
        await expect(
          db.collection(GROUP_CHALLENGES_COLLECTION).get()
        ).rejects.toThrow();
      });
    });

    describe("Create operations", () => {
      it("should allow authenticated users to create group challenges when userId matches", async () => {
        const userId = "user-id2";
        const db = getAuthenticatedDb(userId);
        await expect(
          db.collection(GROUP_CHALLENGES_COLLECTION).add({
            userId: userId,
            name: "New Challenge",
          })
        ).resolves.toBeDefined();
      });

      it("should not allow authenticated users to create group challenges when userId doesn't match", async () => {
        const userId = "user-id3";
        const db = getAuthenticatedDb(userId);
        await expect(
          db.collection(GROUP_CHALLENGES_COLLECTION).add({
            userId: "different-user-id",
            name: "New Challenge",
          })
        ).rejects.toThrow();
      });

      it("should not allow unauthenticated users to create group challenges", async () => {
        const db = getUnauthenticatedDb();
        await expect(
          db.collection(GROUP_CHALLENGES_COLLECTION).add({
            userId: "some-user-id",
            name: "New Challenge",
          })
        ).rejects.toThrow();
      });
    });

    describe("Update operations", () => {
      it("should allow authenticated users to update their own group challenges", async () => {
        const userId = "user-id4";
        const db = getAuthenticatedDb(userId);
        const docRef = await db.collection(GROUP_CHALLENGES_COLLECTION).add({
          userId: userId,
          name: "Original Challenge",
        });
        await expect(
          docRef.update({ name: "Updated Challenge" })
        ).resolves.toBeUndefined();
      });

      it("should not allow authenticated users to update other users' group challenges", async () => {
        const userId = "user-id5";
        const otherUserId = "other-user-id";
        const db = getAuthenticatedDb(userId);
        const otherDb = getAuthenticatedDb(otherUserId);
        const docRef = await otherDb
          .collection(GROUP_CHALLENGES_COLLECTION)
          .add({
            userId: otherUserId,
            name: "Other User's Challenge",
          });
        await expect(
          db.collection(GROUP_CHALLENGES_COLLECTION).doc(docRef.id).update({
            userId: otherUserId,
            name: "Attempted Update",
          })
        ).rejects.toThrow();
      });

      it("should not allow unauthenticated users to update group challenges", async () => {
        const db = getUnauthenticatedDb();
        await expect(
          db.collection(GROUP_CHALLENGES_COLLECTION).doc("someId").update({
            name: "Unauthorized Update",
          })
        ).rejects.toThrow();
      });
    });

    describe("Delete operations", () => {
      it("should allow authenticated users to delete their own group challenges", async () => {
        const userId = "user-id6";
        const db = getAuthenticatedDb(userId);
        const docRef = await db.collection(GROUP_CHALLENGES_COLLECTION).add({
          userId: userId,
          name: "Deletable Challenge",
        });
        await expect(docRef.delete()).resolves.toBeUndefined();
      });

      it("should not allow authenticated users to delete other users' group challenges", async () => {
        const userId = "user-id7";
        const otherUserId = "other-user-id2";
        const db = getAuthenticatedDb(userId);
        const otherDb = getAuthenticatedDb(otherUserId);
        const docRef = await otherDb
          .collection(GROUP_CHALLENGES_COLLECTION)
          .add({
            userId: otherUserId,
            name: "Other User's Challenge",
          });
        await expect(
          db.collection(GROUP_CHALLENGES_COLLECTION).doc(docRef.id).delete()
        ).rejects.toThrow();
      });

      it("should not allow unauthenticated users to delete group challenges", async () => {
        const db = getUnauthenticatedDb();
        await expect(
          db.collection(GROUP_CHALLENGES_COLLECTION).doc("someId").delete()
        ).rejects.toThrow();
      });
    });

    describe("participants subcollection", () => {
      let groupChallengeId;
      let ownerId;

      beforeEach(async () => {
        ownerId = "owner-id";
        const db = getAuthenticatedDb(ownerId);
        const docRef = await db.collection(GROUP_CHALLENGES_COLLECTION).add({
          userId: ownerId,
          name: "Test Challenge",
        });
        groupChallengeId = docRef.id;
      });

      describe("Read operations", () => {
        it("should allow participants to read participants", async () => {
          const userId = "user-id10";
          const ownerDb = getAuthenticatedDb(ownerId);
          const db = getAuthenticatedDb(userId);

          await ownerDb
            .collection(GROUP_CHALLENGES_COLLECTION)
            .doc(groupChallengeId)
            .collection(PARTICIPANTS_SUBCOLLECTION)
            .doc(userId)
            .set({ name: "Participant" });

          await expect(
            db
              .collection(GROUP_CHALLENGES_COLLECTION)
              .doc(groupChallengeId)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .get()
          ).resolves.toBeDefined();
        });

        it("should allow group challenge owner to read participants", async () => {
          const ownerDb = getAuthenticatedDb(ownerId);
          await expect(
            ownerDb
              .collection(GROUP_CHALLENGES_COLLECTION)
              .doc(groupChallengeId)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .get()
          ).resolves.toBeDefined();
        });

        it("should not allow non-participants to read participants", async () => {
          const userId = "user-id11";
          const db = getAuthenticatedDb(userId);
          await expect(
            db
              .collection(GROUP_CHALLENGES_COLLECTION)
              .doc(groupChallengeId)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .get()
          ).rejects.toThrow();
        });

        it("should not allow unauthenticated users to read participants", async () => {
          const db = getUnauthenticatedDb();
          await expect(
            db
              .collection(GROUP_CHALLENGES_COLLECTION)
              .doc(groupChallengeId)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .get()
          ).rejects.toThrow();
        });
      });

      describe("Create operations", () => {
        it("should allow group challenge owner to create participants", async () => {
          const ownerDb = getAuthenticatedDb(ownerId);
          await expect(
            ownerDb
              .collection(GROUP_CHALLENGES_COLLECTION)
              .doc(groupChallengeId)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .add({
                userId: "new-participant-id",
                name: "New Participant",
              })
          ).resolves.toBeDefined();
        });

        it("should not allow non-owners to create participants", async () => {
          const userId = "user-id12";
          const db = getAuthenticatedDb(userId);
          await expect(
            db
              .collection(GROUP_CHALLENGES_COLLECTION)
              .doc(groupChallengeId)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .add({
                userId: userId,
                name: "New Participant",
              })
          ).rejects.toThrow();
        });

        it("should not allow unauthenticated users to create participants", async () => {
          const db = getUnauthenticatedDb();
          await expect(
            db
              .collection(GROUP_CHALLENGES_COLLECTION)
              .doc(groupChallengeId)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .add({
                userId: "some-user-id",
                name: "New Participant",
              })
          ).rejects.toThrow();
        });
      });

      describe("Update operations", () => {
        it("should allow authenticated users to update their own participant document", async () => {
          const userId = "user-id13";
          const ownerDb = getAuthenticatedDb(ownerId);
          const db = getAuthenticatedDb(userId);

          await ownerDb
            .collection(GROUP_CHALLENGES_COLLECTION)
            .doc(groupChallengeId)
            .collection(PARTICIPANTS_SUBCOLLECTION)
            .doc(userId)
            .set({
              userId: userId,
              name: "Original Participant",
            });

          await expect(
            db
              .collection(GROUP_CHALLENGES_COLLECTION)
              .doc(groupChallengeId)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .doc(userId)
              .update({ name: "Updated Participant" })
          ).resolves.toBeUndefined();
        });

        it("should not allow authenticated users to update other users' participant documents", async () => {
          const userId = "user-id14";
          const otherUserId = "other-user-id3";
          const ownerDb = getAuthenticatedDb(ownerId);
          const db = getAuthenticatedDb(userId);

          await ownerDb
            .collection(GROUP_CHALLENGES_COLLECTION)
            .doc(groupChallengeId)
            .collection(PARTICIPANTS_SUBCOLLECTION)
            .doc(otherUserId)
            .set({
              userId: otherUserId,
              name: "Other User's Participant",
            });

          await expect(
            db
              .collection(GROUP_CHALLENGES_COLLECTION)
              .doc(groupChallengeId)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .doc(otherUserId)
              .update({ name: "Attempted Update" })
          ).rejects.toThrow();
        });

        it("should not allow unauthenticated users to update participant documents", async () => {
          const db = getUnauthenticatedDb();
          await expect(
            db
              .collection(GROUP_CHALLENGES_COLLECTION)
              .doc(groupChallengeId)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .doc("someId")
              .update({ name: "Unauthorized Update" })
          ).rejects.toThrow();
        });
      });

      describe("Delete operations", () => {
        it("should allow authenticated users to delete their own participant document", async () => {
          const userId = "user-id15";
          const ownerDb = getAuthenticatedDb(ownerId);
          const db = getAuthenticatedDb(userId);

          await ownerDb
            .collection(GROUP_CHALLENGES_COLLECTION)
            .doc(groupChallengeId)
            .collection(PARTICIPANTS_SUBCOLLECTION)
            .doc(userId)
            .set({
              userId: userId,
              name: "Deletable Participant",
            });

          await expect(
            db
              .collection(GROUP_CHALLENGES_COLLECTION)
              .doc(groupChallengeId)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .doc(userId)
              .delete()
          ).resolves.toBeUndefined();
        });

        it("should allow group challenge owner to delete any participant document", async () => {
          const participantId = "user-id16";
          const ownerDb = getAuthenticatedDb(ownerId);

          await ownerDb
            .collection(GROUP_CHALLENGES_COLLECTION)
            .doc(groupChallengeId)
            .collection(PARTICIPANTS_SUBCOLLECTION)
            .doc(participantId)
            .set({
              userId: participantId,
              name: "Participant",
            });

          await expect(
            ownerDb
              .collection(GROUP_CHALLENGES_COLLECTION)
              .doc(groupChallengeId)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .doc(participantId)
              .delete()
          ).resolves.toBeUndefined();
        });

        it("should not allow authenticated users to delete other users' participant documents if not the group challenge owner", async () => {
          const userId = "user-id17";
          const otherUserId = "other-user-id4";
          const ownerDb = getAuthenticatedDb(ownerId);
          const db = getAuthenticatedDb(userId);

          await ownerDb
            .collection(GROUP_CHALLENGES_COLLECTION)
            .doc(groupChallengeId)
            .collection(PARTICIPANTS_SUBCOLLECTION)
            .doc(otherUserId)
            .set({
              userId: otherUserId,
              name: "Other User's Participant",
            });

          await expect(
            db
              .collection(GROUP_CHALLENGES_COLLECTION)
              .doc(groupChallengeId)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .doc(otherUserId)
              .delete()
          ).rejects.toThrow();
        });

        it("should not allow unauthenticated users to delete participant documents", async () => {
          const db = getUnauthenticatedDb();
          await expect(
            db
              .collection(GROUP_CHALLENGES_COLLECTION)
              .doc(groupChallengeId)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .doc("someId")
              .delete()
          ).rejects.toThrow();
        });
      });
    });
  });

  describe("Wildcard participants rule", () => {
    const COLLECTIONS = ["group_challenges"];
    describe("Read operations", () => {
      COLLECTIONS.forEach((collection) => {
        describe(`${collection} collection`, () => {
          it(`should allow authenticated users to read their own participant document in ${collection}`, async () => {
            const userId = `user-id-${collection}`;
            const ownerId = `owner-id-${collection}`;
            const ownerDb = getAuthenticatedDb(ownerId);
            const userDb = getAuthenticatedDb(userId);

            // Create a document in the main collection
            const docRef = await ownerDb.collection(collection).add({
              userId: ownerId,
              name: `Test ${collection}`,
            });

            // Add the user as a participant
            await ownerDb
              .collection(collection)
              .doc(docRef.id)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .doc(userId)
              .set({
                userId: userId,
                name: "Participant",
              });

            // Try to read the participant document
            await expect(
              userDb
                .collection(collection)
                .doc(docRef.id)
                .collection(PARTICIPANTS_SUBCOLLECTION)
                .doc(userId)
                .get()
            ).resolves.toBeDefined();
          });

          it(`should not allow authenticated users to read other users' participant documents in ${collection}`, async () => {
            const userId = `user-id-other-${collection}`;
            const otherUserId = `other-user-id-${collection}`;
            const ownerId = `owner-id-other-${collection}`;
            const ownerDb = getAuthenticatedDb(ownerId);
            const userDb = getAuthenticatedDb(userId);

            // Create a document in the main collection
            const docRef = await ownerDb.collection(collection).add({
              userId: ownerId,
              name: `Test ${collection}`,
            });

            // Add another user as a participant
            await ownerDb
              .collection(collection)
              .doc(docRef.id)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .doc(otherUserId)
              .set({
                userId: otherUserId,
                name: "Other Participant",
              });

            // Try to read the other user's participant document
            await expect(
              userDb
                .collection(collection)
                .doc(docRef.id)
                .collection(PARTICIPANTS_SUBCOLLECTION)
                .doc(otherUserId)
                .get()
            ).rejects.toThrow();
          });

          it(`should not allow unauthenticated users to read participant documents in ${collection}`, async () => {
            const ownerId = `owner-id-unauth-${collection}`;
            const participantId = `participant-id-unauth-${collection}`;
            const ownerDb = getAuthenticatedDb(ownerId);
            const unauthDb = getUnauthenticatedDb();

            // Create a document in the main collection
            const docRef = await ownerDb.collection(collection).add({
              userId: ownerId,
              name: `Test ${collection}`,
            });

            // Add a participant
            await ownerDb
              .collection(collection)
              .doc(docRef.id)
              .collection(PARTICIPANTS_SUBCOLLECTION)
              .doc(participantId)
              .set({
                userId: participantId,
                name: "Participant",
              });

            // Try to read the participant document with unauthenticated user
            await expect(
              unauthDb
                .collection(collection)
                .doc(docRef.id)
                .collection(PARTICIPANTS_SUBCOLLECTION)
                .doc(participantId)
                .get()
            ).rejects.toThrow();
          });
        });
      });
    });

    describe("Write operations", () => {
      it("should not allow creating participant documents using the wildcard rule", async () => {
        const userId = "user-id-create";
        const db = getAuthenticatedDb(userId);

        await expect(
          db
            .collection("some_collection")
            .doc("some_doc")
            .collection(PARTICIPANTS_SUBCOLLECTION)
            .add({
              userId: userId,
              name: "New Participant",
            })
        ).rejects.toThrow();
      });

      it("should not allow updating participant documents using the wildcard rule", async () => {
        const userId = "user-id-update";
        const db = getAuthenticatedDb(userId);

        await expect(
          db
            .collection("some_collection")
            .doc("some_doc")
            .collection(PARTICIPANTS_SUBCOLLECTION)
            .doc(userId)
            .update({
              name: "Updated Participant",
            })
        ).rejects.toThrow();
      });

      it("should not allow deleting participant documents using the wildcard rule", async () => {
        const userId = "user-id-delete";
        const db = getAuthenticatedDb(userId);

        await expect(
          db
            .collection("some_collection")
            .doc("some_doc")
            .collection(PARTICIPANTS_SUBCOLLECTION)
            .doc(userId)
            .delete()
        ).rejects.toThrow();
      });
    });
  });

  describe("search_challenges collection", () => {
    describe("Read operations", () => {
      it("should allow authenticated users to read search challenges", async () => {
        const userId = "user-id1";
        const db = getAuthenticatedDb(userId);

        // Add a search challenge document without rules
        await addDocumentWithoutRules(SEARCH_CHALLENGES_COLLECTION, {
          name: "Test Search Challenge",
        });

        // Try to read the search challenges collection
        await expect(
          db.collection(SEARCH_CHALLENGES_COLLECTION).get()
        ).resolves.toBeDefined();
      });

      it("should allow authenticated users to read a specific search challenge", async () => {
        const userId = "user-id2";
        const db = getAuthenticatedDb(userId);

        // Add a search challenge document without rules
        let docId;
        await testEnv.withSecurityRulesDisabled(async (context) => {
          const docRef = await context
            .firestore()
            .collection(SEARCH_CHALLENGES_COLLECTION)
            .add({ name: "Specific Search Challenge" });
          docId = docRef.id;
        });

        // Try to read the specific search challenge
        await expect(
          db.collection(SEARCH_CHALLENGES_COLLECTION).doc(docId).get()
        ).resolves.toBeDefined();
      });

      it("should not allow unauthenticated users to read search challenges", async () => {
        const db = getUnauthenticatedDb();

        // Add a search challenge document without rules
        await addDocumentWithoutRules(SEARCH_CHALLENGES_COLLECTION, {
          name: "Unauthenticated Test Challenge",
        });

        // Try to read the search challenges collection
        await expect(
          db.collection(SEARCH_CHALLENGES_COLLECTION).get()
        ).rejects.toThrow();
      });
    });

    describe("Write operations", () => {
      it("should not allow authenticated users to create search challenges", async () => {
        const userId = "user-id3";
        const db = getAuthenticatedDb(userId);

        // Try to create a new search challenge
        await expect(
          db.collection(SEARCH_CHALLENGES_COLLECTION).add({
            name: "New Search Challenge",
          })
        ).rejects.toThrow();
      });

      it("should not allow authenticated users to update search challenges", async () => {
        const userId = "user-id4";
        const db = getAuthenticatedDb(userId);

        // Add a search challenge document without rules
        let docId;
        await testEnv.withSecurityRulesDisabled(async (context) => {
          const docRef = await context
            .firestore()
            .collection(SEARCH_CHALLENGES_COLLECTION)
            .add({ name: "Existing Search Challenge" });
          docId = docRef.id;
        });

        // Try to update the search challenge
        await expect(
          db.collection(SEARCH_CHALLENGES_COLLECTION).doc(docId).update({
            name: "Updated Search Challenge",
          })
        ).rejects.toThrow();
      });

      it("should not allow authenticated users to delete search challenges", async () => {
        const userId = "user-id5";
        const db = getAuthenticatedDb(userId);

        // Add a search challenge document without rules
        let docId;
        await testEnv.withSecurityRulesDisabled(async (context) => {
          const docRef = await context
            .firestore()
            .collection(SEARCH_CHALLENGES_COLLECTION)
            .add({ name: "Deletable Search Challenge" });
          docId = docRef.id;
        });

        // Try to delete the search challenge
        await expect(
          db.collection(SEARCH_CHALLENGES_COLLECTION).doc(docId).delete()
        ).rejects.toThrow();
      });

      it("should not allow unauthenticated users to write search challenges", async () => {
        const db = getUnauthenticatedDb();

        // Try to create a new search challenge
        await expect(
          db.collection(SEARCH_CHALLENGES_COLLECTION).add({
            name: "Unauthorized Search Challenge",
          })
        ).rejects.toThrow();
      });
    });
  });
});
