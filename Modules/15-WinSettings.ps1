# ============================================================
# b1t3 Gaming Optimizer
# Module : 15-WinSettings.ps1
# Author : Juliano Andres Centeno (b1t3)
# Description: Ajustes de Windows, Interfaz y Privacidad (Sin bloqueo de organización)
# ============================================================

. "$PSScriptRoot\..\Lib\Utils.ps1"

Write-Section "CONFIGURACION DE WINDOWS, INTERFAZ Y PRIVACIDAD"

#==================================================
# 0. LIMPIEZA DE POLITICAS PREVIAS (Silenciosa)
#==================================================
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -ErrorAction SilentlyContinue

#==================================================
# 1. BARRA DE TAREAS Y BUSQUEDA
#==================================================
Write-Section "BARRA DE TAREAS Y BUSQUEDA"

# 1. Ocultar Búsqueda (0 = Oculto, 1 = Solo icono, 2 = Cuadro completo)
Set-RegDWORD "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "SearchboxTaskbarMode" 0

# 2. Desactivar Noticias e Intereses (Feeds) con verificación de ruta
$FeedsPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
if (-not (Test-Path $FeedsPath)) {
    New-Item -Path $FeedsPath -Force | Out-Null
}
New-ItemProperty -Path $FeedsPath -Name "ShellFeedsTaskbarViewMode" -Value 2 -PropertyType DWORD -Force -ErrorAction SilentlyContinue | Out-Null

Write-OK "Noticias y Busqueda ocultados."

#==================================================
# 2. SISTEMA (Notificaciones, Asistente, Modo Tableta, Multitarea)
#==================================================
Write-Section "SISTEMA Y NOTIFICACIONES"

# Desactivar Notificaciones del Sistema
Set-RegDWORD "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" "ToastEnabled" 0

# Asistente de concentración (Focus Assist: 0 = Off)
Set-RegDWORD "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" "NOC_GLOBAL_SETTING" 0

# Modo Tableta (Forzar modo escritorio y no cambiar automáticamente)
Set-RegString "HKCU:\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell" "TabletMode" "0"
Set-RegString "HKCU:\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell" "SignInMode" "1"

# Multitarea (Desactivar sugerencias en Alt+Tab y acople)
Set-RegDWORD "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" "AeroPeekEnabled" 0
Set-RegDWORD "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "SnapAssist" 0

Write-OK "Ajustes de Sistema, Notificaciones, Modo Tableta y Multitarea aplicados."

#==================================================
# 3. PERSONALIZACION (Efectos de Transparencia)
#==================================================
Write-Section "PERSONALIZACION"

Set-RegDWORD "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "EnableTransparency" 0
Write-OK "Efectos de transparencia desactivados."

#==================================================
# 4. JUEGOS (Xbox Game Bar & Game DVR)
#==================================================
Write-Section "XBOX GAME BAR"

Set-RegDWORD "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" "AppCaptureEnabled" 0
Set-RegDWORD "HKCU:\System\GameConfigStore" "GameDVR_Enabled" 0
Write-OK "Xbox Game Bar y grabación en segundo plano desactivados."

#==================================================
# 5. PRIVACIDAD Y PERMISOS DE APLICACIONES
#==================================================
Write-Section "PRIVACIDAD Y PERMISOS"

# Activación por voz
Set-RegDWORD "HKCU:\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceLocation" "AgentActivationOn" 0

# Acceso a Notificaciones por apps
Set-RegString "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotification" "Value" "Deny"

# Información de la cuenta
Set-RegString "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" "Value" "Deny"

# Llamadas telefónicas
Set-RegString "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" "Value" "Deny"

# Señales de Radio (Bluetooth / Radios)
Set-RegString "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" "Value" "Deny"

Write-OK "Permisos de privacidad (Voz, Notificaciones, Cuenta, Llamadas, Radios) denegados."
Write-OK "Todos los ajustes aplicados sin bloquear el menú de configuración."