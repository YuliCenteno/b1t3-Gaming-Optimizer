# ============================================================
# b1t3 Gaming Optimizer
#
# Module : 10-Gaming.ps1
# Author : Juliano Andres Centeno (b1t3)
# GitHub : https://github.com/Yulicenteno
# License: MIT
#
# Copyright (c) 2026 Juliano Andres Centeno
# ============================================================

. "$PSScriptRoot\..\Lib\Utils.ps1"

Write-Section "GAMING TWEAKS"

#==================================================
# Game Mode
#==================================================

Write-Section "GAME MODE"

Set-RegDWORD `
"HKCU:\Software\Microsoft\GameBar" `
"AutoGameModeEnabled" `
1

Set-RegDWORD `
"HKCU:\Software\Microsoft\GameBar" `
"AllowAutoGameMode" `
1

Write-OK "Game Mode"

#==================================================
# Multimedia Scheduler
#==================================================

Write-Section "MMCSS"

Set-RegDWORD `
"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" `
"NetworkThrottlingIndex" `
0xffffffff

Set-RegDWORD `
"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" `
"SystemResponsiveness" `
0

Write-OK "MMCSS"

#==================================================
# Games Task
#==================================================

$GameTask="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"

Set-RegDWORD $GameTask "GPU Priority" 8

Set-RegDWORD $GameTask "Priority" 6

Set-RegString $GameTask "Scheduling Category" "High"

Set-RegString $GameTask "SFIO Priority" "High"

Write-OK "Games Task"

#==================================================
# Mouse
#==================================================

Write-Section "MOUSE"

Set-RegString `
"HKCU:\Control Panel\Mouse" `
"MouseSensitivity" `
"10"

Set-RegString `
"HKCU:\Control Panel\Mouse" `
"MouseSpeed" `
"0"

Set-RegString `
"HKCU:\Control Panel\Mouse" `
"MouseThreshold1" `
"0"

Set-RegString `
"HKCU:\Control Panel\Mouse" `
"MouseThreshold2" `
"0"

Write-OK "Mouse"

#==================================================
# Explorer
#==================================================

Write-Section "STARTUP DELAY"

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" `
"StartupDelayInMSec" `
0

Write-OK "Startup Delay"

#==================================================
# PRIORIDAD DE PROCESADOR (Foreground Focus)
#==================================================

Write-Section "CPU PRIORITY"

# Le da máxima prioridad de ciclo de reloj al programa en primer plano
Set-RegDWORD `
"HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" `
"Win32PrioritySeparation" `
38

Write-OK "Prioridad de CPU optimizada para juegos."

#==================================================
# LIMITADOR DE FPS AUTOMÁTICO (FPS Cap)
#==================================================

Write-Section "LIMITADOR DE FPS"

try {
    # Detectar los Hz del monitor principal
    $RefreshRate = (Get-CimInstance WmiMonitorBasicDisplayParams -Namespace root\wmi).MaxHorizontalScanRate
    # Alternativa por Win32_VideoController si la anterior falla
    $Hz = (Get-CimInstance Win32_VideoController | Select-Object -First 1).CurrentRefreshRate

    if ($Hz -gt 30) {
        # Restar 3 FPS al valor del monitor (Ejemplo: 144Hz -> 141 FPS)
        $TargetFPS = $Hz - 3
        
        # Aplicar el límite a nivel de sistema para DirectX/OpenGL
        Set-RegDWORD "HKLM:\SOFTWARE\Microsoft\DirectX" "MaxFrameRate" $TargetFPS
        
        Write-OK "FPS limitados automaticamente a $TargetFPS FPS (Monitor detectado a $Hz Hz)."
    }
} catch {
    Write-Warn "No se pudo detectar la tasa de refresco del monitor para limitar los FPS."
}

#==================================================
# Win32 Priority
#==================================================

Write-Section "WIN32 PRIORITY"

Set-RegDWORD `
"HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" `
"Win32PrioritySeparation" `
38

Write-OK "Win32 Priority"

Write-Host ""

Write-Host "Gaming Tweaks Finalizados." -ForegroundColor Green