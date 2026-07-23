# ============================================================
# b1t3 Gaming Optimizer v1.0
# Launcher Principal
# ============================================================

$ErrorActionPreference = "Stop"

try {

Clear-Host
$Host.UI.RawUI.WindowTitle = "Gaming Optimizer v1.0"

#==================================================
# Verificar Administrador
#==================================================

$Identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$Principal = New-Object Security.Principal.WindowsPrincipal($Identity)
$IsAdmin = $Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host ""
    Write-Host "Ejecuta b1t3 Gaming Optimizer como Administrador." -ForegroundColor Red
    Read-Host "Presione ENTER para salir"
    exit
}

#==================================================
# Variables de Rutas
#==================================================

if ($MyInvocation.MyCommand.Path) {
    $Root = Split-Path -Parent $MyInvocation.MyCommand.Path
}
elseif ($PSScriptRoot) {
    $Root = $PSScriptRoot
}
else {
    $Root = Get-Location
}

$ModulesFolder = Join-Path $Root "Modules"
$LibFolder     = Join-Path $Root "Lib"
$ConfigFolder  = Join-Path $Root "Config"

#==================================================
# Comprobaciones
#==================================================

if (!(Test-Path $ModulesFolder)) { throw "No existe la carpeta Modules." }
if (!(Test-Path $LibFolder))     { throw "No existe la carpeta Lib." }
if (!(Test-Path "$LibFolder\Utils.ps1")) { throw "No se encontro Utils.ps1" }

. "$LibFolder\Utils.ps1"

if (Test-Path "$ConfigFolder\Config.psd1") {
    $Config = Import-PowerShellDataFile "$ConfigFolder\Config.psd1"
}

#==================================================
# Detectar Hardware
#==================================================

$CPU = (Get-CimInstance Win32_Processor).Name.Trim()
$GPU = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name
$RAM = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
$OS  = (Get-CimInstance Win32_OperatingSystem).Caption

try {
    $Disk = Get-PhysicalDisk | Where-Object MediaType -eq "SSD"
    $SSD  = if ($Disk) { "SI" } else { "NO" }
} catch {
    $SSD = "Desconocido"
}

#==================================================
# Funcion de Deteccion de Modulos (Con Scope de Script)
#==================================================

function Update-ModuleList {
    $script:Modules = Get-ChildItem $ModulesFolder -Filter "*.ps1" -File | Sort-Object Name

    if ($script:Modules.Count -eq 0) {
        throw "No hay modulos en la carpeta Modules."
    }
}

# Carga inicial
Update-ModuleList

#==================================================
# Funciones
#==================================================

function ShowHeader {

    Clear-Host

    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "                 b1t3 Gaming Optimizer v1.0" -ForegroundColor Yellow
    Write-Host "           Developed by Juliano Andres Centeno (b1t3)" -ForegroundColor Gray
    Write-Host "        GitHub: https://github.com/Yulicenteno" -ForegroundColor DarkGray
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""

    # Hardware con etiquetas en Cyan y valores en White/Green
    Write-Host "  CPU      : " -NoNewline -ForegroundColor Cyan
    Write-Host $CPU -ForegroundColor White

    Write-Host "  GPU      : " -NoNewline -ForegroundColor Cyan
    Write-Host $GPU -ForegroundColor White

    Write-Host "  RAM      : " -NoNewline -ForegroundColor Cyan
    Write-Host ("{0} GB" -f $RAM) -ForegroundColor White

    Write-Host "  Windows  : " -NoNewline -ForegroundColor Cyan
    Write-Host $OS -ForegroundColor White

    Write-Host "  SSD      : " -NoNewline -ForegroundColor Cyan
    Write-Host $SSD -ForegroundColor Green

    Write-Host ""
    Write-Host "  Modulos detectados: " -NoNewline -ForegroundColor Gray
    Write-Host $script:Modules.Count -ForegroundColor Green

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""

}

function RunModule {

    param($Module)

    Write-Host ""
    Write-Host "Ejecutando $($Module.BaseName)..." -ForegroundColor Yellow
    Write-Host ""

    try {
        & $Module.FullName
        Write-Host ""
        Write-Host "Finalizado correctamente." -ForegroundColor Green
    }
    catch {
        Write-Host ""
        Write-Host $_.Exception.Message -ForegroundColor Red
    }

    Read-Host "ENTER para continuar"

}

function RunAll {

    $RunModules = $script:Modules | Where-Object { $_.Name -ne "01-System.ps1" }

    $Total   = $RunModules.Count
    $Current = 0

    foreach ($Module in $RunModules) {

        $Current++

        Write-Progress -Activity "Gaming Optimizer" `
                       -Status "Ejecutando $($Module.BaseName)" `
                       -PercentComplete (($Current / $Total) * 100)

        Write-Host ""
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host "Ejecutando: $($Module.BaseName)"
        Write-Host "==========================================" -ForegroundColor Cyan

        try {
            & $Module.FullName
            Write-Host "[OK] $($Module.BaseName)" -ForegroundColor Green
        }
        catch {
            Write-Host "[ERROR] $($Module.BaseName)" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Yellow
        }

    }

    Write-Progress -Activity "Gaming Optimizer" -Completed

    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host "Optimizacion completada." -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Green

    Read-Host "Presione ENTER para continuar"

}

