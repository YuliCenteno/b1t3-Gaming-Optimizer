# ============================================================
# b1t3 Gaming Optimizer
#
# Module : 06-Cleanup.ps1
# Author : Juliano Andres Centeno (b1t3)
# GitHub : https://github.com/Yulicenteno
# License: MIT
#
# Copyright (c) 2026 Juliano Andres Centeno
# ============================================================

. "$PSScriptRoot\..\Lib\Utils.ps1"

Write-Section "SYSTEM CLEANUP"

$Global:RecoveredBytes = 0

function Clear-FolderContent {

    param([string]$Path)

    if (!(Test-Path $Path)) {
        Write-Warn "$Path no existe."
        return
    }

    Write-Host ""
    Write-Host "Limpiando: $Path"

    Get-ChildItem $Path -Force -ErrorAction SilentlyContinue | ForEach-Object {

        try{

            if($_.PSIsContainer){

                $Size = (Get-ChildItem $_.FullName -Recurse -Force -ErrorAction SilentlyContinue |
                        Measure-Object Length -Sum).Sum

                Remove-Item $_.FullName -Recurse -Force -ErrorAction Stop

            }else{

                $Size = $_.Length

                Remove-Item $_.FullName -Force -ErrorAction Stop

            }

            $Global:RecoveredBytes += $Size

        }
        catch{
            # Archivo en uso → ignorar
        }

    }

    Write-OK "Completado"

}

#==================================================
# TEMP Usuario
#==================================================

Write-Section "TEMP"

Clear-FolderContent $env:TEMP

#==================================================
# LOCALAPPDATA TEMP
#==================================================

Write-Section "LOCAL TEMP"

Clear-FolderContent "$env:LOCALAPPDATA\Temp"

#==================================================
# WINDOWS TEMP
#==================================================

Write-Section "WINDOWS TEMP"

Clear-FolderContent "$env:SystemRoot\Temp"

#==================================================
# DIRECTX SHADER CACHE
#==================================================

Write-Section "DIRECTX"

Clear-FolderContent "$env:LOCALAPPDATA\D3DSCache"

#==================================================
# NVIDIA SHADER CACHE
#==================================================

if(Test-Path "$env:LOCALAPPDATA\NVIDIA"){

    Write-Section "NVIDIA"

    Clear-FolderContent "$env:LOCALAPPDATA\NVIDIA\DXCache"
    Clear-FolderContent "$env:LOCALAPPDATA\NVIDIA\GLCache"

}

#==================================================
# MINIATURAS
#==================================================

Write-Section "THUMBNAILS"

Get-ChildItem `
"$env:LOCALAPPDATA\Microsoft\Windows\Explorer" `
-Filter "thumbcache*" `
-ErrorAction SilentlyContinue |
Remove-Item -Force -ErrorAction SilentlyContinue

Write-OK "Miniaturas"

#==================================================
# PAPELERA
#==================================================

Write-Section "RECYCLE BIN"

try{

    Clear-RecycleBin -Force -ErrorAction Stop

    Write-OK "Papelera vaciada"

}
catch{

    Write-Warn "No fue posible vaciar la papelera"

}

#==================================================
# DNS
#==================================================

Write-Section "DNS"

try{

    Clear-DnsClientCache

    Write-OK "Cache DNS"

}catch{}

#==================================================
# OPTIMIZACIÓN DE MEMORIA RAM
#==================================================

Write-Section "MEMORIA RAM"

try {
    # Liberar memoria de trabajo retenida por los procesos del sistema
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    # Reducir el Working Set de todos los procesos activos
    Get-Process | ForEach-Object {
        try {
            $_.EmptyWorkingSet()
        } catch {}
    }
    
    Write-OK "Memoria RAM liberada correctamente."
} catch {
    Write-Warn "No se pudo completar la limpieza de RAM."
}

#==================================================
# RESULTADO
#==================================================

$RecoveredMB = [math]::Round($Global:RecoveredBytes / 1MB,2)

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Limpieza finalizada"
Write-Host "Espacio recuperado: $RecoveredMB MB"
Write-Host "==========================================" -ForegroundColor Green