@echo off
setlocal EnableDelayedExpansion
title %~n0
set batdir=%~dp0
pushd "%batdir%"
set /a findrange=0


if exist uppervalue.txt (
echo uppervalue.txt does exist
set /p uppervalue=<uppervalue.txt
) else (
set /a findrange=0
echo uppervalue.txt does NOT exist
)

if exist lowervalue.txt (
echo lowervalue.txt does exist
set /p lowervalue=<lowervalue.txt
) else (
set /a findrange=0
echo lowervalue.txt does NOT exist
)
echo.

:loop:


for /f %%A in ('powershell -command "(Get-Date).DayOfYear"') do set /a doy=%%A

if exist lastrun.txt (
set /p lastrun=<lastrun.txt
timeout 1 /nobreak > NUL
) else (
set /a lastrun=%doy%
echo %doy%>lastrun.txt
)




if exist fileshis.th (
set /p fileshis=<fileshis.th
) else (
set /a fileshis=100
)
for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\old_archive" ^| find /v /c ""') do set files=%%i
rem nircmd.exe win hide ititle %~n0
if %doy% == 0 set /a lastrun=-1 
if %lastrun% GEQ %doy% (
echo %lastrun% GEQ %doy% = TRUE
timeout 10
exit
)

if exist lastrunsearch.txt (
echo lastrunsearch.txt DOES exist
set /p lastrunsearch=<lastrunsearch.txt
timeout 2 /nobreak > NUL
set /a lastrunsearch-=1
set /a findrange=1
) else (
echo lastrunsearch.txt DOES NOT exist
set /a findrange=0
set /a lastrunsearch=10
timeout 1 /nobreak > NUL
)

if %lastrunsearch% LEQ 0 (
echo lastrunsearch LEQ 0 IS true: %lastrunsearch%
set /a findrange=0
set /a lastrunsearch=100
timeout 1 /nobreak > NUL
) else (
echo lastrunsearch LEQ 0 NOT true: %lastrunsearch%
)
echo %lastrunsearch%>lastrunsearch.txt
echo lastrunsearch=%lastrunsearch%



if %files% GTR %fileshis% (
powershell -ExecutionPolicy Bypass -File "%batdir%ps.ps1" -progValue 1 -targetFolder "%batdir%old_archive"
set /a findrange=0
) else (
set /a findrange=1
)
timeout 1 /nobreak > NUL
echo lowervalue=%lowervalue%
echo uppervalue=%uppervalue%
echo findrange=%findrange%
set /a biasval=(%files%/100)
if %biasval% LSS 1000 set /a biasval=1000



if %findrange% NEQ 0 goto endcounting




set d=0
set /a low=0
set /a high=2147483647
set count3=0
nircmd.exe win setsize title %~n0 0 0 650 450
:countingold:
echo %low% %count3%
if not exist %batdir%old_archive\%low%_* goto concountingold
if %count3% GTR 10000 (
set /a low-=10000
set /a count3=-5000
goto countingold
)
if %count3% GTR 1000 (
set /a low-=1000
set /a count3=-500
goto countingold
)

