@echo off
rem title %~n0
setlocal EnableDelayedExpansion
set batdir=%~dp0
pushd "%batdir%"
rem echo Sorting del value...
rem attrib -h del.th
rem echo deltxt:1 >del.th
rem attrib +h del.th

for /f "tokens=2 delims=:" %%a in ('findstr "maxagedfiles:" "config.cfg"') do set maxagedfiles=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "ran:" "config.cfg"') do set ran=%%a


echo Deleting screenshots older than %maxagedfiles% days...

forfiles /p "screenshots" /s /m *.* /d -%maxagedfiles% /c "cmd /c echo Deleting @file! && del @path"
cls
echo Done!
set /a delamt=%1
set /a delqty=%2




set /a count2=0
set /a targetscreenshot=0
set /a balance=1
set /a z=0
set /a twist=1

rem for /f "tokens=2 delims=:" %%a in ('findstr "deldurbef:" "config.cfg"') do set /a deldurbef=%%a
for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\screenshots" ^| find /v /c ""') do set files=%%i
echo Finding oldest screenshot...
for /f "delims=_" %%a in ('dir /b /a-d /o:-d "%batdir%screenshots\*_*.*"') do set "count=%%a"
echo Finding newest screenshot...
for /f "delims=_" %%a in ('dir /b /a-d /o:d "%batdir%screenshots\*_*.*"') do set "countnew=%%a"
timeout 2 /nobreak > NUL
set countold=%count%

echo Initiating deletion of %delamt% screenshots...
if 
echo OLD: %countold%
echo NEW: %countnew%
:deleteagain:
if %ran% == 0 goto loopstandard
:loopdelete:
set /a z+=1
set /a f=0
set /a e=0
set /a targetscreenshot=0
set /a e=%random% %% 3 + %balance%
:loopran:
set /a f+=1
set /a targetscreenshot+=%random% %% %files%
if %f% LSS %e% goto loopran
if %targetscreenshot% LSS 0 (
set /a f=0
goto loopran
)
nircmd.exe wait 100
echo %targetscreenshot% %z% %balance% %twist%
if %balance% GEQ 5 set /a twist+=1
if %balance% LSS 4 set /a twist-=1
set /a targetscreenshot=%targetscreenshot%*%twist%

if %targetscreenshot% GTR %countnew% (
set /a z-=1
if %balance% GTR 1 set /a balance-=1
rem echo HIGH %balance% %targetscreenshot%
goto loopran
)

if %targetscreenshot% LSS %countold% (
set /a z-=1
set /a balance+=1
rem echo LOW %balance% %targetscreenshot%
goto loopran
)

if not exist "%batdir%\screenshots\%targetscreenshot%*" (
rem echo Does not exist
goto loopran
)

rem del "%batdir%\screenshots\%targetscreenshot%*"
echo deleted! %targetscreenshot% %z% %balance% %twist%
if %z% LSS %delamt% goto loopdelete
goto loopdelete
goto end



:loopstandard:
for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\screenshots" ^| find /v /c ""') do set files=%%i

if %files% LSS %delqty% goto endl

if exist "%batdir%screenshots\%count%*" (
del "%batdir%screenshots\%count%*"
echo Deleting %count%!
set /a count2+=1
set /a count3=0
) else (
echo Missing %count%
)
if %count3% LEQ 100000 (
set /a count+=1
set /a count3+=1
) else if %count3% LEQ 1000000 (
set /a count+=10
set /a count3+=10
) else if %count3% LEQ 10000000 (
set /a count+=100
set /a count3+=100
) else if %count3% LEQ 100000000 (
set /a count+=1000
set /a count3+=1000
) else (
set /a count+=10000
set /a count3+=10000
)

if %count% GEQ 2147400000 (
set /a count=0
set /a count3=0
)

if %count2% LSS %delamt% goto loopstandard
:end:

for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\screenshots" ^| find /v /c ""') do set files=%%i

if %files% GTR %delqty% (
echo Deleting again!
for /f "delims=_" %%a in ('dir /b /a-d /o:-d "%batdir%screenshots\*_*.*"') do set "count=%%a"
set /a count2=0
set /a count3=0
timeout 1 /nobreak > NUL
goto loopstandard
)
:endl:

rem COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS 



set /a count=2000010000
set /a count2=0
set /a valcount=0
set /a count10=0
set /a "screenysize=0"
if exist cput.txt (
set /p cput=<cput.txt
timeout 2 /nobreak > NUL
) else (
set /a cput=500
echo 500 > cput.txt
)
for /f "tokens=2 delims=:" %%a in ('findstr "compressfilesizemin:" "config.cfg"') do set /a compressfilesizemin=%%a
set /a compressfilesizemin=%compressfilesizemin%*1000

