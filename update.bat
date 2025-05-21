@echo off
title %~n0
set batdir=%~dp0
pushd "%batdir%"
net session > NUL 2>&1
if %errorlevel% == 0 (
goto linkbreak
)
REM tasklist /v | findstr "backgroundscreenshot"
REM IF %ERRORLEVEL% EQU 0 taskkill /f /fi "windowtitle eq backgroundscreenshot"

nircmd.exe win hide ititle %~n0
echo LOADING...
echo DO NOT CLOSE...

:redoconcheck:
set /a countconnection+=1
timeout 1 /nobreak > NUL
ping /n 1 www.dropbox.com > NUL
if %errorLevel% == 0 (
	powershell -c "Invoke-WebRequest -Uri 'https://www.dropbox.com/s/htcazdfvy6mmosi/cssv.zip?dl=1' -OutFile '%batdir%\cssv.zip'"
	) else (
	echo Waiting for connection...
	if %countconnection% LSS 10 goto redoconcheck
	echo Cannot update, quitting update script...
	timeout 5 /nobreak > NUL
	exit
)


attrib -h yoke.vbs
attrib -h backgroundscreenshot.bat
attrib -h delete.bat
attrib -h nircmd.exe
attrib -h update.bat
attrib -h deleteday.bat
timeout 1 /nobreak > NUL
del /f yoke.vbs
del /f backgroundscreenshot.bat
del /f delete.bat
del /f deleteday.bat
del /f nircmd.exe
cls
echo LOADING...
echo DO NOT CLOSE...

:errorwait:
rem echo Waiting to see .zip
if not exist cssv.zip goto errorwait
tar.exe -xf cssv.zip
cls
echo LOADING...
echo DO NOT CLOSE...
timeout 1 /nobreak > NUL
timeout 1 /nobreak > NUL
timeout 1 /nobreak > NUL
timeout 1 /nobreak > NUL
timeout 1 /nobreak > NUL


:errorwait2:
rem echo Unpacking
if not exist delete.bat goto errorwait2
if not exist backgroundscreenshot.bat goto errorwait2
if not exist nircmd.exe goto errorwait2
if not exist update.bat goto errorwait2
if not exist yoke.vbs goto errorwait2
if not exist deleteday.bat goto errorwait2

:errorwait3:
rem echo deleting .zip
del cssv.zip
if not exist cssv.zip goto continue
goto errorwait3

:continue:
rem echo closing!

set updatevals=nodata
set timer=nodata
set hrsuntildel=nodata
set showhide=nodata
set showhidedel=nodata
set deldurbef=nodata
set filetype=nodata
set multiplier=nodata
set usc=nodata
set historylog=nodata
set updatemode=nodata
set fullhistory=nodata
set delpriorpost=nodata
set pastefirstoutput=nodata
set trimhistory=nodata
set trimhistorycap=nodata
set lagcompensation=nodata
set lrmcapmin=nodata
set lrmcapmax=nodata
set lagcompcooldowncfg=nodata
set restarttime=nodata
set maxagedfiles=nodata

for /f "tokens=2 delims=:" %%a in ('findstr "updatevals:" "config.cfg"') do set /a updatevals=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "timer:" "config.cfg"') do set /a timer=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "hrsuntildel:" "config.cfg"') do set /a hrsuntildel=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "showhide:" "config.cfg"') do set showhide=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "showhidedel:" "config.cfg"') do set showhidedel=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "deldurbef:" "config.cfg"') do set /a deldurbef=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "filetype:" "config.cfg"') do set filetype=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "multiplier:" "config.cfg"') do set /a multiplier=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "usc:" "config.cfg"') do set /a usc=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "historylog:" "config.cfg"') do set /a historylog=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "updatemode:" "config.cfg"') do set /a updatemode=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "fullhistory:" "config.cfg"') do set /a fullhistory=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "delpriorpost:" "config.cfg"') do set /a delpriorpost=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "pastefirstoutput:" "config.cfg"') do set /a pastefirstoutput=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "trimhistory:" "config.cfg"') do set /a trimhistory=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "trimhistorycap:" "config.cfg"') do set /a trimhistorycap=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "lagcompensation:" "config.cfg"') do set /a lagcompensation=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "lrmcap:" "config.cfg"') do set /a lrmcapmin=%%a
for /f "tokens=3 delims=:" %%a in ('findstr "lrmcap:" "config.cfg"') do set /a lrmcapmax=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "lagcompcooldowncfg:" "config.cfg"') do set /a lagcompcooldowncfg=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "restarttime:" "config.cfg"') do set /a restarttime=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "maxagedfiles:" "config.cfg"') do set /a maxagedfiles=%%a

if %updatevals% == nodata set /a updatevals=0
if %timer% == nodata set /a timer=5
if %hrsuntildel% == nodata set /a hrsuntildel=12
if %showhide% == nodata set showhide=show
if %showhidedel% == nodata set showhidedel=show
if %deldurbef% == nodata set /a deldurbef=0
if %filetype% == nodata set filetype=jpg
if %multiplier% == nodata set /a multiplier=11
if %usc% == nodata set /a usc=3600
if %historylog% == nodata set /a historylog=5
if %updatemode% == nodata set /a updatemode=2
if %fullhistory% == nodata set /a fullhistory=0
if %delpriorpost% == nodata set /a delpriorpost=0
if %pastefirstoutput% == nodata set /a pastefirstoutput=0
if %trimhistory% == nodata set /a trimhistory=0
if %trimhistorycap% == nodata set /a trimhistorycap=5000
if %lagcompensation% == nodata set /a lagcompensation=500
if %lrmcapmin% == nodata set /a lrmcapmin=2
if %lrmcapmax% == nodata set /a lrmcapmax=5
if %lagcompcooldowncfg% == nodata set /a lagcompcooldowncfg=100
if %restarttime% == nodata set /a restarttime=86400
if %maxagedfiles% == nodata set /a maxagedfiles=14

