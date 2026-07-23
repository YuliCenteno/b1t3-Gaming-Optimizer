# ============================================================
# b1t3 Gaming Optimizer
# Module : 13-Debloat.ps1
# Author : Juliano Andres Centeno (b1t3)
# ============================================================

. "$PSScriptRoot\..\Lib\Utils.ps1"

Write-Section "ELIMINACION DE BLOATWARE (ESTILO CHRIS TITUS)"

# Lista de paquetes bloatware habituales
$BloatApps = @(
    "Microsoft.3DBuilder",
    "Microsoft.BingNews",
    "Microsoft.BingWeather",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.People",
    "Microsoft.SkypeApp",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxApp",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.5499813F4A010" # Cortana
)

foreach ($App in $BloatApps) {
    try {
        # Remover del usuario actual y futuros
        Get-AppxPackage -Name $App -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq $App | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        Write-OK "Bloatware eliminado: $App"
    } catch {
        Write-Warn "No se pudo remover: $App"
    }
}

Write-OK "Debloat estilo CTT finalizado."