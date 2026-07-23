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

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "      OPTIMIZANDO SERVICIOS"
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

$Root = Split-Path (Split-Path $PSScriptRoot -Parent)

$BackupFolder = Join-Path $Root "Backup"

if (!(Test-Path $BackupFolder)) {
    New-Item -ItemType Directory $BackupFolder | Out-Null
}

$BackupFile = Join-Path $BackupFolder "ServicesBackup.csv"

#-------------------------------------------------------------
# Servicios considerados seguros para un PC Gaming
#-------------------------------------------------------------

$Services = @(

"DiagTrack",
"dmwappushservice",
"MapsBroker",
"WerSvc",
"SysMain",
"WSearch",
"Fax",
"PrintNotify",
"RemoteRegistry",
"RetailDemo",
"XblAuthManager",
"XblGameSave",
"XboxNetApiSvc"

)

#-------------------------------------------------------------
# Guardar configuración actual
#-------------------------------------------------------------

$Backup = @()

foreach($ServiceName in $Services){

    $svc = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    if($svc){

        $cim = Get-CimInstance Win32_Service `
        -Filter "Name='$ServiceName'"

        $Backup += [PSCustomObject]@{

            Name=$ServiceName
            StartMode=$cim.StartMode
            Status=$svc.Status

        }

    }

}

$Backup | Export-Csv $BackupFile -NoTypeInformation

Write-Host "Backup guardado." -ForegroundColor Green

Write-Host ""

#-------------------------------------------------------------
# Función
#-------------------------------------------------------------

function Disable-ServiceSafe{

param($Name)

$svc = Get-Service $Name -ErrorAction SilentlyContinue

if(!$svc){

    Write-Host "$Name no existe."
    return

}

try{

    if($svc.Status -eq "Running"){

        Stop-Service $Name -Force -ErrorAction SilentlyContinue

    }

}catch{}

try{

    Set-Service $Name -StartupType Disabled

    Write-Host ("[OK] " + $Name)

}catch{

    Write-Host ("[ERROR] " + $Name)

}

}

#-------------------------------------------------------------
# Optimización
#-------------------------------------------------------------

foreach($svc in $Services){

    Disable-ServiceSafe $svc

}

Write-Host ""
Write-Host "Servicios optimizados." -ForegroundColor Green