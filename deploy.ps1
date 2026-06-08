param(
    [ValidateSet("render", "firebase", "all")]
    [string]$Target = "all"
)

$Root = $PSScriptRoot
$BackendDir = Join-Path $Root "backend"
$FrontendDir = Join-Path $Root "frontend"
$CredentialsFile = Join-Path $BackendDir "firebase-service-account.json"

function Test-FirebaseCredentials {
    if (-not (Test-Path $CredentialsFile)) {
        Write-Host "Falta backend/firebase-service-account.json" -ForegroundColor Yellow
        Write-Host "Descargalo desde Firebase Console -> Cuentas de servicio" -ForegroundColor Yellow
        Start-Process "https://console.firebase.google.com/project/ing-web-93d49/settings/serviceaccounts/adminsdk"
        return $false
    }
    return $true
}

function Show-RenderSecret {
    $json = Get-Content $CredentialsFile -Raw
    Write-Host ""
    Write-Host "Copia este valor en Render -> ejercicio2-api -> FIREBASE_CREDENTIALS_JSON" -ForegroundColor Cyan
    Write-Host $json
    Write-Host ""
}

if ($Target -in @("render", "all")) {
    if (Test-FirebaseCredentials) {
        Show-RenderSecret
        Write-Host "Luego en Render: New -> Blueprint -> conecta el repo de GitHub" -ForegroundColor Green
        Start-Process "https://dashboard.render.com/blueprints"
    }
}

if ($Target -in @("firebase", "all")) {
    Write-Host "Construyendo frontend para produccion..." -ForegroundColor Cyan
    Set-Location $FrontendDir
    npm run build:hosting
    Set-Location $Root
    Write-Host "Desplegando en Firebase Hosting..." -ForegroundColor Cyan
    firebase deploy --only hosting --project ing-web-93d49
}
