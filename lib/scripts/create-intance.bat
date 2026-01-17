@echo off
setlocal EnableDelayedExpansion
cls
echo Creating batch.
REM ---- Variables (example) ----

set "INST_DIR=%INST_DIR%"
set "BIND_IP=%BIND_IP%"
set "NG_EXE=%NGINX_EXE:\=/%"
set "NG_CONF=%NGINX_CONF:\=/%"
set "NG_DIR=%NGINX_DIR:\=/%"

REM ---- Create folder if not exists ----
if not exist "%INST_DIR%" mkdir "%INST_DIR%"

REM ---- Banner (PowerShell) ----
REM ---- Banner (PowerShell) ----




REM ---- Generate HTTPS batch ----
if /i "%USE_SSL%"=="Y" (
    set "HTTPS_BAT=%INST_DIR%\https.bat"
    (
    echo @echo off
    echo REM ---- HTTPS PHP + Nginx ----
    echo set "BIND_IP=%BIND_IP%"
    echo set "PORT=%PORT%"
    echo set "PHP_DIR=%PHP_DIR%"
    echo set "NGINX_DIR=%NGINX_DIR%"
    echo set "NGINX_EXE=%NGINX_EXE%"
    echo set "NGINX_CONF=%INST_DIR%"
    echo set "PROJECT_DIR=%PROJECT_DIR%"
    echo.
    echo REM ---- Stop any existing nginx ----
    echo taskkill /IM nginx.exe /F >nul 2^>^&1
    echo.
        echo PowerShell -NoProfile -Command "Write-Host ' _____  _   _      _ ____   _   _ ' -ForegroundColor Cyan; Write-Host '^| ____|| \ | |    | ||_ _| | \ | |' -ForegroundColor Cyan; Write-Host '^|  _|  |  \| | _  | | | |  |  \| |' -ForegroundColor Cyan; Write-Host '^| |___ | |\  || |_| | | |  | |\  |' -ForegroundColor Cyan; Write-Host '^|_____||_| \_| \___/ |___| |_| \_|' -ForegroundColor Cyan"
 echo .
    echo REM ---- Start php-cgi ----
     IF "%PORT%" == 80 (
        echo start "PHP-CGI" cmd /k "%PHP_DIR%php-cgi.exe -b %HOST%:%PORT%"
    ) else (
         echo start "PHP-CGI" cmd /k "%PHP_DIR%php-cgi.exe -b %HOST%:%PORT%"
    )

    echo.
    echo REM ---- Start nginx ----
    echo pushd "%NGINX_DIR%"
    echo start "NGINX" cmd /k "%NGINX_EXE% -c %NGINX_CONF%"
    echo popd
    echo.
    echo echo PHP-CGI and Nginx started. Press Ctrl+C to stop.
    echo.
 
    ) > "!HTTPS_BAT!"
    echo [INFO] HTTPS batch created: !HTTPS_BAT!
) else (
    REM ---- Generate HTTP batch ----
    set "HTTP_BAT=%INST_DIR%\http.bat"
    (
    echo @echo off
    echo REM ---- HTTP PHP built-in server ----
    echo set "BIND_IP=%BIND_IP%"
    echo set "PORT=%PORT%"
    echo set "PHP_EXE=%PHP_EXE%"
    echo set "PROJECT_DIR=%PROJECT_DIR%"
    echo.
        echo PowerShell -NoProfile -Command "Write-Host ' _____  _   _      _ ____   _   _ ' -ForegroundColor Cyan; Write-Host '^| ____|| \ | |    | ||_ _| | \ | |' -ForegroundColor Cyan; Write-Host '^|  _|  |  \| | _  | | | |  |  \| |' -ForegroundColor Cyan; Write-Host '^| |___ | |\  || |_| | | |  | |\  |' -ForegroundColor Cyan; Write-Host '^|_____||_| \_| \___/ |___| |_| \_|' -ForegroundColor Cyan"
    echo .
    echo echo Starting PHP built-in server at http://%BIND_IP%%:%PORT%
    echo "%PHP_EXE%" -S %BIND_IP%:%PORT% -t "%PROJECT_DIR%"
    echo.
   
    ) > "!HTTP_BAT!"
    echo [INFO] HTTP batch created: !HTTP_BAT!
)

