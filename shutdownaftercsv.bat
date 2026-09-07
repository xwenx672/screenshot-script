@echo off
set "batdir=%~dp0"
pushd "%batdir%"
:loop:
timeout 1 /nobreak > NUL
cls
echo is there
if exist rundel*.th goto loop
shutdown /s /t 120
exit