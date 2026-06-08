# Detiene los servidores locales de Ejercicio2

function Stop-Port([int]$Port, [string]$Name) {
    $processId = (netstat -ano | findstr ":$Port " | findstr "LISTENING" | ForEach-Object { ($_ -split '\s+')[-1] } | Select-Object -First 1)
    if ($processId) {
        taskkill /PID $processId /F 2>$null | Out-Null
        Write-Host "Detenido $Name (puerto $Port, PID $processId)" -ForegroundColor Green
    } else {
        Write-Host "$Name no estaba activo (puerto $Port)" -ForegroundColor Yellow
    }
}

Write-Host "Deteniendo Ejercicio2..." -ForegroundColor Cyan
Stop-Port 8001 "Backend"
Stop-Port 4201 "Frontend"
