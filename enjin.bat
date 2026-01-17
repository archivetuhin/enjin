@echo off
cls
:: ========================
:: Welcome Message
:: ========================
echo ==========================================
echo        Welcome to Enjin Dev Toolkit
echo ==========================================
echo.

:MENU
:: ========================
:: Show Menu Options
:: ========================
echo Please select an option:
echo 1. Create Project
echo 2. Show Projects to Run
echo 3. Install PHP
echo 4. Install MySQL
echo 5. Show List of Local Domains
echo 6. Exit
echo.

:: Take user input
set /p choice=Enter your choice [1-6]: 

:: ========================
:: Handle user choice
:: ========================
if "%choice%"=="1" (
	cls
    echo You chose: Create Project
    :: Call your create project script here
    call run.bat
    pause
    cls
    goto MENU
)

if "%choice%"=="2" (
	cls
    echo You chose: Show Projects to Run
    :: Call your script to list projects here
    pause
    cls
    goto MENU
)

if "%choice%"=="3" (
    echo You chose: Install PHP
    :: Call your script to install PHP here
    pause
    cls
    goto MENU
)

if "%choice%"=="4" (
    echo You chose: Install MySQL
    :: Call your script to install MySQL here
    pause
    cls
    goto MENU
)

if "%choice%"=="5" (
    echo You chose: Show List of Local Domains
    :: Call your script to list domains here
    pause
    cls
    goto MENU
)

if "%choice%"=="6" (
    echo Exiting...
    exit
)

:: If invalid input
echo Invalid choice. Try again.
pause
cls
goto MENU
