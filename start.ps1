# Inicia backend (FastAPI) y frontend (Angular) de Ejercicio2

$Root = $PSScriptRoot
$BackendDir = Join-Path $Root "backend"
$FrontendDir = Join-Path $Root "frontend"

Write-Host "Verificando conexión con Firebase..." -ForegroundColor Cyan
Set-Location $BackendDir
$test = .\.venv\Scripts\python scripts\test_connection.py 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host $test -ForegroundColor Red
    Write-Host ""
    Write-Host "Ejecuta primero: firebase login" -ForegroundColor Yellow
    exit 1
}
Write-Host $test -ForegroundColor Green

Write-Host ""
Write-Host "Iniciando backend en http://localhost:8001 ..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "Set-Location '$BackendDir'; .\.venv\Scripts\Activate.ps1; uvicorn main:app --reload --port 8001"
)

Start-Sleep -Seconds 2

Write-Host "Iniciando frontend en http://localhost:4201 ..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "Set-Location '$FrontendDir'; npm start -- --port 4201"
)

Write-Host ""
Write-Host "Listo. Abre http://localhost:4201" -ForegroundColor Green
Write-Host "API docs: http://localhost:8001/docs" -ForegroundColor Green
