@echo off
REM ==== LAUNCH IN POWER SHELL ====
echo %PSModulePath% | findstr "WindowsPowerShell" >nul
if %errorlevel% neq 0 (
    start powershell -NoExit -ExecutionPolicy Bypass -Command "cmd /c '%~f0'"
    exit
)

setlocal enabledelayedexpansion

REM ==== LOAD CONFIG ====
if not exist config.ini (
    echo ERROR: config.ini not found!
    pause
    exit /b
)

REM Improved parsing to handle spaces in paths
for /f "usebackq tokens=1,* delims==" %%A in ("config.ini") do (
    set "raw_key=%%A"
    set "raw_val=%%B"
    for /f "tokens=* delims= " %%a in ("!raw_key!") do set "KEY=%%a"
    for /f "tokens=* delims= " %%a in ("!raw_val!") do set "VAL=%%a"
    set "!KEY!=!VAL!"
)

if not defined SERVER_ROOT (
    echo ERROR: SERVER_ROOT not found in config.ini!
    pause
    exit /b
)

REM ==== GET PROJECT NAME ====
:GETNAME
set /p PROJECT=Enter project name: 
if "%PROJECT%"=="" goto GETNAME

set "PROJECT=%PROJECT: =%"
set "PROJECT_DIR=%SERVER_DOC_ROOT%\%PROJECT%"

REM ==== SANITIZE INPUT (Prevent Crash on Special Chars) ====
set "SAFE_PROJECT=%PROJECT%"
set "SAFE_PROJECT=!SAFE_PROJECT:&=_!"
set "SAFE_PROJECT=!SAFE_PROJECT:|=_!"
set "SAFE_PROJECT=!SAFE_PROJECT:(=_!"
set "SAFE_PROJECT=!SAFE_PROJECT:)=_!"
set "SAFE_PROJECT:!SAFE_PROJECT:<=_!"
set "SAFE_PROJECT=!SAFE_PROJECT:>=_!"
set "SAFE_PROJECT=!SAFE_PROJECT:^=_!"

echo PROJECT_DIR="%PROJECT_DIR%"

REM ==== CREATE PROJECT FOLDER ====
if exist "%PROJECT_DIR%" (
    echo ERROR: Project folder "%PROJECT%" already exists!
    pause
    exit /b
) else (
    mkdir "%PROJECT_DIR%"
    if errorlevel 1 (
        echo ERROR: Could not create project folder!
        pause
        exit /b
    )
)

REM ==== LIST PHP VERSIONS ====
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
    echo No PHP versions with php.exe found in "%SERVER_ROOT%php\"!
    pause
    exit /b
)

REM ==== USER SELECT PHP VERSION ====
:PHPCHOICE
set /p PHP_CHOICE=Enter PHP number: 
echo !PHP_CHOICE!| findstr /r "^[0-9][0-9]*$" >nul
if errorlevel 1 goto PHPCHOICE

if !PHP_CHOICE! GTR %PHP_INDEX% goto PHPCHOICE
if !PHP_CHOICE! LSS 1 goto PHPCHOICE

set "PHP_EXE=!PHP_PATHS[%PHP_CHOICE%]!"
set "PHP_NAME=!PHP_NAMES[%PHP_CHOICE%]!"

REM ==== SET PORT ====
if not defined DEFAULT_PORT set DEFAULT_PORT=8000
set /p PORT=Enter port (default %DEFAULT_PORT%): 
set "PORT=%PORT: =%"
if "%PORT%"=="" set "PORT=%DEFAULT_PORT%"
echo Selected port: %PORT%

REM ==== CREATE index.php ====
echo ^<?php> "%PROJECT_DIR%\index.php"
echo echo "Project !SAFE_PROJECT! is running";>> "%PROJECT_DIR%\index.php"
echo ^?> >> "%PROJECT_DIR%\index.php"
echo index.php created.


pause