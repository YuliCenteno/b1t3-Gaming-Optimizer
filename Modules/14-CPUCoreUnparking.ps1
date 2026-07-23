# ============================================================
# b1t3 Gaming Optimizer
# Module : 14-CPUCoreUnparking.ps1
# ============================================================

. "$PSScriptRoot\..\Lib\Utils.ps1"

Write-Section "CPU CORE UNPARKING"

# Establecer la reserva mínima de núcleos aparcados al 0% (todos los núcleos activos al 100%)
try {
    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100
    powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100
    powercfg -setactive SCHEME_CURRENT
    Write-OK "Todos los núcleos de la CPU desaparcados (100% de disponibilidad)."
} catch {
    Write-Warn "No se pudo ajustar el aparcamiento de núcleos."
}