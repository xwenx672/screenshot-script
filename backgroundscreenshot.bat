@echo off
title %~n0
set batdir=%~dp0
pushd "%batdir%"
if exist run*.th del run*.th
set /a exeid=%random%
echo deleting this th file will close the script>run%exeid%.th
set /a countversion=0
set /a ans=0
cls
timeout 1 /nobreak > NUL
nircmd.exe win hide ititle %~n0

set "version=v1.22.1"
echo Current version: %version%
echo.
:essentialfiles:
echo Checking for essential files...
if not exist update.bat (
echo Update.bat not present, this script is required, please reobtain script and place in %batdir%
pause
exit
)

if not exist yoke.vbs (
start update.bat
exit
) else (
attrib +h yoke.vbs
)
if not exist update.bat (
start update.bat
exit
) else (
attrib +h update.bat
)
if not exist nircmd.exe (
start update.bat
exit
) else (
attrib +h nircmd.exe
)
if not exist delete.bat (
start update.bat
exit
) else (
attrib +h delete.bat
)
if not exist deleteday.bat (
start update.bat
exit
) else (
attrib +h deleteday.bat
)


if not exist screenshots mkdir screenshots

if not exist config.cfg (
start update.bat
exit
)

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


set /a nodataissue=0
if %updatevals% == nodata set /a nodataissue=1
if %timer% == nodata set /a nodataissue=1
if %hrsuntildel% == nodata set /a nodataissue=1
if %showhide% == nodata set /a nodataissue=1
if %showhidedel% == nodata set /a nodataissue=1
if %deldurbef% == nodata set /a nodataissue=1
if %filetype% == nodata set /a nodataissue=1
if %multiplier% == nodata set /a nodataissue=1
if %usc% == nodata set /a nodataissue=1
if %historylog% == nodata set /a nodataissue=1
if %updatemode% == nodata set /a nodataissue=1
if %fullhistory% == nodata set /a nodataissue=1
if %delpriorpost% == nodata set /a nodataissue=1
if %pastefirstoutput% == nodata set /a nodataissue=1
if %trimhistory% == nodata set /a nodataissue=1
if %trimhistorycap% == nodata set /a nodataissue=1
if %lagcompensation% == nodata set /a nodataissue=1
if %lrmcapmin% == nodata set /a nodataissue=1
if %lrmcapmax% == nodata set /a nodataissue=1
if %lagcompcooldowncfg% == nodata set /a nodataissue=1
if %restarttime% == nodata set /a nodataissue=1
if %maxagedfiles% == nodata set /a nodataissue=1

if %nodataissue% == 1 (
start update.bat
exit
)

set /a lrmcapminp1=%lrmcapmin%+1
nircmd.exe win %showhide% ititle %~n0

nircmd.exe win setsize title %~n0 0 0 650 450
if exist update0.th goto skipupdate

echo Checking for updates...
if exist version.txt del version.txt
:redoconcheck:
set /a countconnection+=1
timeout 1 /nobreak > NUL
ping /n 1 www.dropbox.com > NUL
if %errorLevel% == 0 (
	powershell -c "Invoke-WebRequest -Uri 'https://www.dropbox.com/s/o72g1c2aj616yhm/version.txt?dl=1' -OutFile '%batdir%\version.txt'"
	) else (
	echo Waiting for connection...
	if %countconnection% LSS 5 goto redoconcheck
	echo Cannot check for updates, skipping...
	timeout 2 /nobreak > NUL
	goto skipupdate
)
:waitingforversion:
if not exist version.txt (
set /a countversion+=1
timeout 1 /nobreak > NUL
if %countversion% LEQ 2 goto waitingforversion
echo Cannot update, no idea why.
timeout 5
goto skipupdate
)
for /f "tokens=* delims=" %%a in ('type version.txt') do set curversiontxt=%%a
timeout 1 /nobreak > NUL
del version.txt
if %curversiontxt% == %version% goto skipupdate
if exist update1.th for /f "delims=" %%i in ('cscript //nologo "%batdir%yoke.vbs"') do (set ans=%%i)
timeout 1 /nobreak > NUL
if %ans% == no goto skipupdate
start update.bat
exit
:skipupdate:

echo Setting advanced vals...

