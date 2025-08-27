@echo off
setlocal enabledelayedexpansion

:: Check for administrator privileges and self-elevate if needed
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo This script requires administrator privileges to modify Cabinet Vision database files.
    echo Requesting administrator access...
    echo.
    powershell -Command "Start-Process cmd -ArgumentList '/k \"%~f0\"' -Verb RunAs"
    exit /b
)


:: Configuration
set "CVPath=C:\ProgramData\Hexagon\CABINET VISION"
set "LogFile=%CVPath%\switch-log.txt"

echo.
echo Cabinet Vision Database Identifier Setup
echo =======================================
echo.
echo This will add Database_Name.txt identifier files to unconfigured installations.
echo Use this for: fresh installs, newly imported databases, or any missing identifiers.
echo.

:: Check if CV is running
tasklist /FI "IMAGENAME eq cv.exe" 2>NUL | find /I /N "cv.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ERROR: Cabinet Vision is running!
    echo Please close all CV instances before running this setup.
    echo.
    pause
    exit /b
)

:BeginScan
:: Scan for CV versions without identifier files  
echo Scanning for unconfigured Cabinet Vision installations...
echo Looking for installations that need Database_Name.txt files...
echo.

set count=0
for /d %%i in ("%CVPath%\CV 20*") do (
    if exist "%%i\Database" (
        if not exist "%%i\Database\Database_Name.txt" (
            set /a count+=1
            echo Found unconfigured: %%~nxi
        ) else (
            echo Skipping: %%~nxi ^(already has identifier file^)
        )
    ) else (
        echo Skipping: %%~nxi ^(no Database folder^)
    )
)

echo.
if !count! equ 0 (
    echo All Cabinet Vision installations are already configured!
    echo All Database folders already contain Database_Name.txt files.
    echo.
    echo If you need to change an existing profile name, you can:
    echo 1. Delete the Database_Name.txt file from the Database folder  
    echo 2. Run this script again to set a new name
    echo.
    pause
    exit /b
)

:: Handle different scenarios based on count
if !count! equ 1 (
    echo Found 1 installation that needs identifier files.
    echo.
    goto :GetProfileName
) else (
    echo Found !count! installations that need identifier files.
    echo.
    echo Multiple unconfigured installations found:
    
    :: List unconfigured installations for selection
    set listCount=0
    for /d %%i in ("%CVPath%\CV 20*") do (
        if exist "%%i\Database" (
            if not exist "%%i\Database\Database_Name.txt" (
                set /a listCount+=1
                set "unconfigured!listCount!=%%~nxi"
                echo !listCount!. %%~nxi
            )
        )
    )
    
    echo.
    set /p selection=Select which installation to configure (1-!listCount!) or press Enter to cancel: 
    
    if "!selection!"=="" (
        echo Cancelled.
        pause
        exit /b
    )
    
    :: Validate selection
    if !selection! lss 1 goto :InvalidSelection
    if !selection! gtr !listCount! goto :InvalidSelection
    
    set "SelectedInstallation=!unconfigured%selection%!"
    echo.
    echo Selected: !SelectedInstallation!
    echo.
    goto :GetProfileName
)

:InvalidSelection
echo Invalid selection!
pause
exit /b

:GetProfileName

:: Get profile name from user
set /p profileName=Enter name for this profile (e.g., "Factory Reset", "Clean Install"):

if "%profileName%"=="" (
    echo Profile name cannot be empty!
    pause
    exit /b
)

:: Validate profile name (no special characters that would break folder names)
echo %profileName% | findstr /R /C:"[<>:\"/\\|?*]" >nul
if not errorlevel 1 (
    echo Profile name contains invalid characters. Please use letters, numbers, spaces, and hyphens only.
    pause
    exit /b
)

:: Show what will be set up for selected installation
echo.
echo ===============================================
echo Setting up profile: [%profileName%]
echo ===============================================
echo.

:: Determine which installation to show
if defined SelectedInstallation (
    set "TargetInstallation=%SelectedInstallation%"
    echo Configuring: %SelectedInstallation%
) else (
    :: Single installation case - find the unconfigured one
    for /d %%i in ("%CVPath%\CV 20*") do (
        if exist "%%i\Database" (
            if not exist "%%i\Database\Database_Name.txt" (
                set "TargetInstallation=%%~nxi"
            )
        )
    )
    echo Configuring: !TargetInstallation!
)

echo.
echo The following Database_Name.txt files will be created:
echo   !TargetInstallation!: Database\Database_Name.txt

:: Check for Common and S2M variants for target installation
set "commonPath=%CVPath%\!TargetInstallation!"
set "commonPath=!commonPath:CV =Common !"
if exist "!commonPath!\Database" (
    if not exist "!commonPath!\Database\Database_Name.txt" (
        echo     + Common: Database\Database_Name.txt
    )
)

