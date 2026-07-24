======================================================================
                     🎮 b1t3 Gaming Optimizer
======================================================================

Un programa sencillo para Windows 10 que prepara tu computadora 
para que los juegos vayan más fluidos, con menos tirones (lag/stuttering) 
y menor latencia.


======================================================================
✨ ¿QUÉ HACE ESTE PROGRAMA POR VOS?
======================================================================

- ⚡ Saca el lag: Optimiza tu conexión a internet para jugar con mejor PING.
- 🧹 Limpia la basura: Borra archivos temporales que ocupan espacio al pedo.
- 🚀 Libera memoria RAM: Desactiva servicios de Windows que no usás cuando jugás.
- 🔋 Máximo Rendimiento: Activa el plan de energía para que el procesador dé el 100%.
- 🛡️ Es seguro: Siempre podés volver todo a como estaba antes si no te convence.


======================================================================
📋 REQUISITOS (LO QUE NECESITÁS)
======================================================================

1. Tener Windows 10.
2. Tener permisos de Administrador en la PC.


======================================================================
🚀 PASO A PASO: CÓMO USARLO (EXPLICADO BIEN FÁCIL)
======================================================================

--- Paso 1: Descargar el programa ---
- Descargá el proyecto descompreso o en formato ZIP.
- Extraelo o ponelo en tu Escritorio.

--- Paso 2: Abrir PowerShell como Administrador ---
1. Tocá la tecla Windows en tu teclado.
2. Escribí la palabra: PowerShell
3. Hacé Clic Derecho sobre "Windows PowerShell" y elegí "Ejecutar como Administrador".
   (Te va a saltar un cartel pidiendo permiso, ponele que SÍ).

--- Paso 3: Encender el programa ---
Copiá y pegá estas líneas de texto en la ventana azul/negra que se te abrió 
y apretá ENTER en cada paso:

1) Desbloquear la ejecución de scripts en la sesión actual:
   Set-ExecutionPolicy -Scope Process Bypass -Force

2) Navegar a la carpeta (ejemplo si la dejaste en el Escritorio):
   cd "$HOME\Desktop\b1t3-Gaming-Optimizer-main"

3) Abrir el menú interactivo:
   .\GamingOptimizer.ps1


======================================================================
🎮 ¿CÓMO SE USA EL MENÚ?
======================================================================

Cuando abra el programa en la consola, vas a ver un menú interactivo:

1. Escribí "5" y apretá ENTER: 
   Esto crea un Punto de Restauración. Es como un "guardar partida" 
   de tu Windows por seguridad.

2. Escribí "2" y apretá ENTER: 
   Esto corre la Optimización Completa. El programa va a hacer 
   toda la magia solo.
======================================================================
                     🎮 b1t3 Gaming Optimizer v1.0
======================================================================

Suite modular de optimización de sistema para Windows 10.
Diseñada para mejorar el rendimiento en juegos, reducir el tiempo 
de respuesta (input lag) y mantener el sistema operativo fluido.

> Desarrollador : Juliano Andrés Centeno (b1t3)
> Proyecto     : https://github.com/Yulicenteno/GamingOptimizer

======================================================================
1. ¿QUÉ HACE ESTE PROGRAMA?
======================================================================

Esta herramienta realiza ajustes seguros en el sistema operativo para:

  • Reducir la latencia y la demora de respuesta en mouse y teclado.
  • Liberar memoria RAM y reducir la carga sobre el procesador.
  • Estabilizar la conexión a internet para evitar picos de PING.
  • Limpiar archivos temporales e innecesarios del disco.
  • Configurar el equipo para que entregue el máximo rendimiento.

Todas las modificaciones son reversibles y no dañan el sistema.

======================================================================
2. REQUISITOS DEL SISTEMA
======================================================================

  • Sistema Operativo : Windows 10 (64-bit)
  • Permisos          : Cuenta con privilegios de Administrador
  • Programa          : Windows PowerShell (incluido en Windows)

======================================================================
3. GUÍA DE USO PASO A PASO
======================================================================

Paso 1: Abrir la consola como Administrador
-------------------------------------------
1. Presione la tecla Windows en su teclado.
2. Escriba "PowerShell".
3. Haga clic derecho sobre "Windows PowerShell" y seleccione 
   "Ejecutar como administrador".

Paso 2: Iniciar la herramienta
------------------------------
Copie y pegue las siguientes líneas en la consola y presione ENTER:

  Set-ExecutionPolicy -Scope Process Bypass -Force

Luego, diríjase a la ubicación de la carpeta (ejemplo si está en el Escritorio):

  cd "$HOME\Desktop\GamingOptimizer"
  .\GamingOptimizer.ps1

Paso 3: Menú de opciones
------------------------
Una vez cargada la aplicación, se mostrará un menú interactivo:

  • Opción 5 : Crea un Punto de Restauración por seguridad (Recomendado).
  • Opción 2 : Ejecuta la optimización completa de forma automática.
  • Opción 3 : Permite seleccionar módulos específicos.

======================================================================
4. RESTAURACIÓN DE CAMBIOS
======================================================================

Si por cualquier motivo desea revertir los ajustes y regresar al estado 
original del sistema, ejecute el siguiente comando desde la consola 
en la carpeta del programa:

  .\Restore.ps1

También puede utilizar el Punto de Restauración de Windows creado 
previamente mediante la opción 5.

======================================================================
5. ESTRUCTURA DE MÓDULOS INCLUIDOS
======================================================================

  01-System          : Diagnóstico general del hardware instalado.
  02-Services        : Suspensión de servicios no esenciales de Windows.
  03-ScheduledTasks  : Desactivación de tareas en segundo plano.
  04-Registry        : Ajustes de latencia en el registro de Windows.
  05-Network         : Configuración del protocolo de red para juegos.
  06-Cleanup         : Purga de archivos basura y caché acumulada.
  07-Power           : Activación del plan de energía de alto rendimiento.
  08-Explorer        : Ajustes de fluidez para la interfaz gráfica.
  09-SSD             : Optimización de la unidad de estado sólido.
  10-Gaming          : Parámetros generales del entorno de juego.
  11-InputLag        : Optimización de la tasa de respuesta de periféricos.
  12-AdvancedGaming  : Sincronización del temporizador del sistema (Timer).
  13-Debloat         : Limpieza de aplicaciones nativas innecesarias.
  14-CPUCoreUnparking: Desbloqueo de núcleos del procesador al 100%.
  15-WinSettings     : Desactivación de telemetría y animaciones.
  16-RAMOptimization : Gestión eficiente del espacio de memoria RAM.

======================================================================
LICENCIA & CRÉDITOS
======================================================================

Desarrollado por Juliano Andrés Centeno (b1t3)
Repositorio oficial: https://github.com/Yulicenteno/GamingOptimizer

Este proyecto se distribuye bajo la licencia MIT.
======================================================================