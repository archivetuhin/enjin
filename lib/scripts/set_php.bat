@echo off
setlocal EnableDelayedExpansion

REM ==================================================
REM 1. Ensure PHP_PATH from config is defined
REM ==================================================
if not defined PHP_PATH (
    echo [ERROR] PHP_PATH not defined in config.bat
    pause
    exit /b 1
)

REM ==================================================
REM 2. Enumerate available PHP versions
REM ==================================================
set PHP_INDEX=0
for /d %%D in ("%PHP_PATH%*") do (
    if exist "%%D\php.exe" (
        set /a PHP_INDEX+=1
        set "PHP_PATHS[!PHP_INDEX!]=%%D\php.exe"
         set "PHP_PATHS[!PHP_INDEX!]=%%D\php-cgi.exe"
        set "PHP_NAMES[!PHP_INDEX!]=%%~nxD"
        echo !PHP_INDEX!. %%~nxD
    )
)

REM ==================================================
REM 3. Ensure at least one PHP exists
REM ==================================================
if %PHP_INDEX%==0 (
    echo [ERROR] No php.exe found under %PHP_PATH%
    pause
    exit /b 1
)

REM ==================================================
REM 4. Let user select PHP version
REM ==================================================
:PHPCHOICE
set /p "PHP_CHOICE=Select PHP number: "

REM Remove spaces
set "PHP_CHOICE=%PHP_CHOICE: =%"

REM Check if numeric (only digits)
for /f "delims=0123456789" %%A in ("%PHP_CHOICE%") do (
    echo [ERROR] Please enter a valid number.
    goto PHPCHOICE
)

REM Check bounds
if %PHP_CHOICE% GTR %PHP_INDEX% (
    echo [ERROR] Number out of range.
    goto PHPCHOICE
)
if %PHP_CHOICE% LSS 1 (
    echo [ERROR] Number must be 1 or higher.
    goto PHPCHOICE
)

REM Set PHP_EXE and PHP_DIR
set "PHP_EXE=!PHP_PATHS[%PHP_CHOICE%]!"
for %%F in ("!PHP_EXE!") do set "PHP_DIR=%%~dpF"

if not exist "!PHP_EXE!" (
    echo [ERROR] Selected php.exe does not exist: !PHP_EXE!
    goto PHPCHOICE
)

REM ==================================================
REM 5. Set PHP_EXE, PHP_DIR, PHP_INI
REM ==================================================
set "PHP_EXE=!PHP_PATHS[%PHP_CHOICE%]!"
for %%F in ("!PHP_EXE!") do set "PHP_DIR=%%~dpF"

if not exist "!PHP_EXE!" (
    echo [ERROR] Selected php.exe does not exist: !PHP_EXE!
    goto PHPCHOICE
)

set "PHP_INI=!PHP_DIR!php.ini"
set "PHP_CGI=!PHP_DIR!php-cgi.exe"

REM ==================================================
REM 6. Ensure php.ini exists
REM ==================================================
if not exist "!PHP_INI!" (
    echo [WARNING] php.ini not found in !PHP_DIR!
    echo [INFO] Attempting to create from php.ini-development...
    if exist "!PHP_DIR!php.ini-development" (
        copy /Y "!PHP_DIR!php.ini-development" "!PHP_INI!" >nul
        echo [INFO] Created php.ini from php.ini-development
    ) else (
        echo [ERROR] php.ini and php.ini-development missing!
    )
)

REM ==================================================
REM 7. Optimize php.ini (extension_dir, disable Oracle)
REM ==================================================
if exist "!PHP_INI!" (
    echo [INFO] Optimizing php.ini...
    powershell -NoProfile -Command ^
        "$content = Get-Content '!PHP_INI!';" ^
        "$content = $content -replace '^;?\s*extension_dir\s*=\s*\".*\"', 'extension_dir = \"ext\"';" ^
        "$content = $content -replace '^;?\s*extension\s*=\s*(pdo_oci|oci8|pdo_oci8)', ';extension=$1';" ^
        "Set-Content '!PHP_INI!' $content"
    echo [INFO] php.ini optimized.
)

REM ==================================================
REM 8. Set environment variables
REM ==================================================
set "PATH=!PHP_DIR!;!PHP_DIR!ext;%PATH%"
set "PHPRC=!PHP_DIR!"

echo.
echo [SUCCESS] PHP environment ready.
echo PHP Executable: !PHP_EXE!
echo PHP Directory : !PHP_DIR!
echo PHP INI       : !PHP_INI!
echo PHPRC        : !PHPRC!

REM ==================================================
REM 9. Return variables to run.bat
REM ==================================================
endlocal & (
    set "PHP_EXE=%PHP_EXE%"
    set "PHP_CGI=%PHP_CGI%"
    set "PHP_DIR=%PHP_DIR%"
    set "PHP_INI=%PHP_INI%"
    set "PHPRC=%PHPRC%"
)
