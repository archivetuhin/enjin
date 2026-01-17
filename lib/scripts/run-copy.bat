@echo off
setlocal enabledelayedexpansion

REM 1. Detect base path
if "%~1"=="" (
    set "BASE=%~dp0"
) else (
    set "BASE=%~1"
)
if "!BASE:~-1!"=="\" set "BASE=!BASE:~0,-1!"

REM 2. Load config
set "CONFIG_FILE=%BASE%\lib\scripts\config.bat"

call "%CONFIG_FILE%" "%BASE%"

echo INSTTT %INST_DIR%


REM 4. Call create-project.bat
call "%CREATE_PROJECT%"
REM == Project name variable "%PROJECT_NAME%"=
REM 5. Show project summary


REM 4. Call domain.bat
call "%SET_DOMAIN%"

REM ==================================================
REM 5. Set PHP
REM ==================================================
call "%SET_PHP%"



REM ==================================================
REM 5. Set Compser
REM ==================================================
REM call "%SET_COMPOSER%"

REM ==================================================
REM 5. Set SSL
REM ==================================================
call "%SET_NGINX%"

REM ==================================================
REM 5. GET Server
REM ==================================================

call "%GET_SERVER%"

pause
