import fs from "fs/promises";
import path from "path";

const secretsDir = "/vault/secrets";

async function readSecretFile(filename) {
  try {
    const fullPath = path.join(secretsDir, filename);
    const content = await fs.readFile(fullPath, "utf8");
    return content.trim();
  } catch {
    return null;
  }
}

export async function loadSecrets() {
  const dbCreds = await readSecretFile("db-creds.txt");
  const kvConfig = await readSecretFile("kv-config.txt");

  return {
    dbCredsPresent: Boolean(dbCreds),
    kvConfigPresent: Boolean(kvConfig)
  };
}
