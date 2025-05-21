@echo off
setlocal EnableDelayedExpansion
title %~n0
set batdir=%~dp0
pushd "%batdir%"
:loop:
for /f %%A in ('powershell -command "(Get-ChildItem -Path 'screenshots' -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB"') do set sizeMB=%%A
echo %sizeMB%
if %sizeMB% GEQ 50000 echo hi
goto loop
for /f "delims=_" %%a in ('dir /b /a-d /o:-d "%batdir%screenshots\*_*.*"') do set "count=%%a"
echo %count%
set "lowestSN="

for /f "delims=_" %%A in ('dir /b /a-d "%batdir%screenshots\*_*.*"') do (
    set "currentSN=%%A"

    if not defined lowestSN (
        set "lowestSN=!currentSN!"
    ) else (
        if !currentSN! LSS !lowestSN! set "lowestSN=!currentSN!"
    )
)

echo Lowest SN: %lowestSN%
pause


