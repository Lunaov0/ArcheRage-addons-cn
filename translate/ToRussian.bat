@echo off
set LANG=ru

:START
echo Starting PowerShell script...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "translatetofilep2.ps1" -lang %LANG%
if %ERRORLEVEL% NEQ 0 (
    echo PowerShell script exited with an error. Restarting...
    timeout /t 1 > nul
    goto START
)
echo PowerShell script exited successfully.
pause