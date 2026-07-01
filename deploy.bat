@echo off
REM Ejecuta el script de despliegue Legalize y abre el dashboard automáticamente.
set SCRIPT_DIR=%~dp0scripts
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%desplegar_legalize.ps1"

