@echo off
setlocal
if not exist "%~dp0realese\MaruPilot.exe" (
    echo MaruPilot.exe was not found. Run Build-MaruPilot.bat first.
    pause
    exit /b 1
)
start "" "%~dp0realese\MaruPilot.exe"
