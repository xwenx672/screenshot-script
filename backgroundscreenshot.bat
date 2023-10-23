@echo off
title %~n0
set batdir=%~dp0
pushd "%batdir%"
set /a countversion=0
set /a counttwoversion=0
:start:

set "version=v1.05"
echo Current version: %version%
echo Checking for updates!

if exist version.txt del version.txt
ping /n 1 www.dropbox.com > NUL
if %errorLevel% == 0 (
	powershell -c "Invoke-WebRequest -Uri 'https://www.dropbox.com/s/o72g1c2aj616yhm/version.txt?dl=1' -OutFile '%batdir%\version.txt'"
	) else (
	Cannot check for updates, skipping
	timeout 2 /nobreak > NUL
	goto priority
)

:waitingforversion:
if not exist version.txt (
set /a countversion+=1
timeout 1 /nobreak > NUL
if %countversion% LEQ 2 goto waitingforversion
set /a countversion=0
set /a counttwoversion+=1
if %counttwoversion% LEQ 1 goto start
echo Cannot update, no idea why.
timeout 5
goto priority
)

for /f "tokens=* delims=" %%a in ('type version.txt') do set curversiontxt=%%a
timeout 1 /nobreak > NUL
del version.txt
if not exist update.bat (
echo WARNING, UPDATE.BAT NOT PRESENT, CANNOT UPDATE, PLEASE REDOWNLOAD UPDATE.BAT.
pause
pause
) else (
attrib +h update.bat
)
if %curversiontxt% NEQ %version% (
start update.bat
exit
)

:priority:
set /a count+=1
if %count% GEQ 10 exit
echo.
echo.
for /f "tokens=2" %%p in ('tasklist /fi "WindowTitle eq %~n0"') do set pid=%%p
wmic process where processid=%pid% CALL setpriority 64
wmic process where processid=%pid% get priority
if %count% LSS 3 goto priority
cls

echo Checking for essential files...
if not exist nircmd.exe (
echo missing nircmd
set /a count+=1
timeout 2 /nobreak > NUL
goto priority
) else (
attrib +h nircmd.exe
)
if not exist delete.bat (
echo missing delete.bat
pause
exit
) else (
attrib +h delete.bat
)
if not exist screenshots mkdir screenshots
if not exist config.cfg (
	echo Creating config.cfg
	echo Time Between Each Screenshot>>config.cfg
	echo timer:5>>config.cfg
	echo. >>config.cfg
	echo Hours of Screenshots Until Delete>>config.cfg
	echo hrsuntildel:12>>config.cfg
	echo.>>config.cfg
	echo Show or Hide Main Window show/hide>>config.cfg
	echo showhide:show>>config.cfg
	echo.>>config.cfg
	echo Show or Hide Deleting Window show/hide>>config.cfg
	echo showhidedel:hide>>config.cfg
	echo.>>config.cfg
	echo Delete at startup only=0 Delete during computer use=1 >>config.cfg
	echo deldurbef:0>>config.cfg
	echo.>>config.cfg
	echo How many screenshots until data updates? Higher=Less resource usage>>config.cfg
	echo lrmcount:5>>config.cfg
	echo.>>config.cfg
	echo File Type>>config.cfg
	echo filetype:jpg>>config.cfg
	echo.>>config.cfg
	echo Delete multiplier, needs to be 10 or more, higher means more screenshots are deleted>>config.cfg
	echo multiplier:11>>config.cfg
	echo.>>config.cfg
	echo Initial minimum history val and uptime before recording history in seconds>>config.cfg
	echo usc:1800>>config.cfg
	echo.>>config.cfg
	echo How many inputs in to the history log are allowed>>config.cfg
	echo historylog:5>>config.cfg
	echo.>>config.cfg
	echo Quick start up. 0=off 1=on>>config.cfg
	echo qsu:0>>config.cfg
	timeout 2 /nobreak> NUL
	start notepad.exe config.cfg
	echo Once you've configured the config and saved, select this window and press enter until the script moves on.
	pause
	cls
)
for /f "tokens=2 delims=:" %%a in ('findstr "qsu:" "config.cfg"') do set /a qsu=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "showhide:" "config.cfg"') do set showhide=%%a
if %qsu% == 1 nircmd.exe win %showhide% ititle %~n0
if %qsu% == 0 timeout 1 /nobreak > NUL
echo Priority set to lowest...
if %qsu% == 0 timeout 1 /nobreak > NUL
echo Setting advanced vals...
if %qsu% == 0 timeout 1 /nobreak > NUL
for /f "tokens=2 delims=:" %%a in ('findstr "multiplier:" "config.cfg"') do set multiplier=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "usc:" "config.cfg"') do set usc=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "historylog:" "config.cfg"') do set historylog=%%a
set /a count=0
set /a count2=0
set /a count4=0
set /a count6=0
set showhide=start

