@echo off
setlocal
set "CSC=%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if not exist "%CSC%" set "CSC=%WINDIR%\Microsoft.NET\Framework\v4.0.30319\csc.exe"
if not exist "%CSC%" (
    echo .NET Framework C# compiler was not found.
    pause
    exit /b 1
)

if not exist "%~dp0icon.png" (
    echo icon.png was not found.
    pause
    exit /b 1
)

if not exist "%~dp0icon.ico" (
    echo icon.ico was not found.
    pause
    exit /b 1
)

set "OUTPUT_DIR=%~dp0release12346"
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"
if errorlevel 1 (
    echo Could not create the release12346 folder.
    pause
    exit /b 1
)

"%CSC%" /nologo /codepage:65001 /target:winexe /out:"%OUTPUT_DIR%\MaruPilot.exe" /win32manifest:"%~dp0MaruPilot.manifest" /win32icon:"%~dp0icon.ico" /reference:System.dll /reference:System.Windows.Forms.dll /resource:"%~dp0MaruPilot.ps1",MaruPilot.ps1 /resource:"%~dp0icon.png",MaruPilot.icon.png "%~dp0MaruPilotLauncher.cs"
if errorlevel 1 (
    echo.
    echo Build failed.
    pause
    exit /b 1
)

echo Built "%OUTPUT_DIR%\MaruPilot.exe"
