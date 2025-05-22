@echo off
:start:
setlocal EnableDelayedExpansion
title %~n0
set batdir=%~dp0
pushd "%batdir%"
set /a "screenysize=0"
set cooloff=no
echo Sorting compress value...
attrib -h del.th
echo deltxt:4 >del.th
attrib +h del.th
set /a compressedsomething=0
if not exist compressed mkdir compressed

echo Checking if to show or hide...
for /f "tokens=2 delims=:" %%a in ('findstr "showhidecom:" "config.cfg"') do set showhidecom=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compresscooloff:" "config.cfg"') do set /a compresscooloff=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compressmultithread:" "config.cfg"') do set /a compressmultithread=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compresssizetrigger:" "config.cfg"') do set /a compresssizetrigger=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compressquality:" "config.cfg"') do set /a compressquality=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compressfilesizemin:" "config.cfg"') do set /a compressfilesizemin=%%a
set /a compressfilesizemin=%compressfilesizemin%*1000
for /f "tokens=2 delims=:" %%a in ('findstr "compsd:" "config.cfg"') do set /a cpulim=%%a
if exist cput.txt (
set /p cput=<cput.txt
timeout 2 /nobreak > NUL
) else (
set /a cput=500
echo 500 > cput.txt
timeout 2 /nobreak > NUL
)
set /a count=2000010000
set /a count2=0
set /a valcount=0
set /a count10=0

echo Enacting show or hide...
nircmd.exe win %showhidecom% ititle %~n0

echo Finding oldest screenshot...

for /f "delims=_" %%A in ('dir /b /a-d "%batdir%screenshots\*_*.*"') do (
    set "currentSN=%%A"
    if not defined count (
        set /a "count=!currentSN!"
    ) else (
        if !currentSN! LSS !count! set /a "count=!currentSN!"
    )
)

rem for /f "delims=_" %%a in ('dir /b /a-d /o:-d "%batdir%screenshots\*_*.*"') do set "count=%%a"

echo Size of screenshots folder...

echo Launching cpuload checker...
start "" /B cpuload.bat

echo Initiating compression of screenshots...
if exist %batdir%compressed\* (
powershell -ExecutionPolicy Bypass -File "%batdir%settimestamps.ps1" -Folder "%batdir%compressed"
timeout 1 /nobreak > NUL
move "%batdir%compressed\*.*" "%batdir%screenshots\" > NUL
timeout 1 /nobreak > NUL
)


:loopt:
for /f "tokens=2 delims=:" %%a in ('findstr "compresscooloff:" "config.cfg"') do set /a compresscooloff=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compressmultithread:" "config.cfg"') do set /a compressmultithread=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compresssizetrigger:" "config.cfg"') do set /a compresssizetrigger=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compressquality:" "config.cfg"') do set /a compressquality=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compsd:" "config.cfg"') do set /a cpulim=%%a
rem set /p compsd=<cput.txt
for /f "tokens=2 delims=:" %%a in ('findstr "showhidecom:" "config.cfg"') do set showhidecom=%%a
nircmd.exe win %showhidecom% ititle %~n0


set /a count2=0
echo Compress trigger: %compressfilesizemin%

set /a sizeMBA=0
set /a sizeMBB=0
set /a sizeMB=0
for /f %%A in ('powershell -command "(Get-ChildItem -Path 'screenshots' -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB"') do set /a sizeMBA=%%A
rem for /f %%A in ('powershell -command "(Get-ChildItem -Path 'compressed' -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB"') do set /a sizeMBB=%%A
set /a sizeMB=%sizeMBA%+%sizeMBB%
echo Size of folder: %sizeMB%

echo %sizeMB% GTR %compresssizetrigger%
if %sizeMB% GTR %compresssizetrigger% (
echo compressfilesizemin: %compressfilesizemin%


if %compresscooloff% GTR 0 timeout %compresscooloff% >nul
goto loopq
)
echo Done Compressing!
:cannotcompress:
:nevercompressed:
if exist %batdir%compressed\* (
powershell -ExecutionPolicy Bypass -File "%batdir%settimestamps.ps1" -Folder "%batdir%compressed"
timeout 3 /nobreak > NUL
move "%batdir%compressed\*.*" "%batdir%screenshots\" > NUL
timeout 3 /nobreak > NUL
)
attrib -h del.th
timeout 1 /nobreak > NUL
echo deltxt:5 >del.th
timeout 1 /nobreak > NUL
attrib +h del.th
timeout 1 /nobreak > NUL
rmdir compressed
exit