echo Resetting del state...
if %qsu% == 0 timeout 1 /nobreak > NUL
if exist del.th attrib -h del.th
echo deltxt:0>del.th
attrib +h del.th

echo Checking and updating history...
if exist history.th attrib -h history.th
if %qsu% == 0 timeout 1 /nobreak > NUL

if exist count.th (
type count.th>>history.th
del count.th
timeout 1 /nobreak > NUL
)

if exist history.th (
if exist history.th.bck attrib -h history.th.bck
if exist history.th copy history.th history.th.bck > NUL
timeout 1 /nobreak > NUL
if exist history.th.bck attrib +h history.th.bck
) else (
if exist history.th.bck attrib -h history.th.bck
if exist history.th.bck copy history.th.bck history.th > NUL
if exist history.th.bck timeout 1 /nobreak > NUL
if exist history.th.bck attrib +h history.th.bck
)
)

timeout 2 /nobreak > NUL
if not exist history.th (
set /a history=%usc%
set /a count5=1
goto skiphistorydeltwo
)
for /f "tokens=* delims=" %%a in (history.th) do (set /a count6+=1)
if %count6% LEQ %historylog% goto skiphistorydel
if exist temp.th del temp.th
set /a count6=%count6%-%historylog%


for /f "skip=%count6% delims=" %%a in ('type "history.th" ^| findstr "^"') do (
    echo %%a>>temp.th
)
timeout 1 /nobreak > NUL
del history.th
timeout 1 /nobreak > NUL
rename temp.th history.th
timeout 1 /nobreak > NUL
:skiphistorydel:
for /f %%a in (history.th) do (
set /a history+=%%a
set /a count5+=1
)
:skiphistorydeltwo:
set /a avehis=((%history%/%count5%)*%multiplier%)/10
if exist history.th attrib +h history.th


echo Inspecting system data...
if %qsu% == 0 timeout 1 /nobreak > NUL
for /f "tokens=2 delims=:" %%a in ('findstr "filetype:" "config.cfg"') do set filetype=%%a
for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set dt=%%a
set screeny=%dt:~0,8%-%dt:~8,4%
:countscreeny:
for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\screenshots" ^| find /v /c ""') do set files=%%i
if %files% GEQ 5 (
for /f "delims=_" %%a in ('dir /b /a-d /o:d "%batdir%\screenshots\*"') do set "count=%%a"
) else (
echo Screenshot folder empty, taking estimate screenshots...
nircmd.exe savescreenshotfull "%batdir%screenshots\0_%screeny%.%filetype%"
nircmd.exe savescreenshotfull "%batdir%screenshots\1_%screeny%.%filetype%"
nircmd.exe savescreenshotfull "%batdir%screenshots\2_%screeny%.%filetype%"
nircmd.exe savescreenshotfull "%batdir%screenshots\3_%screeny%.%filetype%"
nircmd.exe savescreenshotfull "%batdir%screenshots\4_%screeny%.%filetype%"
timeout 1 /nobreak > NUL
goto countscreeny
)

