REM ==== COPY COMPOSER (Optional) ====
cls
if exist "%COMPOSER_PATH%" (
    echo.
    echo Do you want to include Composer for this project?
    echo   1. Yes (copy composer.phar)
    echo   2. No
    set /p "COPY_COMPOSER=Select 1 or 2: "

    REM Take first character for safety
    setlocal EnableDelayedExpansion
    set "COPY_COMPOSER=!COPY_COMPOSER:~0,1!"

    if "!COPY_COMPOSER!"=="1" (
        echo.
        echo [INFO] Preparing to copy Composer...

        REM Ensure install directory exists
        if not exist "%INST_DIR%" (
            echo [INFO] Install directory does not exist. Creating it now...
            mkdir "%INST_DIR%"
        )

        echo ----------------------------------------
        echo [INFO] Source : "%COMPOSER_PATH%"
        echo [INFO] Target : "%INST_DIR%\composer.phar"

        copy /Y "%COMPOSER_PATH%" "%INST_DIR%\composer.phar" >nul

        if errorlevel 1 (
            echo.
            echo [ERROR] Failed to copy composer.phar.
        ) else (
            echo.
            echo [SUCCESS] composer.phar copied successfully.
        )
        echo ----------------------------------------

    ) else if "!COPY_COMPOSER!"=="2" (
        echo.
        echo [INFO] Skipping Composer.
    ) else (
        echo.
        echo [ERROR] Invalid choice. Skipping Composer.
    )

    endlocal
) else (
    echo.
    echo [INFO] Composer.phar not found. Skipping Composer step.
)

echo.
