# 🎮 b1t3 Gaming Optimizer

Suite modular de optimización de baja latencia y alto rendimiento para **Windows 10**, desarrollada sobre **PowerShell**. 

Esta herramienta automatiza la configuración del sistema operativo para reducir la latencia de entrada (input lag), mejorar la estabilidad de FPS y minimizar el uso de recursos en segundo plano sin instalar software intrusivo ni alterar políticas del sistema de forma irreversible.

> **Desarrollado por:** Juliano Andrés Centeno (b1t3)  
> **Arquitectura:** PowerShell Modular (HKCU & System Tweaks)

---

## ⚡ Características Principales

* **Reducción de Latencia**: Ajustes en el registro para minimizar el input lag de mouse y teclado.
* **Gestión de Procesos y RAM**: Desactivación de servicios pesados en segundo plano y optimización de memoria.
* **Optimización de Red**: Tweaks orientados a estabilizar la latencia (PING) en juegos en línea.
* **Desbloqueo de CPU**: Configuración de Unparking de núcleos para aprovechar el 100% del procesador.
* **Limpieza de Sistema (Debloat)**: Eliminación segura de archivos basura y componentes innecesarios de Windows.
* **Diseño Reversible**: Opciones integradas para crear puntos de restauración y revertir los cambios fácilmente.

---

## 📋 Requisitos del Sistema

* **Sistema Operativo**: Windows 10 (64-bit).
* **Entorno**: Windows PowerShell 5.1 o superior.
* **Permisos**: Privilegios de **Administrador**.

---

## 🚀 Guía de Instalación y Uso

### 1. Obtener el Proyecto
Cloná el repositorio o descargá el proyecto comprimido en formato ZIP y extraelo en tu equipo:

git clone https://github.com/YuliCenteno/b1t3-Gaming-Optimizer.git

### 2. Abrir la Consola como Administrador
1. Presioná la tecla **Windows**.
2. Escribí **PowerShell**.
3. Hacé clic derecho sobre **Windows PowerShell** y seleccioná **Ejecutar como Administrador**.

### 3. Ejecutar el Script
Copiá y ejecutá los siguientes comandos en la consola para habilitar la ejecución de scripts e iniciar el menú interactivo:

# Permitir la ejecución de scripts en la sesión actual
Set-ExecutionPolicy -Scope Process Bypass -Force

# Navegar hasta la carpeta del proyecto (ejemplo: en el Escritorio)
cd "$HOME\Desktop\b1t3-Gaming-Optimizer-main"

# Iniciar la suite
.\GamingOptimizer.ps1

---

## 🖥️ Uso del Menú Interactivo

Al iniciar la herramienta, verás la consola con las especificaciones de tu hardware y un menú de opciones:

1. **Punto de Restauración (Opción 5)**: Recomendado antes de aplicar cambios. Crea una copia de seguridad del estado actual del sistema.
2. **Optimización Completa (Opción 2)**: Ejecuta de forma secuencial todos los módulos para una configuración óptima automática.
3. **Módulos Individuales (Opción 3)**: Permite aplicar únicamente las optimizaciones que necesites de forma granular.

---

## 🧩 Estructura de Módulos

El proyecto está diseñado bajo una arquitectura modular en la carpeta Modules/, facilitando su mantenimiento e inspección:

| Módulo | Área de Enfoque | Descripción |
| :--- | :--- | :--- |
| 01-System | Sistema | Detección e información de hardware (CPU, GPU, RAM, SSD). |
| 02-Services | Servicios | Desactivación de servicios no esenciales de Windows. |
| 03-ScheduledTasks | Tareas | Suspensión de tareas automáticas en segundo plano. |
| 04-Registry | Registro | Tweaks de latencia y prioridad en la pila de Windows. |
| 05-Network | Red | Ajustes del protocolo TCP/IP y adaptador para estabilizar el PING. |
| 06-Cleanup | Limpieza | Purga de archivos temporales y caché del sistema. |
| 07-Power | Energía | Activación de planes de rendimiento máximo de energía. |
| 08-Explorer | Interfaz | Optimización del Explorador de Windows para mayor respuesta. |
| 09-SSD | Almacenamiento | Configuración optimizada para unidades de estado sólido (SSD). |
| 10-Gaming | Gaming Base | Configuraciones generales de entorno de juego en Windows. |
| 11-InputLag | Periféricos | Optimización de la tasa de muestreo y respuesta de periféricos. |
| 12-AdvancedGaming | Rendimiento | Ajustes de renderizado y Timer Resolution del sistema. |
| 13-Debloat | Sistema Base | Eliminación de bloatware y aplicaciones nativas innecesarias. |
| 14-CPUCoreUnparking | Procesador | Mantiene todos los núcleos del procesador activos sin suspensión. |
| 15-WinSettings | Configuración | Ajustes visuales, privacidad y telemetría de Windows. |
| 16-RAMOptimization | Memoria | Gestión avanzada de memoria virtual y espacio de paginación. |

---

## 🛡️ Restauración de Cambios

Si deseás revertir las modificaciones y volver al estado previo, podés utilizar el script de restauración incluido:

.\Restore.ps1

Alternativamente, podés restaurar el sistema a partir del **Punto de Restauración** creado previamente desde la herramienta o el Panel de Control de Windows.

---

## 👨‍💻 Autor y Créditos

* **Desarrollador:** Juliano Andrés Centeno (b1t3)
* **GitHub:** https://github.com/Yulicenteno

---

## 📄 Licencia

Este proyecto está distribuido bajo la licencia **MIT**. Consultá el archivo LICENSE para obtener más información.