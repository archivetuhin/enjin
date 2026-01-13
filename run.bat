@echo off
REM ==== LAUNCH IN POWER SHELL ====
echo %PSModulePath% | findstr "WindowsPowerShell" >nul
if %errorlevel% neq 0 (
    start powershell -NoExit -ExecutionPolicy Bypass -Command "cmd /c '%~f0'"
    exit
)

setlocal enabledelayedexpansion

REM ==== LOAD CONFIG ====
if not exist "%~dp0config.ini" (
    echo ERROR: config.ini not found in script directory!
    pause
    exit /b
)

REM Parsing config
for /f "usebackq tokens=1,* delims==" %%A in ("%~dp0config.ini") do (
    set "raw_key=%%A"
    set "raw_val=%%B"
    for /f "tokens=* delims= " %%a in ("!raw_key!") do set "KEY=%%a"
    for /f "tokens=* delims= " %%a in ("!raw_val!") do set "VAL=%%a"
    set "!KEY!=!VAL!"
)

REM Remove trailing slash from SERVER_ROOT and SERVER_DOC_ROOT if present
if defined SERVER_ROOT set "SERVER_ROOT=%SERVER_ROOT:~0,-1%"
if defined SERVER_DOC_ROOT set "SERVER_DOC_ROOT=%SERVER_DOC_ROOT:~0,-1%"

if not defined SERVER_ROOT (
    echo ERROR: SERVER_ROOT not found in config.ini!
    pause
    exit /b
)

REM ==== STEP 1: ASK FOLDER NAME ====
echo.
echo =========================================
echo       PHP SERVER RUNNER
echo =========================================
echo Available Root: %SERVER_DOC_ROOT%
echo.
:GETFOLDER
set /p FOLDER_NAME=Enter Project Folder Name: 
if "%FOLDER_NAME%"=="" goto GETFOLDER

set "TARGET_DIR=%SERVER_DOC_ROOT%\%FOLDER_NAME%"

if not exist "%TARGET_DIR%" (
    echo ERROR: Folder "%FOLDER_NAME%" does not exist!
    pause
    exit /b
)

echo Target Directory: %TARGET_DIR%

REM ==== STEP 2: ASK DOMAIN & PORT ====
if not defined DEFAULT_HOST set DEFAULT_HOST=localhost
if not defined DEFAULT_PORT set DEFAULT_PORT=8000
if not defined HOST_IP set HOST_IP=127.0.0.1
if not defined HOST_PORT set HOST_PORT=80

echo.
set /p CUSTOM_ASK=Use custom local domain? (yes/no): 

REM Normalize input
for /f "delims=" %%x in ("%CUSTOM_ASK%") do set "FIRST_CHAR=%%x"
set "FIRST_CHAR=%FIRST_CHAR:~0,1%"

if /i "%FIRST_CHAR%"=="y" goto SETUP_CUSTOM
goto SETUP_DEFAULT

REM ==== CUSTOM DOMAIN SETUP ====
:SETUP_CUSTOM
echo.
:GETDOMAIN
set /p HOST_INPUT=Enter Domain (e.g. project.local): 
if "%HOST_INPUT%"=="" goto GETDOMAIN
set "HOST=%HOST_INPUT%"

:GETPORT
set /p PORT_INPUT=Enter Port (default %HOST_PORT%): 
if "%PORT_INPUT%"=="" (
  set "PORT=%HOST_PORT%"
  ) 
else ( set "PORT=%PORT_INPUT%" )

REM UPDATE HOSTS FILE AND FLUSH DNS IF NEW DOMAIN
echo.
echo [INFO] Checking hosts file...
powershell -NoProfile -Command ^
"$ip = '%HOST_IP%'; $domain = '%HOST%'; $file = 'C:\Windows\System32\drivers\etc\hosts'; ^
if (-not (Select-String -Path $file -Pattern $domain -Quiet)) { ^
    try { Add-Content -Path $file -Value ('$ip`t$domain'); Write-Host '[SUCCESS] Added domain to hosts file.' -ForegroundColor Green; Start-Process ipconfig -ArgumentList '/flushdns' -NoNewWindow -Wait; Write-Host '[INFO] DNS cache flushed.' -ForegroundColor Cyan } ^
    catch { Write-Host '[WARNING] Run as Administrator to update hosts file automatically.' -ForegroundColor Yellow } ^
} else { Write-Host '[INFO] Domain already exists in hosts file.' }"

set "BIND_IP=%HOST_IP%"
goto LIST_PHP

