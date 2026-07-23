# ============================================================
# b1t3 Gaming Optimizer
# Module : 12-AdvancedGaming.ps1
# Author : Juliano Andres Centeno (b1t3)
# ============================================================

. "$PSScriptRoot\..\Lib\Utils.ps1"

Write-Section "ADVANCED FPS & LATENCY TWEAKS"

#==================================================
# 1. DESACTIVAR POWER THROTTLING GLOBAL
#==================================================

Write-Section "POWER THROTTLING"

Set-RegDWORD "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" "PowerThrottlingOff" 1

Write-OK "Power Throttling desactivado por completo."

#==================================================
# 2. PRIORIDAD MAXIMA EN GAMES TASK (MMCSS)
#==================================================

Write-Section "MMCSS GAMES PRIORITY"

$GameTask = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"

Set-RegDWORD $GameTask "GPU Priority" 8
Set-RegDWORD $GameTask "Priority" 6
Set-RegString $GameTask "Scheduling Category" "High"
Set-RegString $GameTask "SFIO Priority" "High"

Write-OK "Prioridad de GPU y Renderizado configurada en ALTA."

#==================================================
# 3. OPTIMIZACION DE TIMER RESOLUTION (Input Lag & Frametime)
#==================================================

Write-Section "TIMER RESOLUTION & HPET"

try {
    bcdedit /set disabledynamictick yes | Out-Null
    bcdedit /set useplatformclock no | Out-Null
    Write-OK "Dynamic Tick desactivado (Mejora en latencia y suavidad de FPS)."
} catch {
    Write-Warn "No se pudo modificar la configuracion de BCDEdit."
}

#==================================================
# PREFERENCIAS DE RENDIMIENTO DE GRAFICOS (GPU)
#==================================================
Write-Section "CONFIGURACION DE GPU PARA JUEGOS"

$GpuRegistryPath = "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences"

# Crear la clave de Registro si no existe
if (-not (Test-Path $GpuRegistryPath)) {
    New-Item -Path $GpuRegistryPath -Force | Out-Null
}

# Lista de rutas donde buscar juegos o ejecutables específicos
$GamesToHighPerf = @(
    # Counter-Strike 2
    "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\bin\win64\cs2.exe",
    # Dota 2
    "C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta\game\bin\win64\dota2.exe"
)

# 1. Escaneo dinámico de juegos instalados en Steam (Soporta múltiples discos/librerías)
$SteamAppsPath = "C:\Program Files (x86)\Steam\steamapps"
if (Test-Path $SteamAppsPath) {
    # Busca executables dentro de steamapps/common (limitado a subcarpetas principales para evitar falsos positivos)
    $SteamGames = Get-ChildItem -Path "$SteamAppsPath\common" -Recurse -Filter "*.exe" -Depth 4 -ErrorAction SilentlyContinue | 
        Where-Object { $_.FullName -notmatch "crash|reporter|unins|redist|setup" } | 
        Select-Object -ExpandProperty FullName
    
    $GamesToHighPerf += $SteamGames
}

# 2. Registrar cada ejecutable encontrado en el Registro de Windows
$AddedCount = 0
foreach ($ExePath in ($GamesToHighPerf | Select-Object -Unique)) {
    if (Test-Path $ExePath) {
        # 'GpuPreference=2;' indica Alto Rendimiento en Windows
        Set-ItemProperty -Path $GpuRegistryPath -Name $ExePath -Value "GpuPreference=2;" -ErrorAction SilentlyContinue
        $AddedCount++
    }
}

if ($AddedCount -gt 0) {
    Write-OK "Se configuraron $AddedCount juegos en modo Alto Rendimiento en la GPU."
} else {
    Write-Warn "No se encontraron ejecutables de juegos en las rutas predeterminadas."
}

#==================================================
# COMPATIBILIDAD Y RENDIMIENTO DE JUEGOS (CS2, Dota 2, etc.)
#==================================================
Write-Section "OPTIMIZACION DE COMPATIBILIDAD Y GPU PARA JUEGOS"

$GpuRegistryPath   = "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences"
$CompatRegistryPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"

# Crear claves de Registro si no existen
if (-not (Test-Path $GpuRegistryPath))    { New-Item -Path $GpuRegistryPath -Force | Out-Null }
if (-not (Test-Path $CompatRegistryPath)) { New-Item -Path $CompatRegistryPath -Force | Out-Null }

# Lista base de juegos competitivos críticos
$TargetGames = @(
    "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\bin\win64\cs2.exe",
    "C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta\game\bin\win64\dota2.exe"
)

# Escaneo dinámico en librería común de Steam
$SteamAppsPath = "C:\Program Files (x86)\Steam\steamapps\common"
if (Test-Path $SteamAppsPath) {
    $DetectedExes = Get-ChildItem -Path $SteamAppsPath -Recurse -Filter "*.exe" -Depth 4 -ErrorAction SilentlyContinue | 
        Where-Object { $_.FullName -notmatch "crash|reporter|unins|redist|setup|installer" } | 
        Select-Object -ExpandProperty FullName
    
    $TargetGames += $DetectedExes
}

# Filtrar duplicados
$TargetGames = $TargetGames | Select-Object -Unique

$AppliedCount = 0

foreach ($ExePath in $TargetGames) {
    if (Test-Path $ExePath) {
        # 1. Configurar Alto Rendimiento en GPU
        Set-ItemProperty -Path $GpuRegistryPath -Name $ExePath -Value "GpuPreference=2;" -ErrorAction SilentlyContinue
        
        # 2. Deshabilitar Optimizaciones de Pantalla Completa (~ DISABLEDXMAXIMIZEDWINDOWEDMODE)
        Set-ItemProperty -Path $CompatRegistryPath -Name $ExePath -Value "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" -ErrorAction SilentlyContinue
        
        $AppliedCount++
    }
}

if ($AppliedCount -gt 0) {
    Write-OK "Se aplico Alto Rendimiento + Deshabilitar optimizaciones de pantalla completa en $AppliedCount juegos."
} else {
    Write-Warn "No se encontraron ejecutables de juegos para optimizar."
}

#==================================================
# 4. DESACTIVAR MEMORY COMPRESSION
#==================================================

Write-Section "COMPRESION DE MEMORIA"

try {
    Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue
    Write-OK "Compresion de memoria desactivada (Reduce uso de CPU en juegos)."
} catch {
    Write-Warn "No se pudo deshabilitar la compresion de memoria."
}

Write-OK "Ajustes avanzados de FPS y latencia finalizados."