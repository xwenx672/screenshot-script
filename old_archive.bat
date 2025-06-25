@echo off
setlocal EnableDelayedExpansion
title %~n0
set batdir=%~dp0
pushd "%batdir%"

if exist lastrun.txt (
set /p lastrun=<lastrun.txt
timeout 1 /nobreak > NUL
) else (
set lastrun=1
)

if %lastrun% == %date% exit

rem if not exist biasvalue.txt (
rem echo 100> biasvalue.txt
rem )
if exist fileshis.th (
set /p fileshis=<fileshis.th
) else (
set /a fileshis=100
)
for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\old_archive" ^| find /v /c ""') do set files=%%i
if %files% GEQ %fileshis% (
powershell -ExecutionPolicy Bypass -File "%batdir%ps.ps1" -progValue 1 -targetFolder "%batdir%old_archive"
)
timeout 1 /nobreak > NUL

set /a biasval=%files%/200
if %biasval% LSS 1000 set /a biasval=1000


rem set /p biasval=<biasvalue.txt


rem set /a biasval=(%biasval%*101)/100

rem echo %biasval%




rem timeout 2 /nobreak > NUL
rem for /f "delims=_" %%a in ('dir /b /a-d /o:d "%batdir%old_archive\*"') do set "countold=%%a"
rem for /f "delims=_" %%a in ('dir /b /a-d /o:-d "%batdir%old_archive\*"') do set "countnew=%%a"



set d=0
rem set /a low=353000
set /a low=0
rem set /a high=1830000
set /a high=2147483647
set count3=0
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

set /a count3=0
set /a countold=%low%
goto countingnew
:concountingold:
if %count3% LSS -2000000000 set /a count3=10000000
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
if %count3% LSS -2000000000 set /a count3=10000000
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

powershell -ExecutionPolicy Bypass -File "%batdir%ps.ps1" -progValue 2 -targetFolder "%batdir%old_archive" -startValue "%countold%" -endValue "%countnew%" -delValue "%biasval%"
echo %date%>lastrun.txt

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
powershell -ExecutionPolicy Bypass -File "%batdir%ps.ps1" -progValue 0 -targetFolder "%batdir%old_archive" -csvPath "%cd%\vali1.th"

sort vali1.th>> vali2.th


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


for %%F in (historyarchive\*) do (
    set "fileDate=%%~nF"
    set "fileDate=!fileDate:~0,8!!fileDate:~8,7!"
	echo !fileDate!>> vali3.th
)

sort /R vali3.th>> vali4.th

for /f %%F in (vali4.th) do (
    set concatFileDate=!concatFileDate!%%F,
)
echo Date of Screenshot\Date of Count,%concatFileDate%>> ScreenshotCountUpArchive.csv

for %%F in (historyarchive\*) do (
	for /f "usebackq tokens=1 delims=:" %%A in ("%%F") do (
		echo %%A>> vali5.th
	)
)

sort vali5.th>> vali6.th

set "currentDate="
set "oldDate="
for /f "usebackq tokens=1 delims=:" %%A in ("vali6.th") do (
	set "currentDate=%%A"
	if !currentDate! NEQ !oldDate! (
		echo %%A>> vali7.th
	)
	set "oldDate=%%A"
)

sort /R vali7.th>> vali8.th


set "searchFile="
set "dateo="
set "valo="
set "concatValoData="

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
