import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from "@firebase/rules-unit-testing";
import { expect } from "chai";
import fs from "fs";
import fetch from "node-fetch";
global.fetch = fetch;

const projectId = "project-id";

describe("Firestore Security Rules", function () {
  let testEnv;

  before(async function () {
    this.timeout(10000);
    testEnv = await initializeTestEnvironment({
      projectId,
      firestore: {
        rules: fs.readFileSync("firestore.rules", "utf8"),
        host: "127.0.0.1",
        port: 9151,
      },
    });

    // Add test data
    const adminContext = testEnv.authenticatedContext("daniel");
    const adminDb = adminContext.firestore();
    await adminDb.collection("users").doc("daniel").set({
      name: "Test User",
      email: "test@example.com",
    });
  });

  after(async function () {
    await testEnv.cleanup();
  });

  describe("Users collection", function () {
    it("should allow authenticated users to read documents", async function () {
      const authenticatedContext = testEnv.authenticatedContext("daniel");
      const db = authenticatedContext.firestore();
      const docRef = db.collection("users").doc("daniel");
      await assertSucceeds(docRef.get());
    });

    it("should not allow unauthenticated users to read documents", async function () {
      const unauthenticatedContext = testEnv.unauthenticatedContext();
      const db = unauthenticatedContext.firestore();
      const docRef = db.collection("users").doc("daniel");
      await assertFails(docRef.get());
    });
  });

  it("should calculate the sum of two numbers", async function () {
    const a = 1;
    const b = 2;
    const expectedResult = 3;
    const result = a + b;
    expect(result).to.equal(expectedResult);
  });

  it("should get document", async function () {
    // Create an authenticated context
    const authenticatedContext = testEnv.authenticatedContext("user1");

    // Get a reference to the Firestore instance
    const db = authenticatedContext.firestore();

    // Create a reference to the document
    const docRef = db.collection("users").doc("user1");

    // Attempt to get the document
    await assertSucceeds(docRef.get());
  });
});
