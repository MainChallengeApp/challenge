const dotenv = require("dotenv");
const fs = require("fs");
const path = require("path");

module.exports.loadEnv = function () {
  const envPath = path.resolve(__dirname, "../../.env");
  const envConfig = dotenv.parse(fs.readFileSync(envPath));
  for (const k in envConfig) {
    process.env[k] = envConfig[k];
  }
};
