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

REM ==== CREATE run.bat (TEMP FILE METHOD) ====
echo.
echo Creating run.bat...

REM Define a safe temp file in the current directory
set "TEMP_RUN_FILE=%~dp0temp_run.bat"

REM 1. Delete temp file if it exists
if exist "%TEMP_RUN_FILE%" del "%TEMP_RUN_FILE%"

REM 2. Append lines one by one (No parenthesis block crashes)
REM We use %%%% to write a single % sign to the file.

echo @echo off>> "%TEMP_RUN_FILE%"
echo title !SAFE_PROJECT! - PHP Server>> "%TEMP_RUN_FILE%"
echo.>> "%TEMP_RUN_FILE%"
echo if not exist "%PHP_EXE%" ^(>> "%TEMP_RUN_FILE%"
echo     echo ERROR: PHP executable not found!>> "%TEMP_RUN_FILE%"
echo     pause>> "%TEMP_RUN_FILE%"
echo     exit /b>> "%TEMP_RUN_FILE%"
echo ^)>> "%TEMP_RUN_FILE%"
echo.>> "%TEMP_RUN_FILE%"
REM Hardcode the path for PHP_DIR so run.bat knows where to look
echo set "PHP_DIR=%SERVER_ROOT%php\%PHP_NAME%">> "%TEMP_RUN_FILE%"

REM Use %%%% for variables that should remain variables in run.bat
echo set "PATH=%%%%PHP_DIR%%%%;%%%%PHP_DIR%%%%\ext;%%%%PATH%%%%">> "%TEMP_RUN_FILE%"
echo set "PHPRC=%%%%PHP_DIR%%%%">> "%TEMP_RUN_FILE%"
echo.>> "%TEMP_RUN_FILE%"
echo echo Using PHP: "%PHP_EXE%">> "%TEMP_RUN_FILE%"

REM Hardcode the host/port variables if they exist, otherwise use defaults
if defined DEFAULT_HOST (
    echo echo Running at http://%DEFAULT_HOST%:%PORT%>> "%TEMP_RUN_FILE%"
) else (
    echo echo Running at http://localhost:%PORT%>> "%TEMP_RUN_FILE%"
)

if defined DEFAULT_HOST (
    echo "%PHP_EXE%" -S %DEFAULT_HOST%:%PORT% -t "%PROJECT_DIR%">> "%TEMP_RUN_FILE%"
) else (
    echo "%PHP_EXE%" -S localhost:%PORT% -t "%PROJECT_DIR%">> "%TEMP_RUN_FILE%"
)

REM 3. Move the temp file to the final destination
REM This is safer than writing directly to a path with special chars
move /Y "%TEMP_RUN_FILE%" "%PROJECT_DIR%\run.bat" >nul

REM Verify success
if not exist "%PROJECT_DIR%\run.bat" (
    echo [ERROR] Failed to create run.bat!
    echo Temp file location: "%TEMP_RUN_FILE%"
    pause
    exit /b
)

echo run.bat created successfully.

echo.
echo Project created successfully!
echo Location: %PROJECT_DIR%
echo.
echo To start the server, double-click: run.bat
echo.
pause