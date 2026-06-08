# Instalacion inicial de Ejercicio2 (ejecutar una sola vez)

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot
$BackendDir = Join-Path $Root "backend"
$FrontendDir = Join-Path $Root "frontend"

Write-Host "=== Instalacion Ejercicio2 ===" -ForegroundColor Cyan

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Instala Node.js 20+ desde https://nodejs.org" -ForegroundColor Red
    exit 1
}

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Instala Python 3.11+ desde https://python.org" -ForegroundColor Red
    exit 1
}

if (-not (Get-Command firebase -ErrorAction SilentlyContinue)) {
    Write-Host "Instala Firebase CLI: npm install -g firebase-tools" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[1/4] Backend Python..." -ForegroundColor Cyan
Set-Location $BackendDir
if (-not (Test-Path ".venv")) {
    python -m venv .venv
}
.\.venv\Scripts\pip install -r requirements.txt

Write-Host ""
Write-Host "[2/4] Frontend Angular..." -ForegroundColor Cyan
Set-Location $FrontendDir
npm install

Write-Host ""
Write-Host "[3/4] Firebase login..." -ForegroundColor Cyan
$firebaseUser = firebase login:list 2>&1
if ($firebaseUser -match "No authorized accounts") {
    Write-Host "Inicia sesion en Firebase..." -ForegroundColor Yellow
    firebase login
}

Write-Host ""
Write-Host "[4/4] Verificando Firestore..." -ForegroundColor Cyan
Set-Location $BackendDir
.\.venv\Scripts\python scripts\test_connection.py
if ($LASTEXITCODE -ne 0) {
    Write-Host "No se pudo conectar a Firebase. Ejecuta: firebase login" -ForegroundColor Red
    exit 1
}

Set-Location $Root
Write-Host ""
Write-Host "Instalacion completa." -ForegroundColor Green
Write-Host "Para iniciar la app ejecuta: .\start.ps1" -ForegroundColor Green
