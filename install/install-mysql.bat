@echo off
title Portable MySQL First-Time Install

REM ===== RESOLVE PORTABLE ROOT =====
set BASE_DIR=%~dp0..
for %%I in ("%BASE_DIR%") do set BASE_DIR=%%~fI

REM ===== LOAD CONFIG =====
set CONFIG_FILE=%BASE_DIR%\config.ini

if not exist "%CONFIG_FILE%" (
    echo ERROR: config.ini not found
    pause
    exit /b
)

for /f "tokens=1,2 delims==" %%A in (%CONFIG_FILE%) do (
    set %%A=%%B
)

REM ===== AUTO MYSQL PATHS =====
set MYSQL_BASE=%SERVER_ROOT%mysql\mysql9
set MYSQL_BIN=%MYSQL_BASE%\bin
set MYSQL_DATA=%MYSQL_BASE%\data
set MYSQL_INI=%MYSQL_BASE%\my.ini

echo ======================================
echo Portable MySQL Installer
echo ======================================
echo MySQL Base:
echo %MYSQL_BASE%
echo.

REM ===== CHECK MYSQL =====
if not exist "%MYSQL_BIN%\mysqld.exe" (
    echo ERROR: mysqld.exe not found
    pause
    exit /b
)

REM ===== PREVENT REINSTALL =====
if exist "%MYSQL_DATA%\mysql" (
    echo MySQL already initialized.
    echo Installation aborted to prevent data loss.
    pause
    exit /b
)

mkdir "%MYSQL_DATA%" >nul 2>&1

REM ===== INITIALIZE =====
"%MYSQL_BIN%\mysqld.exe" ^
 --initialize-insecure ^
 --basedir="%MYSQL_BASE%" ^
 --datadir="%MYSQL_DATA%" ^
 --defaults-file="%MYSQL_INI%"

if errorlevel 1 (
    echo ERROR: MySQL initialization failed
    pause
    exit /b
)

echo.
echo MySQL installed successfully
echo Root user has NO password
pause