if %updatemode% == 0 (
if exist update0.th attrib -h update0.th
if exist update1.th attrib -h update1.th
if not exist update0.th echo value0 >update0.th
if exist update1.th del update1.th
attrib +h update0.th
) else (
if %updatemode% == 1 (
if exist update0.th attrib -h update0.th
if exist update1.th attrib -h update1.th
if not exist update1.th echo value1 >update1.th
if exist update0.th del update0.th
attrib +h update1.th
) else (
if %updatemode% == 2 (
if exist update0.th attrib -h update0.th
if exist update1.th attrib -h update1.th
if exist update0.th del update0.th
if exist update1.th del update1.th
)
)
)

set /a count=0
set /a count2=0
set /a count4=0
set /a count6=0
set /a lagcompcooldown=0
set trimscreenyold=nodata
set /a trim=0
set /a nircmdtimer=1000
set /a lrmcount=%lrmcapmin%
set showhidetemp=somethingelse
set /a trimscreenyold=2000000000
set /a trimcap=%timer%*%lagcompensation%
set /a trim=%trimcap%
set /a trimcapset=%trimcap%

if exist del.th attrib -h del.th
echo deltxt:2>del.th
attrib +h del.th

echo Checking and updating histories...
if not exist trimhistory.th goto skiptrimhistory
for /f "tokens=* delims=" %%a in (trimhistory.th) do (set /a count6+=1)
if %count6% LEQ %trimhistorycap% goto skiptrimhistory
if exist temp.th del temp.th
set /a count6=%count6%-%trimhistorycap%
for /f "skip=%count6% delims=" %%a in ('type "trimhistory.th" ^| findstr "^"') do (
    echo %%a>>temp.th
)
timeout 1 /nobreak > NUL
del trimhistory.th
timeout 1 /nobreak > NUL
rename temp.th trimhistory.th
timeout 1 /nobreak > NUL
:skiptrimhistory:
set /a count6=0

if exist history.th attrib -h history.th
timeout 1 /nobreak > NUL
if exist count.th (
if %fullhistory% == 1 (
if exist fullhistory.th attrib -h fullhistory.th
type count.th>>fullhistory.th
if exist fullhistory.th attrib +h fullhistory.th
)
)
if exist count.th (
type count.th>>history.th
timeout 1 /nobreak > NUL
del count.th
)

timeout 1 /nobreak > NUL
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
set /a avehisnomul=%history%/%count5%
if exist history.th attrib +h history.th

echo Inspecting system data...

for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set dt=%%a
set screeny=%dt:~0,8%-%dt:~8,4%

rem Below line is meant to be in checking and updating history, however the code flows better with the line here instead.
if %trimhistory% == 1 echo %screeny% >>trimhistory.th

:countscreeny:
for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\screenshots" ^| find /v /c ""') do set files=%%i
if %files% GEQ 5 (
for /f "delims=_" %%a in ('dir /b /a-d /o:d "%batdir%\screenshots\*"') do set "count=%%a"
) else (
echo Screenshot folder empty, taking estimate screenshots...
nircmd.exe savescreenshotfull "%batdir%screenshots\1_%screeny%.%filetype%"
nircmd.exe savescreenshotfull "%batdir%screenshots\2_%screeny%.%filetype%"
nircmd.exe savescreenshotfull "%batdir%screenshots\3_%screeny%.%filetype%"
nircmd.exe savescreenshotfull "%batdir%screenshots\4_%screeny%.%filetype%"
nircmd.exe savescreenshotfull "%batdir%screenshots\5_%screeny%.%filetype%"
timeout 1 /nobreak > NUL
goto countscreeny
)
if %count% GEQ 2000000000 set /a count=0

echo Estimating screenshot size takeup...
for %%i in (screenshots\*) do (
set /a filesize+=%%~zi/1024
set /a count3+=1
)
set /a average=(%filesize%/%count3%)

echo Deleting screenshots older than %maxagedfiles%
if not exist del.th (
echo deltxt:2 >del.th
attrib +h del.th
timeout 1 /nobreak > NUL
)
start deleteday.bat %maxagedfiles%
set /a deltxt=2
echo Starting script...

