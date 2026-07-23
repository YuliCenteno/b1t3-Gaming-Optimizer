# ============================================================
# b1t3 Gaming Optimizer
#
# Module : 03-ScheduledTasks.ps1
# Author : Juliano Andres Centeno (b1t3)
# GitHub : https://github.com/Yulicenteno
# License: MIT
#
# Copyright (c) 2026 Juliano Andres Centeno
# ============================================================

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "     OPTIMIZANDO TAREAS PROGRAMADAS"
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

$Root = Split-Path (Split-Path $PSScriptRoot -Parent)

$BackupFolder = Join-Path $Root "Backup"

if(!(Test-Path $BackupFolder)){
    New-Item -ItemType Directory $BackupFolder | Out-Null
}

$BackupFile = Join-Path $BackupFolder "ScheduledTasksBackup.csv"

$TaskList = @()

function Disable-TaskSafe{

param($Path,$Name)

try{

    $Task = Get-ScheduledTask -TaskPath $Path -TaskName $Name -ErrorAction Stop

    $TaskList += [PSCustomObject]@{

        TaskPath=$Path
        TaskName=$Name
        State=$Task.State

    }

    Disable-ScheduledTask -TaskPath $Path -TaskName $Name -ErrorAction SilentlyContinue | Out-Null

    Write-Host "[OK] $Path$Name"

}catch{

    Write-Host "[NO EXISTE] $Path$Name"

}

}

# =====================================================
# Application Experience
# =====================================================

Disable-TaskSafe "\Microsoft\Windows\Application Experience\" "Microsoft Compatibility Appraiser"
Disable-TaskSafe "\Microsoft\Windows\Application Experience\" "ProgramDataUpdater"
Disable-TaskSafe "\Microsoft\Windows\Application Experience\" "StartupAppTask"

# =====================================================
# Customer Experience
# =====================================================

Disable-TaskSafe "\Microsoft\Windows\Customer Experience Improvement Program\" "Consolidator"
Disable-TaskSafe "\Microsoft\Windows\Customer Experience Improvement Program\" "UsbCeip"
Disable-TaskSafe "\Microsoft\Windows\Customer Experience Improvement Program\" "KernelCeipTask"

# =====================================================
# Autochk
# =====================================================

Disable-TaskSafe "\Microsoft\Windows\Autochk\" "Proxy"

# =====================================================
# DiskDiagnostic
# =====================================================

Disable-TaskSafe "\Microsoft\Windows\DiskDiagnostic\" "Microsoft-Windows-DiskDiagnosticDataCollector"

# =====================================================
# Maps
# =====================================================

Disable-TaskSafe "\Microsoft\Windows\Maps\" "MapsUpdateTask"
Disable-TaskSafe "\Microsoft\Windows\Maps\" "MapsToastTask"

# =====================================================
# Feedback
# =====================================================

Disable-TaskSafe "\Microsoft\Windows\Feedback\" "Siuf\DmClient"
Disable-TaskSafe "\Microsoft\Windows\Feedback\" "Siuf\DmClientOnScenarioDownload"

# =====================================================
# Power Efficiency
# =====================================================

Disable-TaskSafe "\Microsoft\Windows\Power Efficiency Diagnostics\" "AnalyzeSystem"

# =====================================================
# Retail Demo
# =====================================================

Disable-TaskSafe "\Microsoft\Windows\RetailDemo\" "CleanupOfflineContent"

# =====================================================
# Family Safety
# =====================================================

Disable-TaskSafe "\Microsoft\Windows\Shell\" "FamilySafetyMonitor"
Disable-TaskSafe "\Microsoft\Windows\Shell\" "FamilySafetyRefresh"

# =====================================================
# Windows Error Reporting
# =====================================================

Disable-TaskSafe "\Microsoft\Windows\Windows Error Reporting\" "QueueReporting"

# =====================================================
# NetTrace
# =====================================================

Disable-TaskSafe "\Microsoft\Windows\NetTrace\" "GatherNetworkInfo"

# =====================================================
# WinSAT
# =====================================================

Disable-TaskSafe "\Microsoft\Windows\Maintenance\" "WinSAT"

# =====================================================
# Office Telemetry (si existe)
# =====================================================

Disable-TaskSafe "\Microsoft\Office\" "OfficeTelemetryAgentLogOn"
Disable-TaskSafe "\Microsoft\Office\" "OfficeTelemetryAgentFallBack"
Disable-TaskSafe "\Microsoft\Office\" "Office 15 Subscription Heartbeat"

# =====================================================
# Backup
# =====================================================

$TaskList | Export-Csv $BackupFile -NoTypeInformation

Write-Host ""
Write-Host "Backup guardado:"
Write-Host $BackupFile -ForegroundColor Yellow

Write-Host ""
Write-Host "Tareas optimizadas correctamente." -ForegroundColor Green