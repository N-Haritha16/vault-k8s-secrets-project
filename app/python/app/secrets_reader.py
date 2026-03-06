from pathlib import Path

SECRETS_DIR = Path("/vault/secrets")

def file_content(name: str) -> str | None:
    try:
        return (SECRETS_DIR / name).read_text().strip()
    except FileNotFoundError:
        return None