:priority:
set /a count7+=1
echo.
echo.
for /f "tokens=2" %%p in ('tasklist /fi "WindowTitle eq %~n0"') do set pid=%%p
wmic process where processid=%pid% CALL setpriority 64
wmic process where processid=%pid% get priority
if %count7% LSS 2 goto priority
cls
goto loopg

:lrmskip:
set /a count4+=%timer%
set /a count2+=1
set /a count+=1
nircmd.exe wait %nircmdtimer%
nircmd.exe savescreenshotfull "%batdir%screenshots\%count%_%screeny%.%filetype%"
if %count2% LSS %lrmcount% (
goto lrmskip
) else (
set /a count2=0
)

:loopg:
if not exist run%exeid%.th exit
if not exist config.cfg (
start %~n0
exit
)
for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set dt=%%a
set screeny=%dt:~0,8%-%dt:~8,6%
set /a trimscreenynew=((1%dt:~8,2%)*3600000)+((1%dt:~10,2%)*60000)+((1%dt:~12,2%)*1000)+(1%dt:~15,3%)

set /a sumtrimscreeny=%trimscreenynew%-%trimscreenyold%

for /f "tokens=2 delims=:" %%a in ('findstr "updatevals:" "config.cfg"') do set /a updatevals=%%a
if %updatevals% == 1 (
for /f "tokens=2 delims=:" %%a in ('findstr "timer:" "config.cfg"') do set /a timer=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "hrsuntildel:" "config.cfg"') do set /a hrsuntildel=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "showhide:" "config.cfg"') do set showhide=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "deldurbef:" "config.cfg"') do set /a deldurbef=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "filetype:" "config.cfg"') do set filetype=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "multiplier:" "config.cfg"') do set /a multiplier=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "usc:" "config.cfg"') do set /a usc=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "historylog:" "config.cfg"') do set /a historylog=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "updatemode:" "config.cfg"') do set /a updatemode=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "delpriorpost:" "config.cfg"') do set /a delpriorpost=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "lagcompensation:" "config.cfg"') do set /a lagcompensation=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "lrmcap:" "config.cfg"') do set /a lrmcapmin=%%a
for /f "tokens=3 delims=:" %%a in ('findstr "lrmcap:" "config.cfg"') do set /a lrmcapmax=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "lagcompcooldowncfg:" "config.cfg"') do set /a lagcompcooldowncfg=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "restarttime:" "config.cfg"') do set /a restarttime=%%a
set /a lrmcapminp1=%lrmcapmin%+1
)

set /a lrmcountplustimer=%lrmcount%*%timer%*1000

if %trimhistory% == 1 echo %trim%,%lrmcount%,%lagcompcooldown%,%trimscreenynew%,%trimscreenyold%,%sumtrimscreeny%,%lrmcountplustimer%,%screeny% >>trimhistory.th
if %lrmcount% LSS %lrmcapmax% (
set /a trimcap=%timer%*%lagcompensation%
set /a trimcapset=%trimcap%
) else (
set /a trimcap=%timer%*1000
)

set /a trim=%trim%-((%lrmcountplustimer%-%sumtrimscreeny%)/%lrmcount%)

if %trim% LEQ %trimcapset% (
if %lagcompcooldown% GTR 0 set /a lagcompcooldown=%lagcompcooldown%-1
)

if %trim% LSS -10000 (
set /a trim=0
)

if %trim% GTR %trimcap% (
if %lrmcount% LSS %lrmcapmax% set /a lrmcount+=1
set /a trim=%trimcap%
set /a lagcompcooldown=%lagcompcooldowncfg%
rem nircmd.exe beep 1000 100
)

if %lagcompcooldown% LEQ 0 (
if %lrmcount% GTR %lrmcapminp1% (
set /a lrmcount=%lrmcount%-1
set /a lagcompcooldown=%lagcompcooldowncfg%
) else (
if %lrmcount% GTR %lrmcapmin% (
set /a lrmcount=%lrmcount%-1
)
)
)

set /a nircmdtimer=(%timer%*1000)-%trim%
if %count4% GEQ %usc% echo %count4% >count.th

if %count4% GEQ %restarttime% (
call %~n0
)

