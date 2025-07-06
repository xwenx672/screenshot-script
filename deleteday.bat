@echo off
title %~n0
set batdir=%~dp0
pushd "%batdir%"

echo Sorting del value...
attrib -h del.th
echo deltxt:2 >del.th
attrib +h del.th

echo Checking if to show or hide...
for /f "tokens=2 delims=:" %%a in ('findstr "showhidedel:" "config.cfg"') do set showhidedel=%%a



echo Checking errorlevel...
set /a maxagedfiles=%1
if %errorlevel% NEQ 0 exit
set /a count2=0

echo Enacting show or hide...
nircmd.exe win %showhidedel% ititle %~n0

echo Deleting oldest screenshots...
rem forfiles /p "screenshots" /s /m *.* /d -%maxagedfiles% /c "cmd /c del @path"
forfiles /p "screenshots" /s /m *.* /d -%maxagedfiles% /c "cmd /c echo Deleting @file! && del @path"


echo Done Day Deleting!
timeout 1 /nobreak > NUL
attrib -h del.th
timeout 1 /nobreak > NUL
echo deltxt:3 >del.th
timeout 1 /nobreak > NUL
attrib +h del.th
timeout 1 /nobreak > NUL
exit