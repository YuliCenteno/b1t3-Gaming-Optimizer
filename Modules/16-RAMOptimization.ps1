# ============================================================
# b1t3 Gaming Optimizer
# Module : 17-RAMOptimization.ps1
# Author : Juliano Andres Centeno (b1t3)
# Description: Optimización avanzada de gestión de RAM y Kernel
# ============================================================

. "$PSScriptRoot\..\Lib\Utils.ps1"

Write-Section "OPTIMIZACION AVANZADA DE MEMORIA RAM"

#==================================================
# 1. GESTION DE MEMORIA DEL KERNEL (HKLM Memory Management)
#==================================================
Write-Section "GESTION DE MEMORIA DEL KERNEL"

$MemMgmtPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"

if (Test-Path $MemMgmtPath) {
    # Mantiene el kernel y drivers en RAM física (Evita pagar costo de latencia de disco)
    Set-RegDWORD $MemMgmtPath "DisablePagingExecutive" 1

    # Ajuste de comportamiento de la memoria caché del sistema
    Set-RegDWORD $MemMgmtPath "LargeSystemCache" 0 # 0 es ideal para gaming/workstations (da prioridad a las apps sobre la caché de archivos)

    # Desactivar la paginación excesiva de la memoria
    Set-RegDWORD $MemMgmtPath "ClearPageFileAtShutdown" 0

    Write-OK "Kernel de Windows forzado a permanecer en la RAM fisica."
}

#==================================================
# 2. DESHABILITAR COMPRESION DE MEMORIA (Ahorro de CPU y Latencia)
#==================================================
Write-Section "COMPRESION DE MEMORIA (MMAgent)"

try {
    # Desactiva la compresión de páginas en RAM para reducir latencia e hilos de CPU
    Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue
    Disable-MMAgent -PageCombining -ErrorAction SilentlyContinue
    Write-OK "Compresion de RAM y Combinacion de paginas desactivadas."
} catch {
    Write-Warn "No se pudo cambiar el estado de MMAgent."
}

#==================================================
# 3. OPTIMIZACION DE SERVICIO SYSMAIN (SUPERFETCH)
#==================================================
Write-Section "SERVICIO SYSMAIN / SUPERFETCH"

# Desactivar SysMain para evitar precargas continuas que llenan la RAM en segundo plano
try {
    Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue
    Write-OK "Servicio SysMain (Superfetch) desactivado para liberar memoria en espera."
} catch {
    Write-Warn "No se pudo detener el servicio SysMain."
}

# Ajustar Prefetcher solo a arranques de sistema (0 = Desactivado, 1 = Apps, 2 = Boot, 3 = Ambos)
Set-RegDWORD $MemMgmtPath "EnablePrefetcher" 2
Set-RegDWORD $MemMgmtPath "EnableSuperfetch" 0

Write-OK "Prefetcher configurado solo para inicio del sistema."

#==================================================
# 4. LIBERACION DE RECURSOS EN TRABAJO EN SEGUNDO PLANO
#==================================================
Write-Section "AJUSTES DE ARCHIVO DE PAGINACION Y PRIORIDAD"

# Prioridad de respuesta para aplicaciones en primer plano (Juegos)
$PriorityPath = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
if (Test-Path $PriorityPath) {
    Set-RegDWORD $PriorityPath "Win32PrioritySeparation" 38 # Valor HEX 0x26: Máxima prioridad al programa enfocado (juego)
    Write-OK "Prioridad de procesador y RAM optimizada para juegos en primer plano."
}

Write-OK "Optimizacion avanzada de RAM completada con exito."