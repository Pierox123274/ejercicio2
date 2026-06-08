import firebase_admin
from fastapi.testclient import TestClient
from firebase_admin import initialize_app
from firebase_functions import https_fn, options

if not firebase_admin._apps:
    initialize_app()

from app.main import app

client = TestClient(app)


@https_fn.on_request(
    region="us-central1",
    memory=options.MemoryOption.MB_512,
    cors=options.CorsOptions(
        cors_origins=[
            "https://ing-web-93d49.web.app",
            "https://ing-web-93d49.firebaseapp.com",
        ],
        cors_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    ),
)
def api(req: https_fn.Request) -> https_fn.Response:
    headers = {
        key: value
        for key, value in req.headers.items()
        if key.lower() not in {"host", "content-length", "connection"}
    }

    response = client.request(
        method=req.method,
        url=req.path,
        params=req.args,
        content=req.get_data(),
        headers=headers,
    )

    excluded = {"content-length", "transfer-encoding", "connection", "content-encoding"}
    response_headers = {
        key: value
        for key, value in response.headers.items()
        if key.lower() not in excluded
    }

    return https_fn.Response(
        response.content,
        status=response.status_code,
        headers=response_headers,
    )
