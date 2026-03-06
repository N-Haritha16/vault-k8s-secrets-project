const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const port = process.env.APP_PORT || 3000;

function fileExists(p) {
  try {
    fs.accessSync(p, fs.constants.R_OK);
    return true;
  } catch {
    return false;
  }
}

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.get('/secrets', (req, res) => {
  const dbCredsPath = '/vault/secrets/db-creds.txt';
  const kvConfigPath = '/vault/secrets/kv-config.txt';

  const dbCredsPresent = fileExists(dbCredsPath);
  const kvConfigPresent = fileExists(kvConfigPath);

  res.json({
    dbCredsPresent,
    kvConfigPresent
  });
});

app.listen(port, () => {
  console.log(`Sample app listening on port ${port}`);
});
