@echo off
setlocal enabledelayedexpansion
:loop:
rem Define the range
set /a min=190000
set /a max=295000
set /a range=max - min + 1

rem Generate random number in range
set /a rnd=%random% * 32768 + %random%
set /a number=min + (rnd %% range)

echo Random number between %min% and %max%: !number!
nircmd.exe wait 100
goto loop