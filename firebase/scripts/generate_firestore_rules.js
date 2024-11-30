import * as dotenv from "dotenv";
import * as fs from "fs";
import * as path from "path";
import { fileURLToPath } from "url";

console.log("Generating Firestore rules...");

loadEnv();

var rules = fs.readFileSync("firestore.template.rules", "utf8");
rules = rules.replace("MIGRATION_USER_ID", process.env.MIGRATION_USER_ID);
fs.writeFileSync("firestore.rules", rules);
console.log("Firestore rules generated successfully.");

// somehow dotenv.config() caches old envs
function loadEnv() {
  const __filename = fileURLToPath(import.meta.url);
  const __dirname = path.dirname(__filename);
  const envPath = path.resolve(__dirname, "../../.env");
  const envConfig = dotenv.parse(fs.readFileSync(envPath));
  for (const k in envConfig) {
    process.env[k] = envConfig[k];
  }
}