:loopq:
rem set compressedsomething=1
if exist 1 (
set /a count=1
del 1
)
set cooloff=yes
set count7=0

if not exist %batdir%screenshots\%count%_*.* goto notexist

for %%F in ("%batdir%screenshots\%count%_*.*") do (
set /a "screenysize=%%~zF"



if %%~zF GTR %compressfilesizemin% (
start "" /B "%batdir%convert" "%%F" -quality %compressquality% -strip -sharpen 0x0.5 -noise 1 "%batdir%compressed\%%~nxF"

)

)

if %cpulim% LSS 100 (
set /p compsd= < cput.txt
) else (
set /a compsd=0
)


if %screenysize% GTR %compressfilesizemin% (
set /a count2+=1
if %compsd% GTR 0 nircmd.exe wait %compsd%
if %count10% GTR 0 set /a count10-=1
) else (
set /a count10+=1
if %count10% GEQ %compressmultithread% set /a count2-=1
if %count10% GEQ %compressmultithread% set count10=0
if %count2% LSS 1 set /a count2=0

echo %count% %count2%/%compressmultithread% %count10% %compsd%
)
if %valcount% == 2 set /a count-=1000
if %valcount% == 3 set /a count-=10000
if %valcount% == 4 set /a count-=100000
if %valcount% == 5 set /a count-=10000000
set /a valcount=0

set /a count3=0

goto skipnoexist
:notexist:
echo %count% Does not exist
:skipnoexist:

if %count3% LEQ 10000 (
set /a count+=1
set /a count3+=1
set /a valcount=1
) else (
if %count3% LEQ 100000 (
set /a count+=100
set /a count3+=100
set /a valcount=2
) else (
if %count3% LEQ 1000000 (
set /a count+=1000
set /a count3+=1000
set /a valcount=3
) else (
if %count3% LEQ 10000000 (
set /a count+=10000
set /a count3+=10000
set /a valcount=4
) else (
set /a count+=1000000
set /a count3+=1000000
set /a valcount=5
)
)
)
)
if %count% GEQ 2001000000 (
echo Cannot compress further!
echo Lowering compressfilesizemin value by 20^%! 
set /a cfsmm=%compressfilesizemin%/5
echo %cfsmm%
echo %compressflesizemin%
set /a compressfilesizemin-=%cfsmm%
set /a count=0
set /a count2=2001000000
set /a count3=0
)
if %screenysize% GTR %compressfilesizemin% (
echo %count% %count2%/%compressmultithread% %count10% %compsd%
set /a count3=0
)





if %count2% GEQ %compressmultithread% goto loopt


goto loopq
goto loopq
goto loopq
goto loopq
goto loopq
goto loopq


rem if %%~zF GTR %compressfilesizemin% for /f "tokens=*" %%T in ('powershell -command "(Get-Item '%%F').LastWriteTime | ForEach-Object { $_.ToString('yyyy-MM-dd HH:mm:ss') }"') do (
rem set "timestamp=%%T"
rem )

rem if %%~zF GTR %compressfilesizemin% echo Compressing %%~nxF!
rem if %%~zF GTR %compressfilesizemin% powershell -command "(Get-Item '%%F').LastWriteTime = [datetime]'!timestamp!'"


if %count7% GEQ 10000 goto loopt
if %count2% GEQ %compressmultithread% (
set /a count7+=1
echo %count7%
goto checkrename
) 


:checkrename:

for %%F in ("%batdir%screenshots\resized-*.*") do (
set "oldname=%%~nxF"
set "newname=!oldname:resized-=!"
for /f "tokens=*" %%T in ('powershell -command "(Get-Item '%%F').LastWriteTime | ForEach-Object { $_.ToString('yyyy-MM-dd HH:mm:ss') }"') do (
set "timestamp=%%T"
)
del "%batdir%screenshots\!newname!"
rename "%%F" "!newname!"

powershell -command "(Get-Item '%batdir%screenshots\!newname!').LastWriteTime = [datetime]'!timestamp!'"

echo Renamed !newname!
)




echo Sorting date values!

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

    set "newDate=!year!-!month!-!day! !hour!:!minute!:!second!"

    rem Get the current last modified date of the file using PowerShell
    for /f "tokens=*" %%T in ('powershell -Command "(Get-Item '%%F').LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')"') do (
        set "fileDate=%%T"
    )

    rem Check if file date and extracted date match
    if "!fileDate!" NEQ "!newDate!" (
        echo Updating %%~nF
        powershell -Command "(Get-Item '%%F').LastWriteTime = [datetime]'!newDate!'"
    ) else (
        echo Skipping %%~nF
    )
)

