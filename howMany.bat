@echo off
set batdir=%~dp0
pushd "%batdir%"
if exist "temp.tmp" del "temp.tmp"
for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set dt=%%a
set screeny=%dt:~0,8%-%dt:~8,6%
set "SORTED=%screeny%-ori.th"
setlocal enabledelayedexpansion
powershell -ExecutionPolicy Bypass -File "%batdir%ps.ps1" -progValue 0 -targetFolder "%batdir%screenshots" -csvPath "%cd%\temp.tmp"

sort "temp.tmp" >> "%SORTED%"

del "temp.tmp"


set "currentDate="
set /a count=0

for /f %%D in (%SORTED%) do (
    set "fileDate=%%D"
    if "!fileDate!"=="!currentDate!" (
        set /a count+=1
    ) else (
        if defined currentDate (
            echo !currentDate!:!count! >> %screeny%screeny.th
        )
        set "currentDate=!fileDate!"
        set count=1
    )
)


if defined currentDate (
    echo !currentDate!:!count! >> %screeny%screeny.th
)



if not exist history (
mkdir history
timeout 2 /nobreak > NUL
)
move "%screeny%screeny.th" "history\%screeny%screeny.th"
if exist *-ori.th del *-ori.th
if exist temp.tmp del temp.tmp
if exist *screeny.th del *screeny.th
exit