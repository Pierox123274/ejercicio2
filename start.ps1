# Inicia Ejercicio2 (backend + frontend)

$Root = $PSScriptRoot
$BackendDir = Join-Path $Root "backend"
$FrontendDir = Join-Path $Root "frontend"

function Test-PortInUse([int]$Port) {
    return [bool](netstat -ano | findstr ":$Port " | findstr "LISTENING")
}

function Get-ListenerPid([int]$Port) {
    $line = netstat -ano | findstr ":$Port " | findstr "LISTENING" | Select-Object -First 1
    if ($line) {
        return ($line -split '\s+')[-1]
    }
    return $null
}

Write-Host "=== Ejercicio2 ===" -ForegroundColor Cyan

if (-not (Test-Path (Join-Path $BackendDir ".venv"))) {
    Write-Host "Primera vez? Ejecuta: .\install.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "Verificando Firebase..." -ForegroundColor Cyan
Set-Location $BackendDir
$test = .\.venv\Scripts\python scripts\test_connection.py 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host $test -ForegroundColor Red
    Write-Host "Ejecuta: firebase login" -ForegroundColor Yellow
    exit 1
}
Write-Host $test -ForegroundColor Green

if (Test-PortInUse 8001) {
    Write-Host "Backend ya activo en http://localhost:8001" -ForegroundColor Yellow
} else {
    Write-Host "Iniciando backend en http://localhost:8001 ..." -ForegroundColor Cyan
    Start-Process powershell -ArgumentList @(
        "-NoExit",
        "-Command",
        "Set-Location '$BackendDir'; .\.venv\Scripts\Activate.ps1; uvicorn main:app --reload --port 8001"
    )
    Start-Sleep -Seconds 3
}

if (Test-PortInUse 4201) {
    Write-Host "Frontend ya activo en http://localhost:4201" -ForegroundColor Yellow
} else {
    Write-Host "Iniciando frontend en http://localhost:4201 ..." -ForegroundColor Cyan
    Start-Process powershell -ArgumentList @(
        "-NoExit",
        "-Command",
        "Set-Location '$FrontendDir'; npm start -- --port 4201"
    )
    Start-Sleep -Seconds 8
}

Write-Host ""
Write-Host "App lista:" -ForegroundColor Green
Write-Host "  Frontend: http://localhost:4201" -ForegroundColor White
Write-Host "  API:      http://localhost:8001/docs" -ForegroundColor White
Write-Host "  Firebase: ing-web-93d49 (Firestore)" -ForegroundColor White

Start-Process "http://localhost:4201"