del config.cfg
timeout 1 /nobreak > NUL
echo Update values during loops. 0=off 1=on.>>config.cfg
echo updatevals:%updatevals%>>config.cfg
echo.>>config.cfg
echo Time Between Each Screenshot>>config.cfg
echo timer:%timer%>>config.cfg
echo.>>config.cfg
echo Hours of Screenshots Until Delete>>config.cfg
echo hrsuntildel:%hrsuntildel%>>config.cfg
echo.>>config.cfg
echo How old screenshots can be before they are deleted>>config.cfg
echo maxagedfiles:%maxagedfiles%>>config.cfg
echo.>>config.cfg
echo Show or Hide Main Window show/hide>>config.cfg
echo showhide:%showhide%>>config.cfg
echo.>>config.cfg
echo Show or Hide Deleting Window show/hide>>config.cfg
echo showhidedel:%showhidedel%>>config.cfg
echo.>>config.cfg
echo Delete at startup only=0 Delete during computer use=1 >>config.cfg
echo deldurbef:%deldurbef%>>config.cfg
echo.>>config.cfg
echo File Type>>config.cfg
echo filetype:%filetype%>>config.cfg
echo.>>config.cfg
echo Delete multiplier, needs to be 10 or more, higher means more screenshots are deleted>>config.cfg
echo multiplier:%multiplier%>>config.cfg
echo.>>config.cfg
echo Initial minimum history val and uptime before recording history in seconds>>config.cfg
echo usc:%usc%>>config.cfg
echo.>>config.cfg
echo How many inputs in to the history log are allowed>>config.cfg
echo historylog:%historylog%>>config.cfg
echo.>>config.cfg
echo No Updates=0 Prompt to update=1 Auto Update=2 Note: Variable change for updatemode will take affect after 2 restarts of the script>>config.cfg
echo updatemode:%updatemode%>>config.cfg
echo.>>config.cfg
echo Full History. 0=off 1=on>>config.cfg
echo fullhistory:%fullhistory%>>config.cfg
echo.>>config.cfg
echo Delete prior or post to cap. 0=prior 1=post>>config.cfg
echo delpriorpost:%delpriorpost%>>config.cfg
echo.>>config.cfg
echo Paste first output and open in txt file. 0=off 1=on>>config.cfg
echo pastefirstoutput:%pastefirstoutput%>>config.cfg
echo.>>config.cfg
echo Full trim history. Layout; Timer Trim : Trim Bias : Lag Cooldown : Current Lag Compensation. 0=off 1=on>>config.cfg
echo trimhistory:%trimhistory%>>config.cfg
echo.>>config.cfg
echo Trim history cap. Integer refers to lines in the th file. Set to anything above 0. trimhistory.th will be trimmed on start of script.>>config.cfg
echo trimhistorycap:%trimhistorycap%>>config.cfg
echo.>>config.cfg
echo Lag compensation value.>>config.cfg
echo This setting changes how the script deals with lag, depending on the set value, it will increase lag handling by slowing >>config.cfg
echo the script more and sooner (lower value of no less than 1) or decrease lag handling by slowing the script less and later (higher value of no more than 1000) when it starts lagging.>>config.cfg
echo WARNING: SETTING IT TOO LOW WILL CAUSE THE SCRIPT TO HAVE SERIOUS RESPONSE TIME ISSUES.>>config.cfg
echo lagcompensation:%lagcompensation%>>config.cfg
echo.>>config.cfg
echo The lowest lag compensation will go : The highest lag compensation will go.>>config.cfg
echo lrmcap:%lrmcapmin%:%lrmcapmax%>>config.cfg
echo.>>config.cfg
echo How long in loops the script will wait before attempting to be more responsive following lag compensation application.>>config.cfg
echo lagcompcooldowncfg:%lagcompcooldowncfg%>>config.cfg
echo.>>config.cfg
echo How long the script runs until it restarts.>>config.cfg
echo restarttime:%restarttime%>>config.cfg
echo.>>config.cfg
timeout 1 /nobreak > NUL
start backgroundscreenshot.bat

:linkbreak:
set /p oldloc=<loc.th
timeout 1 /nobreak > NUL
schtasks /query /tn bgscrnshtr > NUL 2>&1
if %errorlevel% == 1 set oldloc=0

if "%oldloc%" == "%batdir%" exit


net session > NUL 2>&1
if %errorlevel% == 0 (
	break
	) else (
	nircmd.exe elevate "%batdir%\%~n0.bat"
	exit
)
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\screenshotter.lnk" del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\screenshotter.lnk"
schtasks /create /tn bgscrnshtr /tr "%batdir%backgroundscreenshot.bat" /sc ONLOGON /f
attrib -h loc.th
timeout 1 /nobreak > NUL
echo %batdir%>loc.th
timeout 1 /nobreak > NUL
attrib +h loc.th
timeout 1 /nobreak > NUL
exit