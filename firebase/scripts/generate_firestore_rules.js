const fs = require("fs");
const { loadEnv } = require("./load_env.js");

console.log("Generating Firestore rules...");

loadEnv();

var rules = fs.readFileSync("firestore.template.rules", "utf8");
rules = rules.replace("MIGRATION_USER_ID", process.env.MIGRATION_USER_ID);
fs.writeFileSync("firestore.rules", rules);
console.log("Firestore rules generated successfully.");
