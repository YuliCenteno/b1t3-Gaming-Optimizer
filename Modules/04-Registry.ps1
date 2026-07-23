# ============================================================
# b1t3 Gaming Optimizer
#
# Module : 04-Registry.ps1
# Author : Juliano Andres Centeno (b1t3)
# GitHub : https://github.com/Yulicenteno
# License: MIT
#
# Copyright (c) 2026 Juliano Andres Centeno
# ============================================================

. "$PSScriptRoot\..\Lib\Utils.ps1"

Write-Section "OPTIMIZANDO REGISTRO"

$Global:Root = Split-Path (Split-Path $PSScriptRoot -Parent)

#==================================================
# BACKUP
#==================================================

Backup-Registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" "Explorer"

Backup-Registry "HKCU\Control Panel\Desktop" "Desktop"

Backup-Registry "HKCU\Software\Microsoft\GameBar" "GameBar"

Backup-Registry "HKLM\SOFTWARE\Policies\Microsoft\Windows" "Policies"

Write-OK "Backup del registro completado."

#==================================================
# GAME DVR
#==================================================

Write-Section "GAME DVR"

Set-RegDWORD `
"HKCU:\System\GameConfigStore" `
"GameDVR_Enabled" `
0

Set-RegDWORD `
"HKCU:\System\GameConfigStore" `
"GameDVR_FSEBehaviorMode" `
2

Set-RegDWORD `
"HKCU:\System\GameConfigStore" `
"GameDVR_HonorUserFSEBehaviorMode" `
1

Set-RegDWORD `
"HKCU:\System\GameConfigStore" `
"GameDVR_DXGIHonorFSEWindowsCompatible" `
1

Set-RegDWORD `
"HKCU:\Software\Microsoft\GameBar" `
"ShowStartupPanel" `
0

Set-RegDWORD `
"HKCU:\Software\Microsoft\GameBar" `
"AllowAutoGameMode" `
1

Set-RegDWORD `
"HKCU:\Software\Microsoft\GameBar" `
"UseNexusForGameBarEnabled" `
0

Set-RegDWORD `
"HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" `
"AllowGameDVR" `
0

Write-OK "GameDVR optimizado."

#==================================================
# BACKGROUND APPS
#==================================================

Write-Section "BACKGROUND APPS"

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" `
"GlobalUserDisabled" `
1

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" `
"BackgroundAppGlobalToggle" `
0

Write-OK "Aplicaciones en segundo plano deshabilitadas."

#==================================================
# MENU DELAY
#==================================================

Write-Section "MENU"

Set-RegString `
"HKCU:\Control Panel\Desktop" `
"MenuShowDelay" `
"0"

Write-OK "MenuShowDelay = 0"

#==================================================
# VISUAL EFFECTS
#==================================================

Write-Section "VISUAL FX"

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" `
"VisualFXSetting" `
2

Write-OK "VisualFX = Mejor rendimiento"

#==================================================
# STARTUP DELAY
#==================================================

Write-Section "STARTUP"

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" `
"StartupDelayInMSec" `
0

Write-OK "StartupDelay eliminado."

#==================================================
# ADS
#==================================================

Write-Section "ADS"

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
"SubscribedContent-338388Enabled" `
0

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
"SubscribedContent-338389Enabled" `
0

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
"SubscribedContent-353698Enabled" `
0

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
"SystemPaneSuggestionsEnabled" `
0

Write-OK "Publicidad eliminada."

Write-Host ""
Write-Host "Registro (Parte 1) finalizado." -ForegroundColor Green

#==================================================
# CORTANA
#==================================================

Write-Section "CORTANA"

Set-RegDWORD `
"HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
"AllowCortana" `
0

Set-RegDWORD `
"HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
"DisableWebSearch" `
1

Write-OK "Cortana deshabilitada."


#==================================================
# WINDOWS SEARCH
#==================================================

Write-Section "SEARCH"

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" `
"BingSearchEnabled" `
0

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" `
"CortanaConsent" `
0

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" `
"SearchboxTaskbarMode" `
0

Write-OK "Busqueda optimizada."


#==================================================
# EXPLORER
#==================================================

Write-Section "EXPLORER"

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
"LaunchTo" `
1

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
"Hidden" `
1

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
"HideFileExt" `
0

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
"ShowSuperHidden" `
1

Write-OK "Explorer optimizado."


#==================================================
# POWER THROTTLING
#==================================================

Write-Section "POWER THROTTLING"

Set-RegDWORD `
"HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" `
"PowerThrottlingOff" `
1

Write-OK "Power Throttling desactivado."


#==================================================
# DELIVERY OPTIMIZATION
#==================================================

Write-Section "DELIVERY OPTIMIZATION"

Set-RegDWORD `
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" `
"DODownloadMode" `
0

Write-OK "Delivery Optimization optimizado."


#==================================================
# WINDOWS TIPS
#==================================================

Write-Section "WINDOWS TIPS"

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
"SoftLandingEnabled" `
0

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
"SubscribedContent-338393Enabled" `
0

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
"SubscribedContent-310093Enabled" `
0

Write-OK "Sugerencias eliminadas."


#==================================================
# NOTIFICACIONES
#==================================================

Write-Section "NOTIFICACIONES"

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" `
"ToastEnabled" `
0

Write-OK "Notificaciones desactivadas."


#==================================================
# MOUSE
#==================================================

Write-Section "MOUSE"

Set-RegString `
"HKCU:\Control Panel\Mouse" `
"MouseHoverTime" `
"10"

Set-RegString `
"HKCU:\Control Panel\Desktop" `
"ForegroundLockTimeout" `
"0"

Write-OK "Mouse optimizado."


#==================================================
# LOCK SCREEN
#==================================================

Write-Section "LOCK SCREEN"

Set-RegDWORD `
"HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" `
"NoLockScreen" `
1

Write-OK "LockScreen deshabilitado."

#==================================================
# HAGS (Hardware-Accelerated GPU Scheduling)
#==================================================

Write-Section "GPU HAGS"

# 2 = Activado, 1 = Desactivado
Set-RegDWORD `
"HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" `
"HwSchMode" `
2

Write-OK "HAGS activado (requiere reiniciar el equipo)."

#==================================================
# DESACTIVAR MPO (Fix Stuttering & FPS Drops)
#==================================================

Write-Section "DISABLE MPO"

Set-RegDWORD `
"HKLM:\SOFTWARE\Microsoft\Windows\Dwm" `
"OverlayTestMode" `
5

Write-OK "Multi-Plane Overlay (MPO) desactivado."

Write-Host ""
Write-Host "Registro Parte 2 finalizado." -ForegroundColor Green