echo Installing cfg settings...
if %qsu% == 0 timeout 1 /nobreak > NUL
for /f "tokens=2 delims=:" %%a in ('findstr "timer:" "config.cfg"') do set /a timer=%%a
set /a nircmdtimer=%timer%*1000
for /f "tokens=2 delims=:" %%a in ('findstr "hrsuntildel:" "config.cfg"') do set /a hrsuntildel=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "deldurbef:" "config.cfg"') do set /a deldurbef=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "lrmcount:" "config.cfg"') do set /a lrmcount=%%a
set /a secsuntildel=%hrsuntildel%*3600
set /a delqty=%secsuntildel%/%timer%

echo Estimating screenshot size takeup...
for %%i in (screenshots\*) do (
set /a filesize+=%%~zi/1024
set /a count3+=1
)
set /a average=(%filesize%/%count3%)
set /a sizebef=(%delqty%*%average%)/1024
if %sizebef% GEQ 10240 (
set sizetxt=GB
set /a sizein=%sizebef%/1024
) else (
set sizetxt=MB
set /a sizein=%sizebef%
)
set /a delamt=%avehis%/%timer%

echo Starting main script...
if %qsu% == 0 timeout 2 /nobreak > NUL
if %deldurbef% == 0 goto loopd
goto loopg

:lrmskip:
set /a count4+=%timer%
set /a count2+=1
set /a count+=1
nircmd.exe wait %nircmdtimer%
rem timeout %timer% > NUL
nircmd.exe savescreenshotfull "%batdir%screenshots\%count%_%screeny%.%filetype%"
if %count2% LSS %lrmcount% (
goto lrmskip
) else (
set /a count2=0
)

:loopg:
if %count4% GEQ %usc% echo %count4% >count.th
if not exist config.cfg (
start %~n0
exit
)
for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set dt=%%a
set screeny=%dt:~0,8%-%dt:~8,4%
for /f "tokens=2 delims=:" %%a in ('findstr "filetype:" "config.cfg"') do set filetype=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "timer:" "config.cfg"') do set /a timer=%%a
set /a nircmdtimer=%timer%*1000
set showhidetemp=%showhide%
for /f "tokens=2 delims=:" %%a in ('findstr "showhide:" "config.cfg"') do set showhide=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "deldurbef:" "config.cfg"') do set /a deldurbef=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "lrmcount:" "config.cfg"') do set /a lrmcount=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "hrsuntildel:" "config.cfg"') do set /a hrsuntildel=%%a
set /a secsuntildel=%hrsuntildel%*3600
set /a delqty=%secsuntildel%/%timer%
set /a sizebef=(%delqty%*%average%)/1024
if %sizebef% GEQ 10240 (
set sizetxt=GB
set /a sizein=%sizebef%/1024
) else (
set sizetxt=MB
set /a sizein=%sizebef%
)
set /a delamt=%avehis%/%timer%
if %showhidetemp% NEQ %showhide% nircmd.exe win %showhide% ititle %~n0
for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\screenshots" ^| find /v /c ""') do set files=%%i
cls
if %deldurbef% == 0 (
echo Deleting **on boot** when %delqty% screenshots are reached: %delamt%
) else if %deldurbef% == 1 (
echo Deleting **during computer use** when %delqty% screenshots are reached: %delamt%
)
echo.
echo %filetype% number:
echo %count%
echo.
echo Current screenshots saved:
echo %files%
echo.
echo Current estimated size the script will take up in %sizetxt%***
echo with current settings and vals since script start:
echo %sizein%
echo.
echo After this many screenshots, update values:
echo %lrmcount%
echo.
echo Current file ending:
echo %filetype%
if %deldurbef% == 0 goto lrmskip

:loopd:
attrib -h del.th
if not exist del.th echo 0>del.th
for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\screenshots" ^| find /v /c ""') do set files=%%i
for /f "tokens=2 delims=:" %%a in ('findstr "deltxt:" "del.th"') do set /a deltxt=%%a
attrib +h del.th
if %files% geq %delqty% (if %deltxt% == 0 start delete.bat)
goto loopg