# Despliega backend (Hugging Face) + frontend (Firebase) - SIN tarjeta

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot
$BackendDir = Join-Path $Root "backend"
$FrontendDir = Join-Path $Root "frontend"
$CredentialsFile = Join-Path $BackendDir "firebase-service-account.json"
$SpaceId = "Pierox123274/ejercicio2-api"
$FirebaseUrl = "https://console.firebase.google.com/project/ing-web-93d49/settings/serviceaccounts/adminsdk"

Write-Host "=== Despliegue en la nube (sin tarjeta) ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "NOTA: Render SIEMPRE pide tarjeta. Usamos Hugging Face Spaces (gratis)." -ForegroundColor Yellow
Write-Host ""

if (-not (Test-Path $CredentialsFile)) {
    Write-Host "Paso 1: Descarga credenciales Firebase (no pide tarjeta)" -ForegroundColor Yellow
    Write-Host "  Guarda el JSON como: $CredentialsFile" -ForegroundColor White
    Start-Process $FirebaseUrl
    Write-Host ""
    Write-Host "Cuando tengas el archivo, vuelve a ejecutar: .\deploy-nube.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "Paso 1: Verificando Hugging Face..." -ForegroundColor Cyan
Set-Location $BackendDir
$hfAuth = .\.venv\Scripts\python -c "from huggingface_hub import HfApi; print(HfApi().whoami()['name'])" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Inicia sesion en Hugging Face (gratis, sin tarjeta):" -ForegroundColor Yellow
    Write-Host "  1. Crea cuenta en https://huggingface.co/join" -ForegroundColor White
    Write-Host "  2. Token en https://huggingface.co/settings/tokens" -ForegroundColor White
    Write-Host "  3. Ejecuta: .\.venv\Scripts\huggingface-cli login" -ForegroundColor White
    exit 1
}
Write-Host "  Usuario HF: $hfAuth" -ForegroundColor Green

Write-Host ""
Write-Host "Paso 2: Desplegando backend en Hugging Face..." -ForegroundColor Cyan
$deployScript = @"
from pathlib import Path
import json
from huggingface_hub import HfApi, create_repo, upload_folder, add_space_secret

space_id = "$SpaceId"
backend = Path(r"$BackendDir")
credentials = json.loads(Path(r"$CredentialsFile").read_text(encoding="utf-8"))

api = HfApi()
try:
    create_repo(space_id, repo_type="space", space_sdk="docker", exist_ok=True)
except Exception:
    pass

upload_folder(
    folder_path=str(backend),
    repo_id=space_id,
    repo_type="space",
    ignore_patterns=[".venv", "__pycache__", "scripts", ".env", ".env.example", ".gitignore"],
)

add_space_secret(space_id, "FIREBASE_PROJECT_ID", "ing-web-93d49")
add_space_secret(space_id, "PERSONAS_COLLECTION", "personas")
add_space_secret(space_id, "FIREBASE_CREDENTIALS_JSON", json.dumps(credentials))
add_space_secret(space_id, "CORS_ORIGINS", "https://ing-web-93d49.web.app,https://ing-web-93d49.firebaseapp.com")
print("Backend desplegado en Hugging Face")
"@

$deployScript | Out-File -Encoding utf8 (Join-Path $Root "deploy_hf_temp.py")
.\.venv\Scripts\python (Join-Path $Root "deploy_hf_temp.py")
Remove-Item (Join-Path $Root "deploy_hf_temp.py") -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Paso 3: Desplegando frontend en Firebase..." -ForegroundColor Cyan
Set-Location $FrontendDir
npm run build:hosting
Set-Location $Root
firebase deploy --only hosting --project ing-web-93d49

Write-Host ""
Write-Host "=== LISTO ===" -ForegroundColor Green
Write-Host "  App:     https://ing-web-93d49.web.app" -ForegroundColor White
Write-Host "  API:     https://pierox123274-ejercicio2-api.hf.space/api/health" -ForegroundColor White
Write-Host ""
Write-Host "Espera 2-3 minutos a que Hugging Face termine de construir el backend." -ForegroundColor Yellow
