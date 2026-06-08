# Despliega backend (Cloud Functions) + frontend (Hosting) en Firebase

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot

Write-Host "Sincronizando codigo del backend..." -ForegroundColor Cyan
robocopy (Join-Path $Root "backend") (Join-Path $Root "functions\app") /E /XD .venv __pycache__ scripts /XF .env .env.example firebase-service-account.json .gitignore /NFL /NDL /NJH /NJS | Out-Null

Write-Host "Construyendo frontend..." -ForegroundColor Cyan
Set-Location (Join-Path $Root "frontend")
npm run build:hosting

Write-Host "Desplegando backend y frontend en Firebase..." -ForegroundColor Cyan
Set-Location $Root
firebase deploy --only functions,firestore:rules,hosting --project ing-web-93d49

Write-Host ""
Write-Host "Listo:" -ForegroundColor Green
Write-Host "  App:     https://ing-web-93d49.web.app" -ForegroundColor White
Write-Host "  API:     https://ing-web-93d49.web.app/api/health" -ForegroundColor White
