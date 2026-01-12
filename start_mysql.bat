@echo off
title Portable MySQL Start

set BASE_DIR=%~dp0
set CONFIG_FILE=%BASE_DIR%\config.ini

for /f "tokens=1,2 delims==" %%A in (%CONFIG_FILE%) do set %%A=%%B

set MYSQL_BASE=%SERVER_ROOT%mysql\mysql9

"%MYSQL_BASE%\bin\mysqld.exe" --defaults-file="%MYSQL_BASE%\my.ini"

pause
