@echo off
rem title %~n0
rem echo 'ERROR' or 'MISSING OPERATOR' text is normal.
rem echo ########################################
set /a countexit=0
echo.
setlocal EnableDelayedExpansion
set batdir=%~dp0
pushd "%batdir%"
set delamt=nothing
set delqty=nothing
set /a delamt=%1
set /a delqty=%2
cls 
if %delamt% == nothing (
echo It is assumed this script was started not from the main script.
echo To do so manually, create a text file in the same directory as the delete.bat called '9.txt'.
timeout 10 /nobreak > NUL
exit
)
if %delqty% == nothing (
echo It is assumed this script was started not from the main script.
echo To do so manually, create a text file in the same directory as the delete.bat called '9.txt'.
timeout 10 /nobreak > NUL
exit
)
rem echo Sorting del value...
rem attrib -h del.th
rem echo deltxt:1 >del.th
rem attrib +h del.th

for /f "tokens=2 delims=:" %%a in ('findstr "maxagedfiles:" "config.cfg"') do set maxagedfiles=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "ran:" "config.cfg"') do set ran=%%a

echo Daydeleting screenshots older than %maxagedfiles% days...

timeout 1 /nobreak > NUL

forfiles /p "screenshots" /s /m *.* /d -%maxagedfiles% /c "cmd /c echo Deleting @file! && del @path"
rem cls
echo.
echo Done Daydeleting
echo ########################################
echo.
echo.
rem cls





set /a count2=0
set /a targetscreenshot=0
set /a balance=1
set /a z=0
set /a twist=1
echo Deleting %delamt% screenshots if stored screenshots are ^> %delqty%...
echo.
for /f "delims=" %%i in ('dir /a-d /w /b "%cd%\screenshots" ^| find /v /c ""') do set files=%%i
rem echo Finding oldest screenshot...
for /f "delims=_" %%a in ('dir /b /a-d /o:-d "%batdir%screenshots\*_*.*"') do set "count=%%a"
set /a countold=%count%
for /f "delims=_" %%a in ('dir /b /a-d /o:d "%batdir%screenshots\*_*.*"') do set "countnew=%%a"

timeout 2 /nobreak > NUL

if %files% LSS %delqty% goto end




if %ran% == 0 goto loopstandard
echo Deleting randomly...


powershell -ExecutionPolicy Bypass -File "%batdir%ps.ps1" -progValue 2 -targetFolder "%batdir%screenshots" -startValue "%countold%" -endValue "%countnew%" -delValue "%delamt%"
goto end


:loopstandard:
if exist "%batdir%screenshots\%count%*" (
del "%batdir%screenshots\%count%*"
echo Deleting %count% %count2% / %delamt%
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

if %count2% LEQ %delamt% goto loopstandard
:end:

rem cls
echo Done Deleting
echo ########################################
echo.
echo.

rem COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS 
echo Starting compression if required...
set /a count=2000010000
set /a count2=0
set /a valcount=0
set /a count10=0
set /a "screenysize=0"
if exist cput.th (
set /p cput=<cput.th
timeout 2 /nobreak > NUL
) else (
set /a cput=500
echo 500 > cput.th
)
for /f "tokens=2 delims=:" %%a in ('findstr "compressfilesizemin:" "config.cfg"') do set /a compressfilesizemin=%%a
set /a compressfilesizemin=%compressfilesizemin%*1000
for /f "tokens=2 delims=:" %%a in ('findstr "compresscooloff:" "config.cfg"') do set /a compresscooloff=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compressmultithread:" "config.cfg"') do set /a compressmultithread=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compresssizetrigger:" "config.cfg"') do set /a compresssizetrigger=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compressquality:" "config.cfg"') do set /a compressquality=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compsd:" "config.cfg"') do set /a cpulim=%%a

rem echo Finding oldest screenshot...
for /f "delims=_" %%a in ('dir /b /a-d /o:-d "%batdir%screenshots\*_*.*"') do set "count=%%a"
rem cls

rem echo Checking for compressed folder...

set /a count2=0
set /a sizeMBA=0
set /a sizeMBB=0
set /a sizeMB=0


