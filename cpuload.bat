@echo off
set "batdir=%~dp0"
pushd "%batdir%"
set cpurma=0
set cpurms=0
set cpurm=0
set equal=0
set more=0
set less=0
if exist cput.th (
set /p cput=<cput.th
timeout 2 /nobreak > NUL
) else (
set /a cput=500
echo 500 > cput.th
timeout 2 /nobreak > NUL
)
:loop:
rem timeout 1 /nobreak > NUL
for /f "tokens=2 delims=:" %%a in ('findstr "timer:" "config.cfg"') do set /a timer=%%a
for /f "tokens=2 delims=:" %%a in ('findstr "compsd:" "config.cfg"') do set /a cpulim=%%a

set cpul=nothing
for /f "tokens=2 delims== " %%C in ('wmic cpu get loadpercentage /value') do set /a cpul=%%C
set /a trimcaphalf=%timer%*500
if not exist compress.th exit
if %cpul% == nothing goto loop


if %cpul% GEQ %cpulim% (
if %cpurma% LSS 1 set cpurm=0
if %more% LSS 100 set /a more+=1
if %less% GTR 0 set /a less-=1
set /a cpurma+=1
set /a cpurm+=%cpurma%
set /a cpurms=0
)

if %cpul% LEQ %cpulim% (
if %cpurms% LSS 1 set cpurm=0
if %less% LSS 100 set /a less+=1
if %more% GTR 0 set /a more-=1
set /a cpurms+=1
set /a cpurm-=%cpurms%
set /a cpurma=0
)


set /a cput+=%cpurm%
if %cput% GTR %trimcaphalf% (
set /a cput=%trimcaphalf%
set /a cpurm=0
)
if %cput% LSS 1 (
set /a cpurm=0
set /a cput=0
)


echo CPU %% / Pause / Sway / Legato / Allegro
echo %cpul%   /  %cput%  /  %cpurm%  /  %more%  /  %less%
echo %cput% > cput.th
goto loop
