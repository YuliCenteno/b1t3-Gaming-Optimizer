# ============================================================
# b1t3 Gaming Optimizer
#
# Module : 05-Network.ps1
# Author : Juliano Andres Centeno (b1t3)
# GitHub : https://github.com/Yulicenteno
# License: MIT
#
# Copyright (c) 2026 Juliano Andres Centeno
# ============================================================

. "$PSScriptRoot\..\Lib\Utils.ps1"

Write-Section "NETWORK OPTIMIZATION"

# Obtener adaptadores físicos activos
$Adapters = Get-NetAdapter |
Where-Object {
    $_.Status -eq "Up" -and
    $_.HardwareInterface -eq $true
}

if(!$Adapters){
    Write-Warn "No se encontraron adaptadores activos."
    return
}

foreach($Adapter in $Adapters){

    Write-Host ""
    Write-Host "Adaptador: $($Adapter.Name)" -ForegroundColor Cyan

    # RSS
    try{
        Enable-NetAdapterRss -Name $Adapter.Name -ErrorAction Stop
        Write-OK "RSS habilitado"
    }catch{
        Write-Warn "RSS no soportado"
    }

    # RSC
    try{
        Disable-NetAdapterRsc -Name $Adapter.Name -ErrorAction Stop
        Write-OK "RSC deshabilitado"
    }catch{
        Write-Warn "RSC no soportado"
    }

    # Desactivar ahorro de energía del adaptador
    try{
        $nic = Get-CimInstance Win32_NetworkAdapter |
        Where-Object {$_.NetConnectionID -eq $Adapter.Name}

        if($nic){
            $reg = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}"
        }

        Write-OK "Configuracion del adaptador verificada"

    }catch{
        Write-Warn "No fue posible comprobar ahorro de energia"
    }

}

# DNS

try{
    Clear-DnsClientCache
    Write-OK "Cache DNS limpiada"
}catch{
    Write-Warn "No fue posible limpiar la cache DNS"
}

#==================================================
# NETWORK THROTTLING & MEMORY RESERVES
#==================================================

Write-Section "NETWORK THROTTLING"

Set-RegDWORD `
"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" `
"NetworkThrottlingIndex" `
0xffffffff

Set-RegDWORD `
"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" `
"SystemResponsiveness" `
0

Write-OK "Límite de tráfico de red desactivado."

#==================================================
# DESACTIVAR NAGLE'S ALGORITHM (Baja latencia TCP)
#==================================================

Write-Section "TCP / NAGLE ALGORITHM"

try {
    $Interfaces = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
    
    foreach ($Interface in $Interfaces) {
        $SubKey = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$($Interface.PSChildName)"
        
        Set-RegDWORD $SubKey "TcpAckFrequency" 1
        Set-RegDWORD $SubKey "TCPNoDelay" 1
        Set-RegDWORD $SubKey "TcpDelAckTicks" 0
    }
    Write-OK "Algoritmo de Nagle desactivado para todos los adaptadores."
} catch {
    Write-Warn "No se pudo ajustar el algoritmo de Nagle."
}

Write-Host ""
Write-Host "Optimizacion de red finalizada." -ForegroundColor Green