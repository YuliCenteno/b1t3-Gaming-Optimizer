# ============================================================
# b1t3 Gaming Optimizer
#
# Module : 09-SSD.ps1
# Author : Juliano Andres Centeno (b1t3)
# GitHub : https://github.com/Yulicenteno
# License: MIT
#
# Copyright (c) 2026 Juliano Andres Centeno
# ============================================================

. "$PSScriptRoot\..\Lib\Utils.ps1"

Write-Section "STORAGE OPTIMIZATION"

#==================================================
# Detectar discos
#==================================================

try{

    $Disks = Get-PhysicalDisk

}catch{

    Write-ErrorText "No fue posible obtener informacion de los discos."

    return

}

foreach($Disk in $Disks){

    Write-Host ""
    Write-Host "----------------------------------------" -ForegroundColor Cyan
    Write-Host "Disco     : $($Disk.FriendlyName)"
    Write-Host "Tipo      : $($Disk.MediaType)"
    Write-Host "Estado    : $($Disk.HealthStatus)"
    Write-Host "Tamaño    : $([math]::Round($Disk.Size/1GB)) GB"
    Write-Host "----------------------------------------" -ForegroundColor Cyan

}

#==================================================
# TRIM
#==================================================

Write-Section "TRIM"

try{

    $Trim = fsutil behavior query DisableDeleteNotify

    Write-Host $Trim

    if($Trim -match "= 0"){

        Write-OK "TRIM habilitado"

    }else{

        Write-Warn "TRIM deshabilitado"

    }

}catch{

    Write-Warn "No fue posible comprobar TRIM"

}

#==================================================
# Optimizar unidades
#==================================================

Write-Section "OPTIMIZE VOLUMES"

Get-Volume |
Where-Object DriveLetter |
ForEach-Object{

    try{

        Optimize-Volume `
            -DriveLetter $_.DriveLetter `
            -Analyze `
            -ErrorAction Stop

        Write-OK "Analizada unidad $($_.DriveLetter):"

        if((Get-Partition -DriveLetter $_.DriveLetter).Type -ne "Reserved"){

            Optimize-Volume `
                -DriveLetter $_.DriveLetter `
                -ReTrim `
                -ErrorAction SilentlyContinue

        }

    }catch{

        Write-Warn "No se pudo optimizar $($_.DriveLetter):"

    }

}

#==================================================
# SMART
#==================================================

Write-Section "SMART"

try{

    Get-PhysicalDisk |
    Select FriendlyName,
           MediaType,
           HealthStatus,
           OperationalStatus |
    Format-Table

}catch{

    Write-Warn "SMART no disponible"

}

#==================================================
# BitLocker
#==================================================

Write-Section "BITLOCKER"

try{

    Get-BitLockerVolume |
    Select MountPoint,
           ProtectionStatus |
    Format-Table

}catch{

    Write-Warn "BitLocker no disponible"

}

Write-Host ""
Write-Host "Optimizacion de almacenamiento finalizada." -ForegroundColor Green