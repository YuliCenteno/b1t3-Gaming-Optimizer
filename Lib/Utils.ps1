# ============================================================
# Utils.ps1
# Gaming Optimizer
# Librería de funciones comunes
# ============================================================

# Colores
$Global:ColorOK   = "Green"
$Global:ColorWarn = "Yellow"
$Global:ColorErr  = "Red"
$Global:ColorInfo = "Cyan"

#==================================================
# Mensajes
#==================================================

function Write-Section {

    param([string]$Text)

    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host " $Text" -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan

}

function Write-OK {

    param([string]$Text)

    Write-Host "[ OK ] $Text" -ForegroundColor Green

}

function Write-Warn {

    param([string]$Text)

    Write-Host "[WARN] $Text" -ForegroundColor Yellow

}

function Write-ErrorText {

    param([string]$Text)

    Write-Host "[FAIL] $Text" -ForegroundColor Red

}

#==================================================
# Registro
#==================================================

function Ensure-RegKey {

    param([string]$Path)

    if(!(Test-Path $Path)){

        New-Item $Path -Force | Out-Null

    }

}

function Set-RegDWORD {

    param(

        [string]$Path,

        [string]$Name,

        [int]$Value

    )

    Ensure-RegKey $Path

    New-ItemProperty `
        -Path $Path `
        -Name $Name `
        -PropertyType DWord `
        -Value $Value `
        -Force | Out-Null

    Write-OK "$Name = $Value"

}

function Set-RegString {

    param(

        [string]$Path,

        [string]$Name,

        [string]$Value

    )

    Ensure-RegKey $Path

    New-ItemProperty `
        -Path $Path `
        -Name $Name `
        -PropertyType String `
        -Value $Value `
        -Force | Out-Null

    Write-OK "$Name = $Value"

}

#==================================================
# Backup Registro
#==================================================

function Backup-Registry {

    param(

        [string]$Key,

        [string]$FileName

    )

    $BackupFolder = Join-Path $PSScriptRoot "..\Backup"

    if(!(Test-Path $BackupFolder)){

        New-Item $BackupFolder `
        -ItemType Directory | Out-Null

    }

    reg export `
    $Key `
    "$BackupFolder\$FileName.reg" `
    /y | Out-Null

}

#==================================================
# Servicios
#==================================================

function Disable-ServiceSafe {

    param([string]$Name)

    try{

        $Service = Get-Service $Name -ErrorAction Stop

        if($Service.Status -eq "Running"){

            Stop-Service $Name -Force

        }

        Set-Service `
        $Name `
        -StartupType Disabled

        Write-OK $Name

    }
    catch{

        Write-Warn "$Name no encontrado."

    }

}

function Enable-ServiceSafe {

    param([string]$Name)

    try{

        Set-Service `
        $Name `
        -StartupType Automatic

        Start-Service `
        $Name `
        -ErrorAction SilentlyContinue

        Write-OK $Name

    }
    catch{

        Write-Warn "$Name no encontrado."

    }

}

#==================================================
# Carpetas
#==================================================

function Ensure-Folder {

    param([string]$Folder)

    if(!(Test-Path $Folder)){

        New-Item `
        $Folder `
        -ItemType Directory | Out-Null

    }

}

#==================================================
# Pausa
#==================================================

function Wait-Key {

    Write-Host ""
    Read-Host "Presione ENTER para continuar"

}

function About {

    Clear-Host

    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host "        b1t3 Gaming Optimizer v1.0"
    Write-Host "==============================================" -ForegroundColor Cyan

    Write-Host ""
    Write-Host "Autor:"
    Write-Host "Juliano Andres Centeno (b1t3)"
    Write-Host ""

    Write-Host "GitHub:"
    Write-Host "https://github.com/Yulicenteno"
    Write-Host ""

    Write-Host "Windows 10 Performance & Gaming Optimizer"

    Read-Host "Presione ENTER para volver"

}