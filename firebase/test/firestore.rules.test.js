import { initializeTestEnvironment } from "@firebase/rules-unit-testing";
import { jest } from "@jest/globals";
import fs from "fs";
import fetch from "node-fetch";

global.jest = jest;
global.fetch = fetch;

let testEnv;

beforeAll(async () => {
  jest.setTimeout(10000);
  testEnv = await initializeTestEnvironment({
    projectId: "project-id",
    firestore: {
      rules: fs.readFileSync("firestore.rules", "utf8"),
      host: "127.0.0.1",
      port: 9151,
    },
  });
});

afterAll(async () => {
  await testEnv.cleanup();
});

function getAuthenticatedDb(auth) {
  const adminContext = testEnv.authenticatedContext(auth ?? "user-id");
  return adminContext.firestore();
}

function getUnauthenticatedDb(auth) {
  const adminContext = testEnv.unauthenticatedContext(auth);
  return adminContext.firestore();
}

describe("Firestore Security Rules", () => {
  describe("migrations collection", () => {
    it("should allow authenticated user to read the documents", async () => {
      const db = getAuthenticatedDb();
      await expect(db.collection("migrations").get()).resolves.toBeDefined();
    });
  });

  describe("users collection", () => {
    it("should allow authenticated users to read documents", async () => {
      const authenticatedContext = testEnv.authenticatedContext("daniel");
      const db = authenticatedContext.firestore();
      const docRef = db.collection("users").doc("daniel");
      await expect(docRef.get()).resolves.toBeDefined();
    });

    it("should not allow unauthenticated users to read documents", async () => {
      const unauthenticatedContext = testEnv.unauthenticatedContext();
      const db = unauthenticatedContext.firestore();
      const docRef = db.collection("users").doc("daniel");
      await expect(docRef.get()).rejects.toThrow();
    });
  });

  it("should get document", async () => {
    const authenticatedContext = testEnv.authenticatedContext("user1");
    const db = authenticatedContext.firestore();
    const docRef = db.collection("users").doc("user1");
    await expect(docRef.get()).resolves.toBeDefined();
  });
});
