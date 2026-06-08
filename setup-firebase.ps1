# Verifica la conexión con Firebase Firestore (ing-web-93d49)

$BackendDir = Join-Path $PSScriptRoot "backend"
$CredentialsFile = Join-Path $BackendDir "firebase-service-account.json"
$ServiceAccountUrl = "https://console.firebase.google.com/project/ing-web-93d49/settings/serviceaccounts/adminsdk"

Write-Host "Proyecto Firebase: ing-web-93d49" -ForegroundColor Cyan
Write-Host "Base de datos: Firestore (default)" -ForegroundColor Cyan

if (-not (Test-Path $CredentialsFile)) {
    Write-Host ""
    Write-Host "Sin archivo de cuenta de servicio. Usando sesión de Firebase CLI..." -ForegroundColor Yellow
}

Set-Location $BackendDir
$test = .\.venv\Scripts\python scripts\test_connection.py 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host $test -ForegroundColor Red
    Write-Host ""
    Write-Host "Opción A: firebase login" -ForegroundColor Yellow
    Write-Host "Opción B: descargar clave privada y guardarla en:" -ForegroundColor Yellow
    Write-Host "  $CredentialsFile" -ForegroundColor White
    Start-Process $ServiceAccountUrl
    exit 1
}

Write-Host $test -ForegroundColor Green
Write-Host ""
Write-Host "Firebase conectado correctamente." -ForegroundColor Green
