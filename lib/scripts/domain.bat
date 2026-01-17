@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ==============================
REM Default values
REM ==============================
if not defined DEFAULT_HOST set "DEFAULT_HOST=localhost"
if not defined DEFAULT_PORT set "DEFAULT_PORT=80"
if not defined HOST_IP set "HOST_IP=127.0.0.1"
if not defined HOSTS_FILE set "HOSTS_FILE=C:\Windows\System32\drivers\etc\hosts"

REM ==============================
REM Step 1: Choose host type
REM ==============================
echo.
echo ==============================
echo   Host Configuration
echo ==============================
echo.
echo  1. Use localhost
echo  2. Use local domain
echo  3. Use IP address
echo.

:PRIMARY_MENU
set /p "PRIMARY=Select option (1, 2 or 3): "

if "%PRIMARY%"=="1" goto USE_LOCALHOST
if "%PRIMARY%"=="2" goto DOMAIN_MENU
if "%PRIMARY%"=="3" goto USE_IP

echo [ERROR] Invalid input. Only 1, 2 or 3 allowed.
goto PRIMARY_MENU

REM ==============================
REM Option 1: localhost
REM ==============================
:USE_LOCALHOST
set "HOST=%DEFAULT_HOST%"
set "BIND_IP=%HOST_IP%"
goto PORT_MENU

REM ==============================
REM Option 2: local domain
REM ==============================
:DOMAIN_MENU
echo.
echo ==============================
echo   Local Domain Options
echo ==============================
echo.
echo  1. Use existing local domain
echo  2. Create new local domain
echo.

:DOMAIN_CHOICE
set /p "DOMAIN_OPT=Select option (1 or 2): "

if "%DOMAIN_OPT%"=="1" goto LIST_DOMAINS
if "%DOMAIN_OPT%"=="2" goto CREATE_DOMAIN

echo [ERROR] Invalid input. Only 1 or 2 allowed.
goto DOMAIN_CHOICE

REM ------------------------------
REM List existing domains
REM ------------------------------
:LIST_DOMAINS
echo.
echo Available local domains:
echo -------------------------

set COUNT=0
for /f "tokens=2" %%D in ('findstr /R /C:"^%HOST_IP% " "%HOSTS_FILE%"') do (
    set /a COUNT+=1
    set "DOMAIN[!COUNT!]=%%D"
    echo   !COUNT!. %%D
)

if !COUNT! EQU 0 (
    echo [INFO] No local domains found.
    goto CREATE_DOMAIN
)

echo.
set /p "SEL=Select domain number: "

if not defined DOMAIN[%SEL%] (
    echo [ERROR] Invalid selection.
    goto LIST_DOMAINS
)

set "HOST=!DOMAIN[%SEL%]!"
set "BIND_IP=%HOST_IP%"
goto PORT_MENU

REM ------------------------------
REM Create new domain
REM ------------------------------
:CREATE_DOMAIN
echo.
:GETDOMAIN
set /p "HOST=Enter new domain (example: project.local): "
if "%HOST%"=="" goto GETDOMAIN

powershell -NoProfile -Command ^
"$ip='%HOST_IP%';$domain='%HOST%';$file='%HOSTS_FILE%'; ^
if (-not (Select-String -Path $file -Pattern ('\s'+$domain+'$') -Quiet)) { ^
  try { ^
    Add-Content -Path $file -Value \"$ip`t$domain\"; ^
    Start-Process ipconfig -ArgumentList '/flushdns' -NoNewWindow -Wait; ^
    Write-Host '[SUCCESS] Domain added.' -ForegroundColor Green ^
  } catch { ^
    Write-Host '[WARNING] Run as Administrator to modify hosts file.' -ForegroundColor Yellow ^
  } ^
} else { ^
  Write-Host '[INFO] Domain already exists.' ^
}"

set "BIND_IP=%HOST_IP%"
goto PORT_MENU

REM ==============================
REM Option 3: IP Address
REM ==============================
:USE_IP
echo.
:GET_IP
set /p "HOST=Enter IP address (example: 192.168.1.10): "
if "%HOST%"=="" goto GET_IP

echo %HOST% | findstr /R ^
"^\([0-9]\|[1-9][0-9]\|1[0-9][0-9]\|2[0-4][0-9]\|25[0-5]\)\." ^
"\([0-9]\|[1-9][0-9]\|1[0-9][0-9]\|2[0-4][0-9]\|25[0-5]\)\." ^
"\([0-9]\|[1-9][0-9]\|1[0-9][0-9]\|2[0-4][0-9]\|25[0-5]\)\." ^
"\([0-9]\|[1-9][0-9]\|1[0-9][0-9]\|2[0-4][0-9]\|25[0-5]\)$" >nul

if errorlevel 1 (
    echo [ERROR] Invalid IPv4 address.
    goto GET_IP
)

set "BIND_IP=%HOST%"
goto PORT_MENU

REM ==============================
REM Step 2: Port choice
REM ==============================
:PORT_MENU
echo.
echo ==============================
echo   Port Configuration
echo ==============================
echo.
echo  1. Use default port (%DEFAULT_PORT%)
echo  2. Use custom port
echo.

set /p "PORT_CHOICE=Select option (1 or 2): "

if "%PORT_CHOICE%"=="1" (
    set "PORT=%DEFAULT_PORT%"
    echo [INFO] Using default port: %PORT%
    goto FINISH
)

if "%PORT_CHOICE%"=="2" goto ASK_PORT

echo [ERROR] Invalid input. Only 1 or 2 allowed.
goto PORT_MENU

REM ==============================
REM Custom port input
REM ==============================
:ASK_PORT
echo.
set /p "PORT=Enter port number: "

if "%PORT%"=="" goto ASK_PORT

echo(!PORT!| findstr /R "^[0-9][0-9]*$" >nul
if errorlevel 1 (
    echo [ERROR] Port must be numeric.
    goto ASK_PORT
)

if %PORT% LSS 3000 (
    echo [ERROR] Port must be between 3000 and 65535.
    goto ASK_PORT
)

if %PORT% GTR 65535 (
    echo [ERROR] Port must be between 3000 and 65535.
    goto ASK_PORT
)

echo [INFO] Using custom port: %PORT%

REM ==============================
REM Return values
REM ==============================
:FINISH
endlocal & (
    set "HOST=%HOST%"
    set "PORT=%PORT%"
    set "BIND_IP=%BIND_IP%"
)

exit /b