for /f %%A in ('powershell -command "[math]::Floor((Get-ChildItem -Path 'screenshots' -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB)"') do set /a sizeMBA=%%A
if exist compressed for /f %%A in ('powershell -command "[math]::Floor((Get-ChildItem -Path 'compressed' -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB)"') do set /a sizeMBB=%%A > NUL
set /a sizeMB=%sizeMBA%+%sizeMBB%
rem cls
echo Compressing screenshots over %compressfilesizemin%B
echo When screenshots folder ^(%sizeMB%MB^) ^> %compresssizetrigger%MB
echo.

if %sizeMB% LSS %compresssizetrigger% (
goto cannotcompress
)



echo Launching cpuload checker...
if not exist compress.th echo. > compress.th
start "" /B cpuload.bat

:loopc:
for /f "tokens=2 delims=:" %%a in ('findstr "compresscooloff:" "config.cfg"') do set /a compresscooloff=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compressmultithread:" "config.cfg"') do set /a compressmultithread=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compresssizetrigger:" "config.cfg"') do set /a compresssizetrigger=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compressquality:" "config.cfg"') do set /a compressquality=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compsd:" "config.cfg"') do set /a cpulim=%%a

if exist "%batdir%compressed\*.*" (
powershell -ExecutionPolicy Bypass -File "%batdir%ps.ps1" -progValue 1 -targetFolder "%batdir%compressed"
timeout 2 /nobreak > NUL
move "%batdir%compressed\*.*" "%batdir%screenshots\" > NUL
timeout 2 /nobreak > NUL
)

rem echo Compress trigger: %compressfilesizemin%


set /a count2=0
set /a sizeMBA=0
set /a sizeMBB=0
set /a sizeMB=0

for /f %%A in ('powershell -command "[math]::Floor((Get-ChildItem -Path 'screenshots' -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB)"') do set /a sizeMBA=%%A
if exist compressed for /f %%A in ('powershell -command "[math]::Floor((Get-ChildItem -Path 'compressed' -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB)"') do set /a sizeMBB=%%A > NUL
set /a sizeMB=%sizeMBA%+%sizeMBB%

rem cls


rem echo Size of folder: %sizeMB%

if %sizeMB% GTR %compresssizetrigger% (
if not exist compressed mkdir compressed
echo Compressing screenshots over %compressfilesizemin%B
echo When screenshots folder ^(%sizeMB%MB^) ^> %compresssizetrigger%MB
if %compresscooloff% GTR 0 timeout %compresscooloff% >nul
goto loopcompression
)

:cannotcompress:
:nevercompressed:
set /a sizeMBB=0
if exist compressed for /f %%A in ('powershell -command "[math]::Floor((Get-ChildItem -Path 'compressed' -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB)"') do set /a sizeMBB=%%A > NUL
if %sizeMBB% GTR 1 (
powershell -ExecutionPolicy Bypass -File "%batdir%ps.ps1" -progValue 1 -targetFolder "%batdir%compressed"
timeout 2 /nobreak > NUL
move "%batdir%compressed\*.*" "%batdir%screenshots\" > NUL
timeout 2 /nobreak > NUL
)
rem attrib -h del.th
rem timeout 1 /nobreak > NUL
rem echo deltxt:0 >del.th
rem timeout 1 /nobreak > NUL
rem attrib +h del.th
rem timeout 1 /nobreak > NUL

if exist compressed rmdir compressed

if exist compress.th del compress.th

rem cls
echo.
echo Done Compressing
echo ########################################
echo.
echo.
echo Starting Data Record Function
echo ########################################
echo.

rem if exist howMany.bat start "" /B howMany.bat
goto datarecord
rem timeout 5 /nobreak > NUL



:loopcompression:
if exist 1 (
set /a count=1
del 1
)

if not exist "%batdir%screenshots\%count%*" (
set /a screenysize=0
goto notexist
)
set countexit=0
for %%F in ("%batdir%screenshots\%count%*") do (
set /a "screenysize=%%~zF"
if %%~zF GTR %compressfilesizemin% (
start "" /B "%batdir%convert" "%%F" -quality %compressquality% -strip -sharpen 0x0.5 -noise 1 "%batdir%compressed\%%~nxF"
)
)
if %cpulim% LSS 100 (
set /p compsd= < cput.th
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
rem goto skipnoexist
:notexist:
rem echo %count% Does not exist
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
echo Cannot compress further
echo Lowering compressfilesizemin value by 20%% 
set /a cfsmm=%compressfilesizemin%/5
echo %cfsmm%
echo %compressfilesizemin%
set /a compressfilesizemin-=%cfsmm%
set /a count=0
set /a count2=2147483647
set /a count3=0
)
if %screenysize% GTR %compressfilesizemin% (
echo %count% %count2%/%compressmultithread% 
set /a count3=0
)





