# ============================================================
# b1t3 Gaming Optimizer - Script de Restauración
# ============================================================

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "     RESTAURANDO CONFIGURACIÓN NATIVA"
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Habilitar GameDVR y Barra de Juego
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Value 145 -ErrorAction SilentlyContinue

# 2. Restaurar Plan de Energía Balanceado / Alto Rendimiento
powercfg /S SCHEME_BALANCED

# 3. Reactivar Servicios Básicos
$Services = @("SysMain", "WSearch", "MapsBroker", "WerSvc")
foreach ($Svc in $Services) {
    Set-Service -Name $Svc -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service -Name $Svc -ErrorAction SilentlyContinue
}

# 4. Volver a activar la compresión de memoria
Enable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "[OK] Ajustes principales restaurados a los valores por defecto de Windows." -ForegroundColor Green
Read-Host "Presione ENTER para salir"