set "s2mPath=%CVPath%\!TargetInstallation!"
set "s2mPath=!s2mPath:CV =S2M !"
if exist "!s2mPath!\Database" (
    if not exist "!s2mPath!\Database\Database_Name.txt" (
        echo     + S2M: Database\Database_Name.txt
    )
)

echo.
set /p confirm=Continue with identifier setup? (Y/N): 
if /i not "%confirm%"=="Y" (
    echo Setup cancelled.
    pause
    exit /b
)

echo.
echo Creating identifier files...
echo.

:: Process only the target installation
set "versionPath=%CVPath%\!TargetInstallation!"
echo Processing !TargetInstallation!...

:: Create identifier file in current Database folder
echo %profileName%>"!versionPath!\Database\Database_Name.txt"
if errorlevel 1 (
    echo   ERROR: Failed to create identifier file
) else (
    echo   ✓ Created Database_Name.txt with "%profileName%"
)

:: Set SQL permissions on existing database files
echo   Setting SQL permissions on database files...
for %%f in ("!versionPath!\Database\*.mdf" "!versionPath!\Database\*.ldf" "!versionPath!\Database\*.ndf") do (
    if exist "%%f" (
        icacls "%%f" /grant Everyone:F /Q >nul 2>&1
        if errorlevel 1 (
            echo   Warning: Could not set permissions on %%~nxf
        ) else (
            echo   ✓ Set permissions on %%~nxf
        )
    )
)

:: Handle Common folder if exists and unconfigured
set "commonPath=%CVPath%\!TargetInstallation:CV =Common !"
if exist "!commonPath!\Database" (
    if not exist "!commonPath!\Database\Database_Name.txt" (
        echo   Processing Common folder...
        
        :: Create Common identifier file
        echo %profileName%>"!commonPath!\Database\Database_Name.txt"
        if errorlevel 1 (
            echo   ERROR: Failed to create Common identifier file
        ) else (
            echo   ✓ Created Common Database_Name.txt
        )
        
        :: Set permissions on Common database files
        for %%f in ("!commonPath!\Database\*.mdf" "!commonPath!\Database\*.ldf" "!commonPath!\Database\*.ndf") do (
            if exist "%%f" (
                icacls "%%f" /grant Everyone:F /Q >nul 2>&1
                if errorlevel 1 (
                    echo   Warning: Could not set Common permissions on %%~nxf
                ) else (
                    echo   ✓ Set Common permissions on %%~nxf
                )
            )
        )
    )
)

:: Handle S2M folder if exists and unconfigured
set "s2mPath=%CVPath%\!TargetInstallation:CV =S2M !"
if exist "!s2mPath!\Database" (
    if not exist "!s2mPath!\Database\Database_Name.txt" (
        echo   Processing S2M folder...
        
        :: Create S2M identifier file
        echo %profileName%>"!s2mPath!\Database\Database_Name.txt"
        if errorlevel 1 (
            echo   ERROR: Failed to create S2M identifier file
        ) else (
            echo   ✓ Created S2M Database_Name.txt
        )
        
        :: Set permissions on S2M database files
        for %%f in ("!s2mPath!\Database\*.mdf" "!s2mPath!\Database\*.ldf" "!s2mPath!\Database\*.ndf") do (
            if exist "%%f" (
                icacls "%%f" /grant Everyone:F /Q >nul 2>&1
                if errorlevel 1 (
                    echo   Warning: Could not set S2M permissions on %%~nxf
                ) else (
                    echo   ✓ Set S2M permissions on %%~nxf
                )
            )
        )
    )
)

echo.

:: Log the setup
echo %date% %time% ^| %username% ^| SETUP ^| "%profileName%" profile created >> "%LogFile%"

:: Summary
echo ==========================================
echo Database Identifier Setup Complete!
echo ==========================================
echo.
echo Profile "%profileName%" has been set up successfully.
echo.
echo What was created:
echo - Database_Name.txt identifier file for the configured installation
echo - SQL permissions set on existing database files
echo - Common and S2M variants handled automatically
echo.
echo Next steps:
echo 1. Run cv_switch.bat to see "%profileName%" as an available database option
echo 2. To add new client databases: run prep_for_restore.bat → Restore CV → run this script again
echo 3. The "%profileName%" database is now ready for the switcher system
echo.
echo Note: The configured database is now labeled as "%profileName%"
echo      and ready to be managed with the database switcher.
echo.

:: Check if there are more unconfigured installations
set remainingCount=0
for /d %%i in ("%CVPath%\CV 20*") do (
    if exist "%%i\Database" (
        if not exist "%%i\Database\Database_Name.txt" (
            set /a remainingCount+=1
        )
    )
)

if !remainingCount! gtr 0 (
    echo.
    echo There are !remainingCount! more unconfigured installation(s).
    set /p configureMore=Configure another installation? (Y/N): 
    if /i "!configureMore!"=="Y" (
        echo.
        echo Restarting to configure additional installation...
        echo.
        goto :StartOver
    )
)

pause
exit /b

:StartOver
echo.
echo ===============================================
goto :BeginScan