if %count2% GEQ %compressmultithread% goto loopc


goto loopcompression
rem COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS COMPRESS 




rem DATARECORD DATARECORD DATARECORD DATARECORD DATARECORD DATARECORD DATARECORD DATARECORD 



:datarecord:

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

if exist "temp.tmp" del "temp.tmp"
for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set dt=%%a
set screeny=%dt:~0,8%-%dt:~8,6%
if exist "history\%screeny%screeny.th" goto skipscreenycreation
rem del "history\%screeny%screeny.th"
rem -%dt:~8,6%
rem set "SORTED=%screeny%-ori.th"
setlocal enabledelayedexpansion
powershell -ExecutionPolicy Bypass -File "%batdir%ps.ps1" -progValue 0 -targetFolder "%batdir%screenshots" -csvPath "%cd%\temp.tmp"

sort temp.tmp>> %screeny%-ori.th

del temp.tmp


set "currentDate="

for /f %%D in (%screeny%-ori.th) do (
    set "fileDate=%%D"
    if "!fileDate!"=="!currentDate!" (
        set /a count+=1
    ) else (
        if defined currentDate (
            echo !currentDate!:!count!>> %screeny%screeny.th
        )
        set "currentDate=!fileDate!"
        set count=1
    )
)


if defined currentDate (
    echo !currentDate!:!count!>> %screeny%screeny.th
)
:skipscreenycreation:
if exist val.th del val.th
if exist val2.th del val2.th
if exist val3.th del val3.th
if exist fileOrder.th del fileOrder.th
if exist ScreenshotCountUp.csv del ScreenshotCountUp.csv


if not exist history (
mkdir history
timeout 2 /nobreak > NUL
)
if exist "%screeny%screeny.th" move "%screeny%screeny.th" "history\%screeny%screeny.th" > NUL

set "currentDate="


for %%F in (history\*) do (
    set "fileDate=%%~nF"
    set "fileDate=!fileDate:~0,8!!fileDate:~8,7!"
	echo !fileDate!>> val.th
)

sort /R val.th>> fileOrder.th

for /f %%F in (fileOrder.th) do (
    set concatFileDate=!concatFileDate!%%F,
)
echo Date of Screenshot\Date of Count,%concatFileDate%>> ScreenshotCountUp.csv
if exist val.th del val.th
if exist val2.th del val2.th
if exist val3.th del val3.th

for %%F in (history\*) do (
	for /f "usebackq tokens=1 delims=:" %%A in ("%%F") do (
		echo %%A>> val.th
	)
)

sort val.th>> val2.th
if exist val.th del val.th
set "currentDate="
set "oldDate="
for /f "usebackq tokens=1 delims=:" %%A in ("val2.th") do (
	set "currentDate=%%A"
	if !currentDate! NEQ !oldDate! (
		echo %%A>> val3.th
	)
	set "oldDate=%%A"
)
if exist val.th del val.th

sort /R val3.th>> val.th
if exist val3.th del val3.th

set "searchFile="
set "dateo="
set "valo="
set "concatValoData="

for /f %%F in (val.th) do (
	set "searchTerm=%%F"
	set "concatValoData="
	for /f %%G in (fileOrder.th) do (
		set "searchFile=!batdir!history\%%Gscreeny.th"
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
	echo !searchTerm!,!concatValoData!>> ScreenshotCountUp.csv
)

if exist fileOrder.th del fileOrder.th
if exist *-ori.th del *-ori.th
if exist temp.tmp del temp.tmp
if exist *screeny.th del *screeny.th
if exist val.th del val.th
if exist val2.th del val2.th
if exist val3.th del val3.th


echo.
echo Completed Data Record Function
echo ########################################
echo.
timeout 2 /nobreak > NUL
echo.
echo Completed screenshot management Closing
echo ########################################
timeout 5 /nobreak > NUL
exit