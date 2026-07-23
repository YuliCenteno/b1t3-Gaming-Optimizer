# ============================================================
# b1t3 Gaming Optimizer
#
# Module : 02-Services.ps1
# Author : Juliano Andres Centeno (b1t3)
# GitHub : https://github.com/Yulicenteno
# License: MIT
#
# Copyright (c) 2026 Juliano Andres Centeno
# ============================================================

. "$PSScriptRoot\..\Lib\Utils.ps1"

Write-Section "INFORMACION DEL SISTEMA"

try {
    $CPU = Get-CimInstance Win32_Processor
    $OS = Get-CimInstance Win32_OperatingSystem
    $BIOS = Get-CimInstance Win32_BIOS
    $Board = Get-CimInstance Win32_BaseBoard
    $RAMModules = Get-CimInstance Win32_PhysicalMemory
    $GPU = Get-CimInstance Win32_VideoController | Select-Object -First 1
    try{
    $Disks = Get-PhysicalDisk -ErrorAction Stop
}
catch{
    $Disks = @()
}
}
catch {
    Write-ErrorText "No fue posible obtener la informacion del sistema."
    return
}

#==================================================
# Sistema Operativo
#==================================================

Write-Section "WINDOWS"

Write-Host ("Nombre       : {0}" -f $OS.Caption)
Write-Host ("Version      : {0}" -f $OS.Version)
Write-Host ("Build        : {0}" -f $OS.BuildNumber)
Write-Host ("Arquitectura : {0}" -f $OS.OSArchitecture)

#==================================================
# Procesador
#==================================================

Write-Section "CPU"

Write-Host ("Modelo       : {0}" -f $CPU.Name.Trim())
Write-Host ("Nucleos      : {0}" -f $CPU.NumberOfCores)
Write-Host ("Hilos        : {0}" -f $CPU.NumberOfLogicalProcessors)
Write-Host ("Frecuencia   : {0} MHz" -f $CPU.MaxClockSpeed)

#==================================================
# Memoria RAM
#==================================================

Write-Section "MEMORIA"

$TotalRAM = [math]::Round(($RAMModules | Measure-Object Capacity -Sum).Sum / 1GB,2)

Write-Host ("Total        : {0} GB" -f $TotalRAM)
Write-Host ("Modulos      : {0}" -f $RAMModules.Count)

foreach($Module in $RAMModules){

    $Size = [math]::Round($Module.Capacity / 1GB)

    Write-Host (" - {0} GB | {1} MHz | {2}" -f $Size, $Module.Speed, $Module.Manufacturer)

}

#==================================================
# GPU
#==================================================

Write-Section "GPU"

Write-Host ("Modelo       : {0}" -f $GPU.Name)
Write-Host ("Driver       : {0}" -f $GPU.DriverVersion)

#==================================================
# Almacenamiento
#==================================================

Write-Section "ALMACENAMIENTO"

if($Disks){

    foreach($Disk in $Disks){

        Write-Host ""
        Write-Host ("Disco        : {0}" -f $Disk.FriendlyName)
        Write-Host ("Tipo         : {0}" -f $Disk.MediaType)
        Write-Host ("Estado       : {0}" -f $Disk.HealthStatus)
        Write-Host ("Tamaño       : {0} GB" -f ([math]::Round($Disk.Size/1GB)))

    }

}else{

    Write-Warn "No fue posible obtener informacion de los discos."

}

#==================================================
# Placa Base
#==================================================

Write-Section "PLACA BASE"

Write-Host ("Fabricante   : {0}" -f $Board.Manufacturer)
Write-Host ("Modelo       : {0}" -f $Board.Product)

#==================================================
# BIOS
#==================================================

Write-Section "BIOS"

Write-Host ("Fabricante   : {0}" -f $BIOS.Manufacturer)
Write-Host ("Version      : {0}" -f $BIOS.SMBIOSBIOSVersion)

try{

    $Fecha = $BIOS.ReleaseDate

    if($Fecha.Length -ge 8){

        $Fecha = $Fecha.Substring(0,8)

        $Fecha = [datetime]::ParseExact($Fecha,"yyyyMMdd",$null)

        Write-Host ("Fecha        : {0}" -f $Fecha.ToShortDateString())

    }
    else{

        Write-Host ("Fecha        : {0}" -f $BIOS.ReleaseDate)

    }

}
catch{

    Write-Host ("Fecha        : {0}" -f $BIOS.ReleaseDate)

}

#==================================================
# Uptime
#==================================================

Write-Section "UPTIME"

$Boot = $OS.LastBootUpTime
$Uptime = (Get-Date) - $Boot

Write-Host ("DDias         : {0}" -f $Uptime.Days)
Write-Host ("Horas        : {0}" -f $Uptime.Hours)
Write-Host ("Minutos      : {0}" -f $Uptime.Minutes)

#==================================================
# Estado general
#==================================================

Write-Section "RESUMEN"

Write-OK "Sistema analizado correctamente."

Write-Host ""
Write-Host "Equipo listo para aplicar optimizaciones." -ForegroundColor Green

Read-Host "Presione ENTER para continuar"