echo Finding oldest screenshot...
for /f "delims=_" %%a in ('dir /b /a-d /o:-d "%batdir%screenshots\*_*.*"') do set "count=%%a"

echo Launching cpuload checker...
start "" /B cpuload.bat


echo Checking for compressed folder...
if exist %batdir%compressed\* (
powershell -ExecutionPolicy Bypass -File "%batdir%settimestamps.ps1" -Folder "%batdir%compressed"
timeout 2 /nobreak > NUL
move "%batdir%compressed\*.*" "%batdir%screenshots\" > NUL
timeout 2 /nobreak > NUL
) else (
mkdir compressed
)
echo Initiating compression of screenshots...
:loopc:
for /f "tokens=2 delims=:" %%a in ('findstr "compresscooloff:" "config.cfg"') do set /a compresscooloff=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compressmultithread:" "config.cfg"') do set /a compressmultithread=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compresssizetrigger:" "config.cfg"') do set /a compresssizetrigger=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compressquality:" "config.cfg"') do set /a compressquality=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compsd:" "config.cfg"') do set /a cpulim=%%a


echo Compress trigger: %compressfilesizemin%


set /a count2=0
set /a sizeMBA=0
set /a sizeMBB=0
set /a sizeMB=0
for /f %%A in ('powershell -command "(Get-ChildItem -Path 'screenshots' -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB"') do set /a sizeMBA=%%A
for /f %%A in ('powershell -command "(Get-ChildItem -Path 'compressed' -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB"') do set /a sizeMBB=%%A
set /a sizeMB=%sizeMBA%+%sizeMBB%
echo Size of folder: %sizeMB%

echo %sizeMB% GTR %compresssizetrigger%

if %sizeMB% GTR %compresssizetrigger% (
echo compressfilesizemin: %compressfilesizemin%
if %compresscooloff% GTR 0 timeout %compresscooloff% >nul
goto loopcompression
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
rem attrib -h del.th
rem timeout 1 /nobreak > NUL
rem echo deltxt:0 >del.th
rem timeout 1 /nobreak > NUL
rem attrib +h del.th
rem timeout 1 /nobreak > NUL
if exist compressed rmdir compressed
exit


:loopcompression:
if exist 1 (
set /a count=1
del 1
)

if not exist "%batdir%screenshots\%count%*" goto notexist
for %%F in ("%batdir%screenshots\%count%*") do (
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
rem if %count10% GTR 0 set /a count10-=1
)
rem else (
rem set /a count10+=1
rem if %count10% GEQ %compressmultithread% set /a count2-=1
rem if %count10% GEQ %compressmultithread% set count10=0
rem if %count2% LSS 1 set /a count2=0
rem echo %count% %count2%/%compressmultithread% %count10% %compsd%
rem echo %count% %count2%/%compressmultithread% %compsd%
rem )
rem if %valcount% == 2 set /a count-=1000
rem if %valcount% == 3 set /a count-=10000
rem if %valcount% == 4 set /a count-=100000
rem if %valcount% == 5 set /a count-=10000000
rem set /a valcount=0
set /a count3=0
goto skipnoexist
:notexist:
echo %count% Does not exist
:skipnoexist:
if %count3% LEQ 10000 (
set /a count+=1
set /a count3+=1
rem set /a valcount=1
) else if %count3% LEQ 100000 (
set /a count+=100
set /a count3+=100
rem set /a valcount=2
) else if %count3% LEQ 1000000 (
set /a count+=1000
set /a count3+=1000
rem set /a valcount=3
) else if %count3% LEQ 10000000 (
set /a count+=10000
set /a count3+=10000
rem set /a valcount=4
) else (
set /a count+=1000000
set /a count3+=1000000
rem set /a valcount=5
)

if %count% GEQ 2001000000 (
echo Cannot compress further!
echo Lowering compressfilesizemin value by 20^%! 
set /a cfsmm=%compressfilesizemin%/5
echo %cfsmm%
echo %compressfilesizemin%
set /a compressfilesizemin-=%cfsmm%
set /a count=0
set /a count2=2147483647
set /a count3=0
)
if %screenysize% GTR %compressfilesizemin% (
echo %count% %count2%/%compressmultithread% %count10% %compsd%
set /a count3=0
)





if %count2% GEQ %compressmultithread% goto loopc


goto loopcompression
rem COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS 