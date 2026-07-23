# ============================================================
# b1t3 Gaming Optimizer
#
# Module : 07-Power.ps1
# Author : Juliano Andres Centeno (b1t3)
# GitHub : https://github.com/Yulicenteno
# License: MIT
#
# Copyright (c) 2026 Juliano Andres Centeno
# ============================================================

. "$PSScriptRoot\..\Lib\Utils.ps1"

Write-Section "POWER OPTIMIZATION"

#----------------------------------------------------------
# Obtener plan actual
#----------------------------------------------------------

$currentScheme = (powercfg /GETACTIVESCHEME)

Write-Host ""
Write-Host $currentScheme

#----------------------------------------------------------
# Ultimate Performance
#----------------------------------------------------------

Write-Section "ULTIMATE PERFORMANCE"

$UltimateGUID = "e9a42b02-d5df-448d-aa00-03f14749eb61"

try{

    powercfg -duplicatescheme $UltimateGUID *> $null

}catch{}

try{

    powercfg /S $UltimateGUID

    Write-OK "Ultimate Performance activado"

}catch{

    Write-Warn "No fue posible activar Ultimate Performance"

}

#----------------------------------------------------------
# Desactivar hibernación
#----------------------------------------------------------

Write-Section "HIBERNATION"

try{

    powercfg -h off

    Write-OK "Hibernación desactivada"

}catch{

    Write-Warn "No fue posible modificar la hibernacion"

}

#----------------------------------------------------------
# Nunca apagar discos
#----------------------------------------------------------

Write-Section "DISK"

try{

    powercfg /change disk-timeout-ac 0
    powercfg /change disk-timeout-dc 0

    Write-OK "Discos configurados"

}catch{

    Write-Warn "No fue posible configurar discos"

}

#----------------------------------------------------------
# Nunca suspender
#----------------------------------------------------------

Write-Section "SLEEP"

try{

    powercfg /change standby-timeout-ac 0
    powercfg /change standby-timeout-dc 0

    Write-OK "Suspension desactivada"

}catch{

    Write-Warn "No fue posible modificar suspension"

}

#----------------------------------------------------------
# Monitor
#----------------------------------------------------------

Write-Section "DISPLAY"

try{

    powercfg /change monitor-timeout-ac 0

    Write-OK "Monitor configurado"

}catch{

    Write-Warn "No fue posible configurar monitor"

}

#----------------------------------------------------------
# Aplicar cambios
#----------------------------------------------------------

try{

    powercfg /SETACTIVE SCHEME_CURRENT

    Write-OK "Plan aplicado"

}catch{

    Write-Warn "No fue posible aplicar el plan"

}

Write-Host ""
Write-Host "Optimizacion de energia finalizada." -ForegroundColor Green