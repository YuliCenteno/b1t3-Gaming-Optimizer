# ============================================================
# b1t3 Gaming Optimizer
#
# Module : 11-InputLag.ps1
# Author : Juliano Andres Centeno (b1t3)
# ============================================================

. "$PSScriptRoot\..\Lib\Utils.ps1"

Write-Section "INPUT LAG & MOUSE OPTIMIZATION"

# 1. Desactivar la aceleración del ratón (Precision de puntero)
Set-RegString "HKCU:\Control Panel\Mouse" "MouseSpeed" "0"
Set-RegString "HKCU:\Control Panel\Mouse" "MouseThreshold1" "0"
Set-RegString "HKCU:\Control Panel\Mouse" "MouseThreshold2" "0"

# 2. Desactivar la reserva de tiempo de CPU para servicios del sistema
Set-RegDWORD "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" 0

Write-OK "Aceleracion de raton deshabilitada."
Write-OK "Latencia del planificador reducida al minimo."