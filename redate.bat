@echo off
setlocal EnableDelayedExpansion
title %~n0
set batdir=%~dp0
pushd "%batdir%"

for %%F in (%batdir%screenshots\*.jpg) do (
    set "filename=%%~nF"
    for /f "tokens=1,2 delims=_" %%A in ("!filename!") do (
        set "datePart=%%B"
    )

    rem Extract year, month, day, hour, minute, second from filename
    set "year=!datePart:~0,4!"
    set "month=!datePart:~4,2!"
    set "day=!datePart:~6,2!"
    set "hour=!datePart:~9,2!"
    set "minute=!datePart:~11,2!"
    set "second=!datePart:~13,2!"

    set "newDate=!year!-!month!-!day! !hour!:!minute!"
    set "comparenewDate=!year!-!month!-!day! !hour!"
    rem Get the current last modified date of the file using PowerShell
    for /f "tokens=*" %%T in ('powershell -Command "(Get-Item '%%F').LastWriteTime.ToString('yyyy-MM-dd HH')"') do (
        set "fileDate=%%T"
    )
    rem Check if file date and extracted date match
    if "!fileDate!" NEQ "!comparenewDate!" (
        echo Updating %%~nF
echo !filedate!
echo !comparenewdate!

        powershell -Command "(Get-Item '%%F').LastWriteTime = [datetime]'!newDate!'"
    ) else (
        rem echo Skipping %%~nF
    )
)

