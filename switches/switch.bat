@echo off
echo Select PHP version:
echo 1. 7.4
echo 2. 8.1
echo 3. 8.2
SET /p choice="Enter choice (1/2/3): "

if "%choice%"=="1" SET PHP_PATH=G:\portable_server\php\php74
if "%choice%"=="2" SET PHP_PATH=G:\portable_server\php\php81
if "%choice%"=="3" SET PHP_PATH=G:\portable_server\php\php82

REM Prepend your PHP folder to PATH so it has priority
SET PATH=%PHP_PATH%;%PATH%

php -v
pause