set /a secsuntildel=%hrsuntildel%*3600
set /a delamt=%avehis%/%timer%
set /a delamtnomul=%avehisnomul%/%timer%
set /a delqty=%secsuntildel%/%timer%
if %delpriorpost% == 0 set /a delqty=%delqty%-%delamtnomul%
set /a sizebef=(%delqty%*%average%)/1024
if %sizebef% GEQ 10240 (
set sizetxt=GB
set /a sizein=%sizebef%/1024
) else (
set sizetxt=MB
set /a sizein=%sizebef%
)

if %showhidetemp% NEQ %showhide% nircmd.exe win %showhide% ititle %~n0
set showhidetemp=%showhide%
for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\screenshots" ^| find /v /c ""') do set files=%%i
cls
echo %version%
echo.
if %deldurbef% == 0 (
echo Deleting **on boot** when %delqty% screenshots are reached: %delamt%
) else if %deldurbef% == 1 (
echo Deleting **during computer use** when %delqty% screenshots are reached: %delamt%
) else if %deldurbef% == 2 (
echo Deleting **during computer use recursively** when %delqty% screenshots are reached: %delamt%
)
echo.
echo %filetype% number:
echo %count%
echo.
echo Saved screenshots:
echo %files%
echo.
echo Max script size:
echo %sizein%%sizetxt%
echo.
echo Trim:%trim%	Taken:%sumtrimscreeny%	Target:%lrmcountplustimer%
echo Comp:%lrmcount%	Cooldown:%lagcompcooldown% 
echo.
echo Screenshot type:
echo %filetype%

if %pastefirstoutput% == 1 (
if not exist pasteoutputs mkdir pasteoutputs
set /a pastefirstoutput=0
cd pasteoutputs
echo %version% >>pasteoutput%screeny%.txt
echo. >>pasteoutput%screeny%.txt
if %deldurbef% == 0 (echo Deleting **on boot** when %delqty% screenshots are reached: %delamt% >>pasteoutput%screeny%.txt)
if %deldurbef% == 1 (echo Deleting **during computer use** when %delqty% screenshots are reached: %delamt% >>pasteoutput%screeny%.txt)
if %deldurbef% == 2 (echo Deleting **during computer use recursively** when %delqty% screenshots are reached: %delamt% >>pasteoutput%screeny%.txt)
echo. >>pasteoutput%screeny%.txt
echo %filetype% number: >>pasteoutput%screeny%.txt
echo %count% >>pasteoutput%screeny%.txt
echo. >>pasteoutput%screeny%.txt
echo Saved screenshots: >>pasteoutput%screeny%.txt
echo %files% >>pasteoutput%screeny%.txt
echo. >>pasteoutput%screeny%.txt
echo Max script size: >>pasteoutput%screeny%.txt
echo %sizein%%sizetxt% >>pasteoutput%screeny%.txt
echo. >>pasteoutput%screeny%.txt
echo Trim:%trim%	Taken:%sumtrimscreeny%	Target:%lrmcountplustimer% >>pasteoutput%screeny%.txt
echo Comp:%lrmcount%	Cooldown:%lagcompcooldown%  >>pasteoutput%screeny%.txt
echo. >>pasteoutput%screeny%.txt
echo Screenshot type: >>pasteoutput%screeny%.txt
echo %filetype% >>pasteoutput%screeny%.txt
start notepad.exe pasteoutput%screeny%.txt
cd..
)



for /f "tokens=2 delims=:" %%a in ('findstr "deltxt:" "del.th"') do set /a deltxt=%%a

set /a trimscreenyold=%trimscreenynew%

if %deltxt% == 2 goto lrmskip

if %deltxt% == 3 (
attrib -h del.th
timeout 1 /nobreak > NUL
echo deltxt:0 >del.th
timeout 1 /nobreak > NUL
attrib +h del.th
goto loopd
)

if %deldurbef% == 0 (
if %count4% NEQ 0 goto lrmskip
)

:loopd:
if not exist del.th (
echo deltxt:0 >del.th
attrib +h del.th
timeout 1 /nobreak > NUL
)
for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\screenshots" ^| find /v /c ""') do set files=%%i
for /f "tokens=2 delims=:" %%a in ('findstr "deltxt:" "del.th"') do set /a deltxt=%%a
if %files% LEQ %delqty% goto lrmskip
if %deltxt% == 0 (
start delete.bat %delamt% %delqty%
echo.
echo Initiating deletion
)
goto lrmskip
