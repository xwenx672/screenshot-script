@echo off
title %~n0
set batdir=%~dp0
pushd "%batdir%"

echo Sorting del value...
attrib -h del.th
echo deltxt:1 >del.th
attrib +h del.th

echo Checking if to show or hide...
for /f "tokens=2 delims=:" %%a in ('findstr "showhidedel:" "config.cfg"') do set showhidedel=%%a



echo Checking errorlevel...
set /a delamt=%1
set /a delqty=%2
if %errorlevel% NEQ 0 exit
set /a count2=0

echo Enacting show or hide...
nircmd.exe win %showhidedel% ititle %~n0
for /f "tokens=2 delims=:" %%a in ('findstr "deldurbef:" "config.cfg"') do set /a deldurbef=%%a
for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\screenshots" ^| find /v /c ""') do set files=%%i

echo Finding oldest screenshot...
for /f "delims=_" %%a in ('dir /b /a-d /o:-d "%batdir%screenshots\*_*.*"') do set "count=%%a"
timeout 1 /nobreak > NUL

echo Initiating deletion of %delamt% screenshots...
timeout 3 /nobreak > NUL
cls

:loopq:
if exist %batdir%screenshots\%count%_*.* (
del %batdir%screenshots\%count%_*.*
echo Deleting %count%!
set /a count2+=1
set /a count3=0
) else (
echo Missing %count%
)
if %count3% LEQ 100000 (
set /a count+=1
set /a count3+=1
) else (
if %count3% LEQ 1000000 (
set /a count+=10
set /a count3+=10
) else (
if %count3% LEQ 10000000 (
set /a count+=100
set /a count3+=100
) else (
if %count3% LEQ 100000000 (
set /a count+=1000
set /a count3+=1000
) else (
set /a count+=10000
set /a count3+=10000
)
)
)
)

if %count% GEQ 2001000000 (
set /a count=0
set /a count3=0
)
if %count2% LSS %delamt% goto loopq
for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\screenshots" ^| find /v /c ""') do set files=%%i
for /f "tokens=2 delims=:" %%a in ('findstr "deldurbef:" "config.cfg"') do set /a deldurbef=%%a
timeout 1 /nobreak > NUL
echo Done Deleting!
if %deldurbef% == 0 (
attrib -h del.th
timeout 1 /nobreak > NUL
echo deltxt:0 >del.th
timeout 1 /nobreak > NUL
attrib +h del.th
timeout 1 /nobreak > NUL
exit
)

if %files% GTR %delqty% (
echo Deleting again!
for /f "delims=_" %%a in ('dir /b /a-d /o:-d "%batdir%screenshots\*_*.*"') do set "count=%%a"
set /a count2=0
set /a count3=0
timeout 1 /nobreak > NUL
goto loopq
)

attrib -h del.th
timeout 1 /nobreak > NUL
echo deltxt:0 >del.th
timeout 1 /nobreak > NUL
attrib +h del.th
timeout 1 /nobreak > NUL
exit