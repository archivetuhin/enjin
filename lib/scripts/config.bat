@echo off
setlocal enabledelayedexpansion

REM ==================================================
REM 1. DETECT OR RECEIVE BASE PATH
REM ==================================================
REM If run.bat passes an argument (%1), use it.
REM Otherwise, detect where this config.bat file is located.
if "%~1"=="" (
    set "BASE=%~dp0"
) else (
    set "BASE=%~1"
)

REM Remove trailing backslash from BASE (e.g., G:\enjin\ -> G:\enjin)
if "!BASE:~-1!"=="\" set "BASE=!BASE:~0,-1!"

echo [CONFIG] Project Base Path: !BASE!

REM ==================================================
REM 2. DEFINE VARIABLES (Relative to BASE)
REM We use the values you provided.
REM ==================================================

REM --- SERVER PATH ---
set "SERVER_ROOT=!BASE!\root\"
set "SERVER_DOC_ROOT=!BASE!\root\"
set "INST_DIR=!BASE!\instance\"
REM --- PHP PATH ---
set "PHP_PATH=!BASE!\lib\php\"

set "PHP_INSTALL=!BASE!\lib\scripts\php.bat"

REM --- MYSQL PATH ---
set "MYSQL_PATH=!BASE!\lib\mysql\"
set "MYSQL_INSTALL=!BASE!\lib\scripts\mysql.bat"

REM --- COMPOSER PATH ---
set "COMPOSER_PATH=!BASE!\lib\tools\composer\composer.phar"

REM --- NGINX PATH ---
set "NGINX_EXE=!BASE!\lib\tools\ngix\nginx.exe"
set "NGINX_CONF=!BASE!\lib\tools\ngix\conf\nginx.conf"

REM --- OPENSSL ---
set "OPENSSL_64=!BASE!\lib\tools\openssl\x64\bin\"
set "OPENSSL_86=!BASE!\lib\tools\openssl\x86\bin\"
set "OPENSSL_EXE_64=!BASE!\lib\tools\openssl\x64\bin\openssl.exe"
set "OPENSSL_EXE_86=!BASE!\lib\tools\openssl\x86\bin\openssl.exe"
set "OPENSSL_CONF=!BASE!\lib\tools\openssl\ssl\openssl.cnf"

REM --- SSL ---

set "SSL_KEY=!BASE!\lib\tools\openssl\ssl\certs\server.key"
set "SSL_CERT=!BASE!\lib\tools\openssl\ssl\certs\server.crt"
set "SSL_PEM=!BASE!\lib\tools\openssl\ssl\certs\server.pem"

REM --- SCRIPTS ---

set "CREATE_PROJECT=!BASE!\lib\scripts\create-project.bat"
set "SET_DOMAIN=!BASE!\lib\scripts\domain.bat"
set "SET_PHP=!BASE!\lib\scripts\set_php.bat"
set "SET_COMPOSER=!BASE!\lib\scripts\composer.bat"
set "SET_NGINX=!BASE!\lib\scripts\nginx.bat"
set "GET_SERVER=!BASE!\lib\scripts\run_server.bat"
set "SSL_INSTALL=!BASE!\lib\scripts\ssl.bat"
REM ==================================================
REM 3. EXPORT VARIABLES TO PARENT SCRIPT
REM We must use 'endlocal' to allow variables to survive,
REM but we pass them back simultaneously.
REM ==================================================
endlocal & (
    set "BASE=%BASE%"
    set "SERVER_ROOT=%BASE%\root\"
    set "SERVER_DOC_ROOT=%BASE%\root\"
    set "INST_DIR=%BASE%\instance\"
    
    set "PHP_PATH=%BASE%\lib\php\"
    set "PHP_INSTALL=%BASE%\lib\scripts\php.bat"

    set "MYSQL_PATH=%BASE%\lib\mysql\"
    set "MYSQL_INSTALL=%BASE%\lib\scripts\mysql.bat"

    set "COMPOSER_PATH=%BASE%\lib\tools\composer\composer.phar"

    set "NGINX_EXE=%BASE%\lib\tools\ngix\nginx.exe"
    set "NGINX_CONF=%BASE%\lib\tools\ngix\conf\nginx.conf"

    set "OPENSSL_64=%BASE%\lib\tools\openssl\x64\bin\"
    set "OPENSSL_86=%BASE%\lib\tools\openssl\x86\bin\"
    set "OPENSSL_EXE_64=%BASE%\lib\tools\openssl\x64\bin\openssl.exe"
    set "OPENSSL_EXE_86=%BASE%\lib\tools\openssl\x86\bin\openssl.exe"
    set "OPENSSL_CONF=%BASE%\lib\tools\openssl\ssl\openssl.cnf"

    set "SSL_INSTALL=%BASE%\lib\scripts\ssl.bat"
    set "SSL_KEY=%BASE%\lib\tools\openssl\ssl\certs\server.key"
    set "SSL_CERT=%BASE%\lib\tools\openssl\ssl\certs\server.crt"
    set "SSL_PEM=%BASE%\lib\tools\openssl\ssl\certs\server.pem"

    set "CREATE_PROJECT=%BASE%\lib\scripts\create-project.bat"
    set "SET_DOMAIN=%BASE%\lib\scripts\domain.bat"
    set "SET_PHP=%BASE%\lib\scripts\set_php.bat"
    set "SET_COMPOSER=%BASE%\lib\scripts\composer.bat"
    set "SET_NGINX=%BASE%\lib\scripts\nginx.bat"
    set "GET_SERVER=%BASE%\lib\scripts\run_server.bat"
)
exit /b