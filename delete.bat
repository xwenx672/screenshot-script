@echo off
title %~n0
set batdir=%~dp0
pushd "%batdir%"

nircmd.exe win hide ititle %~n0

REM DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg
for /f "tokens=2 delims=:" %%a in ('findstr "showhidedel:" "config.cfg"') do set showhidedel=%%a
timeout 1 /nobreak > NUL
nircmd.exe win %showhidedel% ititle %~n0

attrib -h del.th
timeout 1 /nobreak > NUL
echo deltxt:1 >del.th
timeout 1 /nobreak > NUL
attrib +h del.th

REM DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg DEL.cfg


REM SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP
set /a count2=0
for /f "tokens=2 delims=:" %%a in ('findstr "timer:" "config.cfg"') do set /a timer=%%a
for /f "delims=_" %%a in ('dir /b /a-d /o:-d "%batdir%screenshots\*_*.*"') do set "count=%%a"
REM SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP SETUP


REM HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT
attrib -h history.th
for /f %%a in (history.th) do (
set /a history+=%%a
set /a count5+=1
)
set /a multiplier=12
set /a avehis=((%history%/%count5%)*%multiplier%)/10
set /a delamt=%avehis%/%timer%
echo Deleting %delamt%
attrib +h history.th
timeout 3
cls
REM HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT HISTORYDELAMT


REM DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP
:loopq:
if exist %batdir%screenshots\%count%_*.* (
del %batdir%screenshots\%count%_*.*
echo Deleting %count%!
set /a count2=%count2%+1
)
set /a count=%count%+1
if %count2% LEQ %delamt% goto loopq
REM DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP DELLOOP


REM END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END
attrib -h del.th
timeout 1 /nobreak > NUL
echo deltxt:0 >del.th

attrib +h del.th
echo Done Deleting!
timeout 3 > NUL
exit
REM END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END






REM REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE

rem for /f "tokens=2 delims=:" %%a in ('findstr "hrsuntildel:" "config.cfg"') do set /a hrsuntildel=%%a
rem set /a secsuntildel=%hrsuntildel%*3600
rem set /a delqty=%secsuntildel%/%timer%


rem for /f "delims=" %%a in ('dir /b /a-d /o:-d "%batdir%screenshots\*.png"') do set "oldestFile=%batdir%screenshots\%%a"
rem del %oldestfile%
rem echo Deleting %oldestFile%!



rem set /a count2=1
rem for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\screenshots" ^| find /v /c ""') do set files=%%i
rem echo %files% %delqty%
rem if %files% geq %delqty% (
rem echo Deleting another %delamt%!
rem timeout 1 /nobreak> NUL
rem goto loopq
rem)

REM REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE REMOVEDCODE