set /a count3=0
set /a countold=%low%
echo %low% > lowervalue.txt
goto countingnew
:concountingold:
if %count3% LSS -2000000000 set /a count3=10000000
if %count3% LEQ 1000 (
set /a low+=1
set /a count3+=1
) else (
if %count3% LEQ 10000 (
set /a low+=10
set /a count3+=10
) else (
if %count3% LEQ 100000 (
set /a low+=100
set /a count3+=100
) else (
if %count3% LEQ 1000000 (
set /a low+=1000
set /a count3+=1000
) else (
set /a low+=10000
set /a count3+=1
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
if %count3% GTR 10000 (
set /a high+=10000
set /a count3=-5000
goto countingnew
)
if %count3% GTR 1000 (
set /a high+=1000
set /a count3=-500
goto countingnew
)

set /a countnew=%high%
echo %high% > uppervalue.txt
goto endcounting
:concountingnew:
if %count3% LSS -2000000000 set /a count3=10000000
if %count3% LEQ 1000 (
set /a high-=1
set /a count3+=1
) else (
if %count3% LEQ 10000 (
set /a high-=10
set /a count3+=10
) else (
if %count3% LEQ 100000 (
set /a high-=100
set /a count3+=100
) else (
if %count3% LEQ 1000000 (
set /a high-=1000
set /a count3+=1000
) else (
set /a high-=10000
set /a count3+=1
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
set /a countold=%lowervalue%
set /a countnew=%uppervalue%
rem set findrange=1
powershell -ExecutionPolicy Bypass -File "%batdir%ps.ps1" -progValue 2 -targetFolder "%batdir%old_archive" -startValue "%countold%" -endValue "%countnew%" -delValue "%biasval%"
set /a newval=%lastrun%+1
echo %newval%>lastrun.txt

if %newval% LSS %doy% goto loop
:datarecord:
if not exist historyarchive (
mkdir historyarchive
timeout 2 /nobreak > NUL
)

rem vali1.th Lists each screenshot's date.
rem vali2.th vali1.th sorted in assending order.
rem vali3.th A list of all files currently in history.
rem vali4.th vali3.th sorted in desending order.
rem vali5.th A list of all dates mentioned in the files in history.
rem vali6.th vali5.th sorted in asending order.
rem vali7.th vali6.th with no duplicates.
rem vali8.th vali7.th with desending order.

set "dt="
set "screeny="
set "currentDate="
set "fileDate="
set "count="
set "concatFileDate="
set "searchFile="
set "valo="
set "concatValoData="
set "oldDate="
set "searchTerm="
set "dateo="
if exist vali1.th del vali1.th
if exist vali2.th del vali2.th
if exist vali3.th del vali3.th
if exist vali4.th del vali4.th
if exist vali5.th del vali5.th
if exist vali6.th del vali6.th
if exist vali7.th del vali7.th
if exist vali8.th del vali8.th

for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set dt=%%a
set screeny=%dt:~0,8%-%dt:~8,6%
if exist "historyarchive\%screeny%screenyarchive.th" goto skipscreenycreation

rem del "historyarchive\%screeny%screeny.th"
rem -%dt:~8,6%
rem set "SORTED=%screeny%-ori.th"

setlocal enabledelayedexpansion
echo Making vali1.th
powershell -ExecutionPolicy Bypass -File "%batdir%ps.ps1" -progValue 0 -targetFolder "%batdir%old_archive" -csvPath "%cd%\vali1.th"
echo Made vali1.th

echo Making vali2.th
sort vali1.th>> vali2.th
echo Made vali2.th

set "currentDate="

for /f %%D in (vali2.th) do (
    set "fileDate=%%D"
    if "!fileDate!"=="!currentDate!" (
        set /a count+=1
    ) else (
        if defined currentDate (
            echo !currentDate!:!count!>> %screeny%screenyarchive.th
        )
        set "currentDate=!fileDate!"
        set count=1
    )
)


if defined currentDate (
    echo !currentDate!:!count!>> %screeny%screenyarchive.th
)
:skipscreenycreation:
if exist ScreenshotCountUpArchive.csv del ScreenshotCountUpArchive.csv


if exist "%screeny%screenyarchive.th" move "%screeny%screenyarchive.th" "historyarchive\%screeny%screenyarchive.th" > NUL

set "currentDate="

echo Making vali3.th
for %%F in (historyarchive\*) do (
    set "fileDate=%%~nF"
    set "fileDate=!fileDate:~0,8!!fileDate:~8,7!"
	echo !fileDate!>> vali3.th
)
echo Made vali3.th

echo Making vali4.th
sort /R vali3.th>> vali4.th
echo Made vali4.th

for /f %%F in (vali4.th) do (
    set concatFileDate=!concatFileDate!%%F,
)
echo Date of Screenshot\Date of Count,%concatFileDate%>> ScreenshotCountUpArchive.csv

echo Making vali5.th
for %%F in (historyarchive\*) do (
	for /f "usebackq tokens=1 delims=:" %%A in ("%%F") do (
		echo %%A>> vali5.th
	)
)
echo Made vali5.th

echo Making vali6.th
sort vali5.th>> vali6.th
echo Made vali6.th

echo Making vali7.th
set "currentDate="
set "oldDate="
for /f "usebackq tokens=1 delims=:" %%A in ("vali6.th") do (
	set "currentDate=%%A"
	if !currentDate! NEQ !oldDate! (
		echo %%A>> vali7.th
	)
	set "oldDate=%%A"
)
echo Made vali7.th

echo Making vali8.th
sort /R vali7.th>> vali8.th
echo Made vali8.th

set "searchFile="
set "dateo="
set "valo="
set "concatValoData="
echo Making csv
for /f %%F in (vali8.th) do (
	set "searchTerm=%%F"
	set "concatValoData="
	for /f %%G in (vali4.th) do (
		set "searchFile=!batdir!historyarchive\%%Gscreenyarchive.th"
		set fm=0
		for /f "usebackq tokens=1,2 delims=:" %%A in (!searchFile!) do (
			set "dateo=%%A"
			set "valo=%%B"
			if !dateo! == !searchTerm! (
				set "concatValoData=!concatValoData!!valo!,"
				set fm=1
			)
		)
		if !fm! == 0 (
			set "concatValoData=!concatValoData!0,"
		)
	)
	echo !searchTerm!,!concatValoData!>> ScreenshotCountUpArchive.csv
)
echo Made csv
if exist vali1.th del vali1.th
if exist vali2.th del vali2.th
if exist vali3.th del vali3.th
if exist vali4.th del vali4.th
if exist vali5.th del vali5.th
if exist vali6.th del vali6.th
if exist vali7.th del vali7.th
if exist vali8.th del vali8.th
echo done

for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\old_archive" ^| find /v /c ""') do set files=%%i
echo %files% > fileshis.th

exit
exit
exit
exit
exit
exit
exit




rem RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH
rem for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set dt=%%a
rem set day=%dt:~6,2%
rem set month=%dt:~4,2%*
rem set year=%dt:~0,4%
rem RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH RUBBISH
