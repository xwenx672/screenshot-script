@echo off
setlocal EnableDelayedExpansion
title %~n0
set batdir=%~dp0
pushd "%batdir%"

if exist lastrun.txt (
set /p lastrun=<lastrun.txt
timeout 2 /nobreak > NUL
) else (
set lastrun=1
)

if %lastrun% == %date% exit

rem if not exist biasvalue.txt (
rem echo 100> biasvalue.txt
rem )

for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\old_archive" ^| find /v /c ""') do set files=%%i
timeout 2 /nobreak > NUL

set /a biasval=%files%/200
if %biasval% LSS 1000 set /a biasval=1000


rem set /p biasval=<biasvalue.txt


rem set /a biasval=(%biasval%*101)/100

rem echo %biasval%



rem powershell -ExecutionPolicy Bypass -File "%batdir%settimestamps.ps1" -Folder "%batdir%old_archive"
rem timeout 2 /nobreak > NUL
rem for /f "delims=_" %%a in ('dir /b /a-d /o:d "%batdir%old_archive\*"') do set "countold=%%a"
rem for /f "delims=_" %%a in ('dir /b /a-d /o:-d "%batdir%old_archive\*"') do set "countnew=%%a"

set d=0
rem set /a low=350000
set /a low=0
rem set /a high=1860000
set /a high=2147483647
set count3=100000
nircmd.exe win setsize title %~n0 0 0 650 450
:countingold:
echo %low% %count3%
if not exist %batdir%old_archive\%low%_* goto concountingold
if %count3% GTR 100000 (
set /a low-=100000
set /a count3=-5000
goto countingold
)
if %count3% GTR 10000 (
set /a low-=10000
set /a count3=-500
goto countingold
)

set /a count3=100000
set /a countold=%low%
goto countingnew
:concountingold:
if %count3% LEQ 10000 (
set /a low+=1
set /a count3+=1
) else (
if %count3% LEQ 100000 (
set /a low+=100
set /a count3+=100
) else (
if %count3% LEQ 1000000 (
set /a low+=1000
set /a count3+=1000
) else (
if %count3% LEQ 10000000 (
set /a low+=10000
set /a count3+=10000
) else (
set /a low+=100000
set /a count3+=100000
)
)
)
)
if %low% GEQ 2001000000 (
set /a low=0
set /a count3=0
)
goto countingold

:countingnew:
echo %high% %count3%
if not exist %batdir%old_archive\%high%_* goto concountingnew
if %count3% GTR 100000 (
set /a high+=100000
set /a count3=-5000
goto countingnew
)
if %count3% GTR 10000 (
set /a high+=10000
set /a count3=-500
goto countingnew
)

set /a countnew=%high%
goto endcounting
:concountingnew:
if %count3% LEQ 10000 (
set /a high-=1
set /a count3+=1
) else (
if %count3% LEQ 100000 (
set /a high-=100
set /a count3+=100
) else (
if %count3% LEQ 1000000 (
set /a high-=1000
set /a count3+=1000
) else (
if %count3% LEQ 10000000 (
set /a high-=10000
set /a count3+=10000
) else (
set /a high-=100000
set /a count3+=100000
)
)
)
)

if %high% LEQ 0 (
echo No more screenshots
pause
exit
)
goto countingnew
:endcounting:
echo biasval: %biasval%
echo OLD: %countold%
echo NEW: %countnew%
set /a balance=90
set /a twist=90
set /a z=0
:loop:
set /a z+=1
set /a f=0
set /a e=0
set /a start=0
set /a e=%random% %% 25 + %balance%
if %e% LSS 1 set /a e+=1
:looploop:
set /a f+=1
set /a start+=%random%
if %f% LSS %e% goto looploop
if %balance% GTR 7 set /a twist+=1
if %balance% LSS 5 set /a twist-=1
if %twist% LSS 2 set /a twist=2
if %balance% LSS 0 set /a balance=1
set /a start=(%start%*%twist%)+((%RANDOM% %% 2)+1)
if %start% GTR %countnew% (
set /a z-=1
set /a balance-=1
rem echo HIGH %balance%
goto loop
)
if %start% LSS %countold% (
set /a z-=1
set /a balance+=1
rem echo LOW %balance%
goto loop
)

if not exist "%batdir%\old_archive\%start%*" (
rem echo Does not exist
set /a z-=1
goto loop
)
echo z:%z% bal:%balance% tw:%twist% e:%e% %start% 
del "%batdir%\old_archive\%start%*"
if %z% GTR %biasval% (
echo deleted %biasval%
rem echo %biasval%>biasvalue.txt
echo %date%>lastrun.txt
timeout 10 /nobreak 
exit
)
goto loop




if %count3% GTR 1000 (
set /a low-=1000
set /a count3=-100
goto countingold
)
if %count3% GTR 100 (
set /a low-=100
set /a count3=-10
goto countingold
)

if %count3% GTR 1000 (
set /a high+=1000
set /a count3=-100
goto countingnew
)
if %count3% GTR 100 (
set /a high+=100
set /a count3=-10
goto countingnew
)
