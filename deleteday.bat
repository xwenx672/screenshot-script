@echo off
rem title %~n0
set batdir=%~dp0
pushd "%batdir%"

echo Sorting del value...
attrib -h del.th
echo deltxt:2 >del.th
attrib +h del.th

rem echo Checking if to show or hide...
rem for /f "tokens=2 delims=:" %%a in ('findstr "showhidedel:" "config.cfg"') do set showhidedel=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "maxagedfiles:" "config.cfg"') do set maxagedfiles=%%a

echo Checking errorlevel...
rem set /a maxagedfiles=%1
if %errorlevel% NEQ 0 exit
set /a count2=0

rem echo Enacting show or hide...
rem nircmd.exe win %showhidedel% ititle %~n0

echo Deleting oldest screenshots...
rem forfiles /p "screenshots" /s /m *.* /d -%maxagedfiles% /c "cmd /c del @path"
rem powershell -Command "& {Get-ChildItem 'screenshots' -File -Recurse | ForEach-Object { $_.LastWriteTime = $_.CreationTime }}"
forfiles /p "screenshots" /s /m *.* /d -%maxagedfiles% /c "cmd /c echo Deleting @file! && del @path"


echo Done Day Deleting!
timeout 1 /nobreak > NUL
attrib -h del.th
timeout 1 /nobreak > NUL
echo deltxt:3 >del.th
timeout 1 /nobreak > NUL
attrib +h del.th
timeout 1 /nobreak > NUL
for /f "tokens=2 delims=:" %%a in ('findstr "compressfilesizemin:" "config.cfg"') do set /a compressfilesizemin=%%a
set /a compressfilesizemin=%compressfilesizemin%*1000
set /a sizeMBA=0
set /a sizeMBB=0
set /a sizeMB=0
for /f %%A in ('powershell -command "(Get-ChildItem -Path 'screenshots' -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB"') do set /a sizeMBA=%%A
rem for /f %%A in ('powershell -command "(Get-ChildItem -Path 'compressed' -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB"') do set /a sizeMBB=%%A
set /a sizeMB=%sizeMBA%+%sizeMBB%
if exist "%batdir%compressed" compress.bat
if %sizeMB% GTR %compresssizetrigger% compress.bat
exit