REM ==== DEFAULT SETUP ====
:SETUP_DEFAULT
echo Using default configuration...
set "HOST=%DEFAULT_HOST%"
set "PORT=%DEFAULT_PORT%"
set "BIND_IP=%HOST_IP%"
goto LIST_PHP

REM ==== STEP 3: LIST PHP VERSIONS ====
:LIST_PHP
echo.
echo Available PHP versions:
set PHP_INDEX=0
for /d %%D in ("%SERVER_ROOT%php\*") do (
    if exist "%%D\php.exe" (
        set /a PHP_INDEX+=1
        set "PHP_PATHS[!PHP_INDEX!]=%%D\php.exe"
        set "PHP_NAMES[!PHP_INDEX!]=%%~nxD"
        echo !PHP_INDEX!. %%~nxD
    )
)

if %PHP_INDEX%==0 (
    echo No PHP versions found in "%SERVER_ROOT%php\"!
    pause
    exit /b
)

REM ==== STEP 4: SELECT PHP VERSION ====
:PHPCHOICE
set /p PHP_CHOICE=Select PHP number: 
echo !PHP_CHOICE!| findstr /r "^[0-9][0-9]*$" >nul
if errorlevel 1 goto PHPCHOICE
if !PHP_CHOICE! GTR %PHP_INDEX% goto PHPCHOICE
if !PHP_CHOICE! LSS 1 goto PHPCHOICE

set "PHP_EXE=!PHP_PATHS[%PHP_CHOICE%]!"

REM ==== STEP 5: PREPARE PHP DIRECTORY & CONFIG ====
for %%F in ("%PHP_EXE%") do set "PHP_DIR=%%~dpF"

echo.
echo Checking PHP Configuration in: %PHP_DIR%

REM 1. Ensure php.ini exists
set "PHP_INI=%PHP_DIR%php.ini"
if not exist "%PHP_INI%" (
    if exist "%PHP_DIR%php.ini-development" (
        copy "%PHP_DIR%php.ini-development" "%PHP_INI%" >nul
        echo [INFO] Created php.ini from php.ini-development
    ) else (
        echo [WARNING] php.ini not found and no development template available.
    )
)

REM 2. AUTO-FIX: Fix extension_dir AND Disable Oracle Extensions
if exist "%PHP_INI%" (
    echo [INFO] Optimizing php.ini...
    powershell -NoProfile -Command ^
    "$content = Get-Content '%PHP_INI%'; " ^
    "$content = $content -replace '^;?\s*extension_dir\s*=\s*\".*\"', 'extension_dir = \"ext\"'; " ^
    "$content = $content -replace '^;?\s*extension\s*=\s*(pdo_oci|oci8|pdo_oci8)', ';extension=$1'; " ^
    "Set-Content '%PHP_INI%' $content"
    echo [INFO] - Configuration optimized.
)

REM 3. SET ENVIRONMENT VARIABLES
set "PATH=%PHP_DIR%;%PHP_DIR%ext;%PATH%"
set "PHPRC=%PHP_DIR%"

REM ==== STEP 6: CLEAR SCREEN & DRAW COLORED SIGNATURE ====
echo.
powershell -NoProfile -Command "Write-Host ' _____  _   _      _ ____   _   _ ' -ForegroundColor Cyan; Write-Host '| ____|| \ | |    | ||_ _| | \ | |' -ForegroundColor Cyan; Write-Host '|  _|  |  \| | _  | | | |  |  \| |' -ForegroundColor Cyan; Write-Host '| |___ | |\  || |_| | | |  | |\  |' -ForegroundColor Cyan; Write-Host '|_____||_| \_| \___/ |___| |_| \_|' -ForegroundColor Cyan"

echo.
echo =================================================
echo  PHP SERVER
echo =================================================
echo  Folder: %TARGET_DIR%
echo  PHP:    !PHP_NAMES[%PHP_CHOICE%]!
echo  URL:    http://%HOST%:%PORT%
echo =================================================
echo  Press Ctrl+C to stop.
echo.

REM Check if custom domain used
if /i "%FIRST_CHAR%"=="y" (
    if /i not "%HOST%"=="localhost" (
        echo  [NOTE] Ensure "%HOST%" is mapped in your hosts file.
        echo.
    )
)

REM Start Server
echo "%PHP_EXE%" -S %BIND_IP%:%PORT% -t "%TARGET_DIR%"

"%PHP_EXE%" -S %BIND_IP%:%PORT% -t "%TARGET_DIR%"

pause
