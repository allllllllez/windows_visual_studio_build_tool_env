@if not defined _echo echo off
setlocal enabledelayedexpansion

call %*
if "%ERRORLEVEL%"=="3010" (
    powershell Remove-Item -Recurse -Force \"$env:APPDATA\..\Local\Temp\"
    powershell Remove-Item -Recurse -Force \"${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\"
    exit /b 0
) else (
    if not "%ERRORLEVEL%"=="0" (
        set ERR=%ERRORLEVEL%
        call C:\TEMP\collect.exe -zip:C:\vslogs.zip

        exit /b !ERR!
    )
    powershell Remove-Item -Recurse -Force \"$env:APPDATA\..\Local\Temp\"
    powershell Remove-Item -Recurse -Force \"${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\"
)
