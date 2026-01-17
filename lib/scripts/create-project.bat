@echo off
setlocal EnableDelayedExpansion
cls
REM -----------------------------
REM Ask for project name
REM -----------------------------
set "PROJECT_NAME=%~1"

:ASK_PROJECT
if "%PROJECT_NAME%"=="" (
    echo Current Root: %SERVER_DOC_ROOT%
    set /p "PROJECT_NAME=Enter project name to create: "
)

if "%PROJECT_NAME%"=="" goto ASK_PROJECT

REM -----------------------------
REM Remove spaces
REM -----------------------------
set "PROJECT_NAME=%PROJECT_NAME: =%"

REM -----------------------------
REM Paths (FIXED)
REM -----------------------------
set "PROJECT_DIR=%SERVER_DOC_ROOT%%PROJECT_NAME%"
set "INST_DIR=%INST_DIR%%PROJECT_NAME%"
set "INDEX_FILE=%PROJECT_DIR%\index.php"

echo INST_DIR !INST_DIR!
REM -----------------------------
REM Existence check (MISSING)
REM -----------------------------
if exist "!PROJECT_DIR!\" goto EXIST_CHOICE

REM -----------------------------
REM Create project directory
REM -----------------------------
mkdir "!PROJECT_DIR!" || (
    echo [ERROR] Failed to create project directory
    pause
    exit /b 1
)

goto CREATE_FILE

:EXIST_CHOICE
echo.
echo Project already exists.
echo 1. Continue with existing project
echo 2. Enter new project name
set /p "CHOICE=Select 1 or 2: "

if "!CHOICE!"=="1" goto CREATE_FILE
if "!CHOICE!"=="2" (
    set "PROJECT_NAME="
    goto ASK_PROJECT
)

echo Invalid choice.
goto EXIST_CHOICE

:CREATE_FILE
echo PROJECT_DIR = "!PROJECT_DIR!"
echo INDEX_FILE  = "!INDEX_FILE!"

(
    echo ^<?php
    echo phpinfo^(^);
    echo ?^>
) > "!INDEX_FILE!"

if not exist "!INDEX_FILE!" (
    echo [ERROR] index.php was not created
    pause
    exit /b 1
)

if not exist "!INST_DIR!\" (
    mkdir "!INST_DIR!"
)

echo [SUCCESS] Project ready: !PROJECT_NAME!
echo Path: !PROJECT_DIR!
cls
REM -----------------------------
REM Return values to run.bat
REM -----------------------------
endlocal & (
    set "PROJECT_NAME=%PROJECT_NAME%"
    set "PROJECT_DIR=%PROJECT_DIR%"
    set "INST_DIR=%INST_DIR%"
)

exit /b
