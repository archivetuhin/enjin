@echo off
setlocal EnableDelayedExpansion
cls

REM ==================================================
REM NGINX.BAT - Configure Nginx for HTTP/HTTPS
REM Overwrites existing nginx.conf
REM Only numeric input allowed: 1 = Yes SSL, 2 = No SSL
REM ==================================================

REM Step 0: Ensure project variables are loaded
if not defined PROJECT_NAME (
    echo [ERROR] PROJECT_NAME is not defined. Aborting.
    exit /b 1
)
if not defined SERVER_ROOT (
    echo [ERROR] SERVER_ROOT is not defined. Aborting.
    exit /b 1
)
if not defined INST_DIR (
    echo [ERROR] INST_DIR is not defined. Aborting.
    exit /b 1
)

set "PROJECT_DIR=%SERVER_ROOT%%PROJECT_NAME%"
set "NGINX_CONF_FILE=%INST_DIR%\nginx.conf"
set "NGINX_DIR=%INST_DIR%"

REM ==============================
REM Step 1: Ask if SSL should be used
REM Strict numeric menu
REM ==============================
:SSL_MENU
echo.
echo Do you want to use SSL for this project?
echo  1) Yes
echo  2) No
set /p "USE_SSL=Select 1 or 2: "

if "%USE_SSL%"=="1" (
    set "USE_SSL=Y"
) else if "%USE_SSL%"=="2" (
    set "USE_SSL=N"
) else (
    echo [ERROR] Invalid selection. Only 1 or 2 allowed.
    goto SSL_MENU
)

REM ==============================
REM Step 2: Generate SSL if needed
REM ==============================
if /i "%USE_SSL%"=="Y" (

    taskkill /IM nginx.exe /F >nul 2>&1

    if not exist "%SSL_KEY%" (
        echo [INFO] SSL key not found. Calling ssl.bat...
        if exist "%SSL_INSTALL%" (
            call "%SSL_INSTALL%"
            if errorlevel 1 (
                echo [WARNING] SSL setup failed. Falling back to HTTP.
                set "USE_SSL=N"
            ) else (
                echo [INFO] SSL setup completed successfully.
            )
        ) else (
            echo [WARNING] ssl.bat not found. Falling back to HTTP.
            set "USE_SSL=N"
        )
    ) else (
        echo [INFO] SSL certificate/key already exist.
    )
)

REM ==============================
REM Step 3: Create log folder + files
REM ==============================
if not exist "%NGINX_DIR%\logs" mkdir "%NGINX_DIR%\logs"

if not exist "%NGINX_DIR%\logs\error.log" (
    type nul > "%NGINX_DIR%\logs\error.log"
)

if not exist "%NGINX_DIR%\logs\access.log" (
    type nul > "%NGINX_DIR%\logs\access.log"
)

REM ==============================
REM Step 4: Prepare variables for nginx.conf
REM ==============================
set "NGINX_CRT=%SSL_CERT:\=/%"
set "NGINX_KEY=%SSL_KEY:\=/%"
set "P_DIR=%PROJECT_DIR:\=/%"

REM ==============================
REM Step 5: Overwrite nginx.conf
REM ==============================
echo [INFO] Rewriting nginx.conf content...
(
    echo worker_processes  1;
    echo.
    echo events {
    echo     worker_connections  1024;
    echo }
    echo.
    echo http {
    echo     include       mime.types;
    echo     default_type  application/octet-stream;
    echo.
    echo     sendfile        on;
    echo     keepalive_timeout  65;
    echo.
    echo     error_log  "%NGINX_DIR%\logs\error.log";
    echo     access_log "%NGINX_DIR%\logs\access.log" main;
    echo.
    echo     server {
    if /i "%USE_SSL%"=="Y" (
        echo         listen       443 ssl;
        echo         ssl_certificate      "!NGINX_CRT!";
        echo         ssl_certificate_key  "!NGINX_KEY!";
    ) else (
        echo         listen       80;
    )
    echo         server_name  %HOST%;
    echo         root   !P_DIR!;
    echo         index  index.php index.html;
    echo.
    echo         location / {
    echo             try_files $uri $uri/ /index.php?$query_string;
    echo         }
    echo.
    echo         location ~ \.php$ {
    echo             fastcgi_pass %BIND_IP%:%PORT%;
    echo             fastcgi_index index.php;
    echo             fastcgi_param SCRIPT_FILENAME "!P_DIR!/index.php";
    echo             include fastcgi_params;
    echo         }
    echo     }
    echo }
) > "%NGINX_CONF_FILE%"

echo [INFO] nginx.conf content overwritten: %NGINX_CONF_FILE%
endlocal & set "USE_SSL=%USE_SSL%"

echo [INFO] Nginx setup completed.
exit /b 0
