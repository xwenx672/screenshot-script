@echo off
for /f "delims=" %%A in ('powershell -command "Invoke-RestMethod 'https://raw.githubusercontent.com/xwenx672/screenshot-script/refs/heads/currentversionvalue/version.txt'"') do (
    set "version=%%A"
)
echo %version%

powershell -Command "try { Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/xwenx672/screenshot-script/refs/heads/currentversionvalue/version.txt' -UseBasicParsing -TimeoutSec 5 | Out-Null; exit 0 } catch { exit 1 }"
if %errorlevel%==0 (
    echo File is reachable.
) else (
    echo File is NOT reachable.
)

powershell -Command "try { Invoke-WebRequest -Uri 'https://github.com/xwenx672/screenshot-script/archive/refs/heads/main.zip' -UseBasicParsing -TimeoutSec 5 | Out-Null; exit 0 } catch { exit 1 }"
if %errorlevel%==0 (
    echo File is reachable.
) else (
    echo File is NOT reachable.
)



pause