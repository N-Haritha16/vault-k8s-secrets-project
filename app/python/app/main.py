from fastapi import FastAPI
from .secrets_reader import file_content

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/secrets")
def secrets():
    db_creds = file_content("db-creds.txt")
    kv_config = file_content("kv-config.txt")
    return {
        "message": "Secrets loaded via Vault Agent Injector",
        "dbCredsPresent": db_creds is not None,
        "kvConfigPresent": kv_config is not None,
    }
