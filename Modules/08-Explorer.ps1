# ============================================================
# b1t3 Gaming Optimizer
#
# Module : 08-Explorer.ps1
# Author : Juliano Andres Centeno (b1t3)
# GitHub : https://github.com/Yulicenteno
# License: MIT
#
# Copyright (c) 2026 Juliano Andres Centeno
# ============================================================

. "$PSScriptRoot\..\Lib\Utils.ps1"

Write-Section "WINDOWS EXPLORER"

#----------------------------------------------------------
# Abrir Este Equipo
#----------------------------------------------------------

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
"LaunchTo" `
1

Write-OK "Abrir Este Equipo"

#----------------------------------------------------------
# Mostrar extensiones
#----------------------------------------------------------

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
"HideFileExt" `
0

Write-OK "Mostrar extensiones"


#----------------------------------------------------------
# Quick Access
#----------------------------------------------------------

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" `
"ShowFrequent" `
0

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" `
"ShowRecent" `
0

Write-OK "Quick Access"

#----------------------------------------------------------
# Thumbnail Cache
#----------------------------------------------------------

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
"IconsOnly" `
0

Write-OK "Cache Miniaturas"

#----------------------------------------------------------
# Animaciones
#----------------------------------------------------------

Set-RegDWORD `
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" `
"VisualFXSetting" `
2

Write-OK "Visual FX"

#----------------------------------------------------------
# Reiniciar Explorer
#----------------------------------------------------------

Write-Section "REINICIANDO EXPLORER"

taskkill /F /IM explorer.exe | Out-Null
Start-Sleep -Seconds 2
Start-Process explorer.exe

Start-Process explorer.exe

Write-OK "Explorer reiniciado"

Write-Host ""

Write-Host "Explorer optimizado." -ForegroundColor Green