function CreateRestorePoint {

    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "Creando Punto de Restauracion..." -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""

    try {
        Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue

        $RestoreKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore"
        if (Test-Path $RestoreKey) {
            Set-ItemProperty -Path $RestoreKey -Name "SystemRestorePointCreationFrequency" -Value 0 -Type DWORD -Force -ErrorAction SilentlyContinue
        }

        $TimeStamp = Get-Date -Format "dd/MM/yyyy HH:mm"
        $RestoreName = "b1t3 Gaming Optimizer - Backup ($TimeStamp)"

        Checkpoint-Computer -Description $RestoreName -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop

        Write-Host ""
        Write-Host "Punto de restauracion creado correctamente:" -ForegroundColor Green
        Write-Host $RestoreName -ForegroundColor Yellow
    }
    catch {
        Write-Host ""
        Write-Host "No se pudo crear el punto de restauracion." -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Yellow
    }

    Write-Host ""
    Read-Host "Presione ENTER para continuar"

}

function Show-B1t3About {

    Clear-Host
    Write-Host "==================================================" -ForegroundColor DarkCyan
    Write-Host "               ACERCA DE / CREDITOS               " -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor DarkCyan
    Write-Host ""
    Write-Host "   b1t3 GAMING OPTIMIZER TWEAKS                  " -ForegroundColor Yellow
    Write-Host ""
    Write-Host "--------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  * Desarrollador : Juliano Andres Centeno (b1t3)" -ForegroundColor White
    Write-Host "  * Version       : 1.0.0 (Modular Suite)" -ForegroundColor White
    Write-Host "  * Arquitectura  : PowerShell Modular (HKCU focus)" -ForegroundColor White
    Write-Host "--------------------------------------------------" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  [!] Descripcion:" -ForegroundColor Yellow
    Write-Host "      Suite modular de optimizacion de baja latencia," -ForegroundColor Gray
    Write-Host "      gestion de memoria RAM, red, compatibilidad FSO" -ForegroundColor Gray
    Write-Host "      y rendimiento de GPU sin politicas intrusivas." -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [!] Garantia:" -ForegroundColor Yellow
    Write-Host "      Modificaciones reversibles mediante Registro HKCU" -ForegroundColor Gray
    Write-Host "      y Puntos de Restauracion del Sistema." -ForegroundColor Gray
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor DarkCyan
    Write-Host ""
    Read-Host "Presiona Enter para volver al menu principal..."

}

#==================================================
# MENU
#==================================================

do {

    ShowHeader

    Write-Host "  1) Informacion del sistema" -ForegroundColor White
    Write-Host "  2) Optimizacion completa" -ForegroundColor Green
    Write-Host "  3) Ejecutar modulo individual" -ForegroundColor White
    Write-Host "  4) Actualizar lista de modulos" -ForegroundColor White
    Write-Host "  5) Crear punto de restauracion" -ForegroundColor Yellow
    Write-Host "  6) Acerca de / Creditos" -ForegroundColor Magenta
    Write-Host "  0) Salir" -ForegroundColor Red

    Write-Host ""
    Write-Host " [>] " -NoNewline -ForegroundColor Cyan
    $Choice = Read-Host "Seleccione una opcion"

    switch ($Choice) {

        "1" {
            $System = $script:Modules | Where-Object Name -eq "01-System.ps1"

            if ($System) {
                RunModule $System
            }
            else {
                Write-Host ""
                Write-Host "No existe 01-System.ps1" -ForegroundColor Yellow
                Read-Host "ENTER"
            }
        }

        "2" {
            RunAll
        }

        "3" {
            ShowHeader

            Write-Host "============== MODULOS =============="
            Write-Host ""

            # Filtramos para mostrar solo del 02 en adelante
            $List = $script:Modules | Where-Object { $_.Name -ne "01-System.ps1" }

            foreach ($Module in $List) {
                if ($Module.Name.Length -ge 2) {
                    $Prefix = $Module.Name.Substring(0, 2)
                    if ($Prefix -as [int]) {
                        Write-Host ("{0}) {1}" -f [int]$Prefix, $Module.BaseName)
                    }
                }
            }

            Write-Host ""

            $Sel = Read-Host "Numero del modulo"

            if ($Sel -as [int]) {
                $FormattedSel = "{0:D2}" -f [int]$Sel
                $TargetModule = $List | Where-Object { $_.Name.StartsWith($FormattedSel) }

                if ($TargetModule) {
                    RunModule $TargetModule
                } else {
                    Write-Host ""
                    Write-Host "Modulo no encontrado." -ForegroundColor Yellow
                    Start-Sleep 1
                }
            }
        }

        "4" {
            Update-ModuleList
            Write-Host ""
            Write-Host "Lista actualizada. ($($script:Modules.Count) modulos detectados)" -ForegroundColor Green
            Start-Sleep 1
        }

        "5" {
            CreateRestorePoint
        }

        "6" {
            Show-B1t3About
        }

        "0" {
            Write-Host ""
            Write-Host "Cerrando b1t3 Gaming Optimizer..." -ForegroundColor Yellow
            Start-Sleep 1
            $ExitProgram = $true
        }

        default {
            Write-Host ""
            Write-Host "Opcion invalida." -ForegroundColor Yellow
            Start-Sleep 1
        }

    }

    if ($ExitProgram) {
        break
    }

} while ($true)

}
catch {

    Clear-Host

    Write-Host ""
    Write-Host "===================================================" -ForegroundColor Red
    Write-Host "           ERROR AL INICIAR EL OPTIMIZADOR"
    Write-Host "===================================================" -ForegroundColor Red
    Write-Host ""

    Write-Host ("Mensaje : {0}" -f $_.Exception.Message) -ForegroundColor Yellow

    if ($_.InvocationInfo) {
        Write-Host ""
        Write-Host ("Archivo : {0}" -f $_.InvocationInfo.ScriptName)
        Write-Host ("Linea   : {0}" -f $_.InvocationInfo.ScriptLineNumber)
    }

    Write-Host ""
    Write-Host "Revise que existan las carpetas: Modules, Lib, Config"
    Write-Host ""

    Read-Host "Presione ENTER para salir"

}