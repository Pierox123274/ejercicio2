import json
import os
from pathlib import Path

import firebase_admin
from firebase_admin import credentials, firestore as admin_firestore
from google.auth.transport.requests import Request
from google.cloud import firestore
from google.oauth2.credentials import Credentials as UserCredentials

from core.config import FIREBASE_CREDENTIALS_JSON, FIREBASE_PROJECT_ID, resolve_credentials_path

_firestore_client: firestore.Client | None = None
_auth_mode: str | None = None
_FIREBASE_CLI_CLIENT_ID = (
    "563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com"
)
_FIREBASE_CLI_CONFIG = Path.home() / ".config" / "configstore" / "firebase-tools.json"


def _is_cloud_runtime() -> bool:
    return bool(
        os.getenv("K_SERVICE")
        or os.getenv("FUNCTION_TARGET")
        or os.getenv("FUNCTIONS_EMULATOR")
    )


def get_auth_mode() -> str:
    if _auth_mode is None:
        get_db()
    return _auth_mode or "unknown"


def _get_cloud_client() -> firestore.Client:
    global _auth_mode

    if not firebase_admin._apps:
        firebase_admin.initialize_app(options={"projectId": FIREBASE_PROJECT_ID})

    _auth_mode = "application-default"
    return admin_firestore.client()


def _get_service_account_client(credentials_path: Path) -> firestore.Client:
    global _auth_mode

    if not firebase_admin._apps:
        cred = credentials.Certificate(str(credentials_path))
        options = {"projectId": FIREBASE_PROJECT_ID} if FIREBASE_PROJECT_ID else None
        firebase_admin.initialize_app(cred, options)

    _auth_mode = "service-account"
    return admin_firestore.client()


def _get_cli_auth_client() -> firestore.Client:
    global _auth_mode

    if not _FIREBASE_CLI_CONFIG.exists():
        raise FileNotFoundError(
            "No hay credenciales de Firebase. Configura FIREBASE_CREDENTIALS_JSON "
            "o guarda firebase-service-account.json en backend/."
        )

    config = json.loads(_FIREBASE_CLI_CONFIG.read_text(encoding="utf-8"))
    tokens = config.get("tokens", {})
    refresh_token = tokens.get("refresh_token")

    if not refresh_token:
        raise RuntimeError("Sesión de Firebase CLI no válida. Ejecuta: firebase login")

    creds = UserCredentials(
        token=tokens.get("access_token"),
        refresh_token=refresh_token,
        token_uri="https://oauth2.googleapis.com/token",
        client_id=_FIREBASE_CLI_CLIENT_ID,
    )

    if not creds.valid:
        creds.refresh(Request())

    _auth_mode = "firebase-cli"
    return firestore.Client(project=FIREBASE_PROJECT_ID, credentials=creds)


def get_db() -> firestore.Client:
    global _firestore_client

    if _firestore_client is not None:
        return _firestore_client

    if _is_cloud_runtime():
        _firestore_client = _get_cloud_client()
    elif FIREBASE_CREDENTIALS_JSON or resolve_credentials_path().exists():
        credentials_path = resolve_credentials_path()
        _firestore_client = _get_service_account_client(credentials_path)
    else:
        _firestore_client = _get_cli_auth_client()

    return _firestore_client
