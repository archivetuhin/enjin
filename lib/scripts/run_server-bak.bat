@echo off
setlocal EnableDelayedExpansion

REM ---- Header ----
powershell -NoProfile -Command "Write-Host ' _____  _   _      _ ____   _   _ ' -ForegroundColor Cyan; Write-Host '| ____|| \ | |    | ||_ _| | \ | |' -ForegroundColor Cyan; Write-Host '|  _|  |  \| | _  | | | |  |  \| |' -ForegroundColor Cyan; Write-Host '| |___ | |\  || |_| | | |  | |\  |' -ForegroundColor Cyan; Write-Host '|_____||_| \_| \___/ |___| |_| \_|' -ForegroundColor Cyan"

echo.
echo =================================================
echo  PHP SERVER
echo =================================================
echo  Folder: %TARGET_DIR%
echo  PHP:    !PHP_NAMES[%PHP_CHOICE%]!
if "%USE_SSL%" == "Y" (
	echo  URL:    httpS://%HOST%
) else (
	IF "%PORT%" == 80 (
    echo  URL:    http://%HOST%
    ) else (
        echo  URL:    http://%HOST%:%PORT%
    )
)

echo =================================================
echo  Press Ctrl+C to stop.
echo.
echo status %USE_SSL%

REM ---- Normalize paths ----
set "NG_EXE=%NGINX_EXE:\=/%"
set "NG_CONF=%NGINX_CONF:\=/%"
set "NG_DIR=%NGINX_DIR:\=/%"

if /i "%USE_SSL%"=="Y" (

    echo [INFO] Starting PHP FastCGI on %BIND_IP%:%PORT%

    REM ---- Kill any existing nginx ----
    taskkill /IM nginx.exe /F >nul 2>&1

    REM ---- Start php-cgi ----
    start "PHP-CGI" cmd /k "%PHP_DIR%php-cgi.exe -b %BIND_IP%:%PORT%"

    REM ---- Wait until php-cgi is listening ----
    :WAIT_PHP
    netstat -an | findstr "%BIND_IP%:%PORT%" | find "LISTENING" >nul
    if errorlevel 1 (
        timeout /t 1 >nul
        goto WAIT_PHP
    )

    REM ---- Start nginx ----
    pushd "%NGINX_DIR%"
    start "NGINX" cmd /k "%NG_EXE% -c %NG_CONF%"
    popd

    echo.
    echo PHP-CGI and portable Nginx started.
    echo Press Ctrl+C or close the windows to stop everything.

    REM ---- wait for user to exit ----
    pause

    REM ---- stop services ----
    taskkill /f /im php-cgi.exe >nul 2>&1
    taskkill /f /im nginx.exe >nul 2>&1

) else (
    echo [INFO] SSL disabled
    echo [INFO] Starting PHP built-in server
    echo        Bind: %BIND_IP%:%PORT%

    "%PHP_EXE%" -S %BIND_IP%:%PORT% -t "%PROJECT_DIR%"
    pause
)


