@echo off
setlocal enabledelayedexpansion

:: Cabinet Vision Database Manager - Unified Edition
:: Combines switching, setup, and import preparation into one intelligent interface
::
:: Developed by: Kyle - Nomadtek Consulting
:: Website: https://nomadtekconsulting.com
::
:: Built on methods discovered by the Cabinet Vision community:
::   - Database switching: Tristan R (2020-2023)
::   - Version switching: Kevin / Valley Cabinet (2023)
::
:: See CREDITS.md for full attribution
:: Released under MIT License - free for personal and commercial use

:: ========================================
:: SHARED CONFIGURATION
:: ========================================
set "CVPath=C:\ProgramData\Hexagon\CABINET VISION"
set "LogFile=%CVPath%\switch-log.txt"
set "Version=2.0"

:: ========================================
:: ADMINISTRATOR CHECK (ONCE)
:: ========================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo This script requires administrator privileges to modify Cabinet Vision database files.
    echo Requesting administrator access...
    echo.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ========================================
:: MAIN ENTRY POINT
:: ========================================
:Start
:: Check if CV is installed at the default location
if not exist "%CVPath%" (
    echo.
    echo ERROR: Cabinet Vision not found at default location:
    echo   %CVPath%
    echo.
    echo If Cabinet Vision is installed elsewhere, please edit line 11 of this file
    echo and change the CVPath to match your DATABASE location - not program files.
    echo.
    echo Example: set "CVPath=D:\Cabinet Vision"
    echo          set "CVPath=C:\CV Data"
    echo.
    echo IMPORTANT: Use the path containing the DATABASE folders, NOT the program files
    echo The folder should contain: CV 2023\Database, CV 2024\Database, etc.
    echo.
    pause
    exit /b
)

call :DetectSystemState
goto MainMenu

:: ========================================
:: SYSTEM STATE DETECTION
:: ========================================
:DetectSystemState
:: Initialize simple counters
set "cvRunning=0"
set "versionCount=0"
set "unconfiguredCount=0"
set "mismatchCount=0"
set "profileCount=0"

:: Check if CV is running
tasklist /FI "IMAGENAME eq cv.exe" 2>NUL | find /I /N "cv.exe">NUL
if "%ERRORLEVEL%"=="0" set "cvRunning=1"

:: Simple scan like original scripts
for /d %%i in ("%CVPath%\CV 20*") do (
    set /a versionCount+=1

    :: Check for unconfigured
    if exist "%%i\Database" (
        if not exist "%%i\Database\Database_Name.txt" (
            set /a unconfiguredCount+=1
        ) else (
            :: Count configured active databases
            set /a profileCount+=1
        )
    )

    :: Count alternative database profiles
    for /d %%j in ("%%i\Database - *") do (
        set /a profileCount+=1
    )
)

:: Simple mismatch check
for /d %%i in ("%CVPath%\CV 20*") do (
    set "versionPath=%%i"
    set "versionName=%%~nxi"

    if exist "!versionPath!\Database\Database_Name.txt" (
        set /p mainDb=<"!versionPath!\Database\Database_Name.txt"

        :: Check Common
        set "commonPath=%CVPath%\!versionName!"
        set "commonPath=!commonPath:CV =Common !"
        if exist "!commonPath!\Database\Database_Name.txt" (
            set /p commonDb=<"!commonPath!\Database\Database_Name.txt"
            if not "!commonDb!"=="!mainDb!" set /a mismatchCount+=1
        )

        :: Check S2M
        set "s2mPath=%CVPath%\!versionName!"
        set "s2mPath=!s2mPath:CV =S2M !"
        if exist "!s2mPath!\Database\Database_Name.txt" (
            set /p s2mDb=<"!s2mPath!\Database\Database_Name.txt"
            if not "!s2mDb!"=="!mainDb!" set /a mismatchCount+=1
        )
    )
)

goto :eof

:: ========================================
:: MAIN MENU
:: ========================================
:MainMenu
cls
echo.
echo Cabinet Vision Database Manager v%Version%
echo =====================================
echo.
echo System Status:
if !cvRunning!==1 (
    echo   WARNING: Cabinet Vision is currently running
)
echo   CV versions found: !versionCount!
echo   Total database profiles: !profileCount!
if !unconfiguredCount! gtr 0 (
    echo   WARNING: !unconfiguredCount! unconfigured database(s)
)
if !mismatchCount! gtr 0 (
    echo   WARNING: !mismatchCount! database mismatch(es)
)
echo.
echo =====================================
echo.
echo Main Menu:
echo.
echo 1. Dashboard and Switch Databases
echo 2. Setup New Database
echo 3. Prepare for New Client Import
echo 4. View Audit Log
echo 5. Help
echo 6. Exit
echo.
set /p menuChoice=Select option (1-6):

if "%menuChoice%"=="1" goto DashboardSwitch
if "%menuChoice%"=="2" goto SetupDatabase
if "%menuChoice%"=="3" goto PrepareImport
if "%menuChoice%"=="4" goto ViewLog
if "%menuChoice%"=="5" goto ShowHelp
if "%menuChoice%"=="6" exit /b

echo Invalid selection!
timeout /t 2 >nul
goto MainMenu

:: ========================================
:: OPTION 1: DASHBOARD AND SWITCH
:: ========================================
:DashboardSwitch
cls
:: Check if CV is running before switching
if !cvRunning!==1 (
    echo.
    echo ERROR: Cabinet Vision is running!
    echo Please close all CV instances before switching databases.
    echo.
    pause
    goto MainMenu
)

echo.
echo Cabinet Vision Database Dashboard
echo ============================================
echo.
echo Current Database Status:
echo.

:: Show all versions and their current databases
for /d %%i in ("%CVPath%\CV 20*") do (
    set "versionPath=%%i"
    set "versionName=%%~nxi"

    :: Get current database for this version
    if exist "!versionPath!\Database\Database_Name.txt" (
        set /p currentDb=<"!versionPath!\Database\Database_Name.txt"
    ) else (
        set currentDb=Unconfigured
    )

    :: Check Common database
    set "commonPath=%CVPath%\!versionName!"
    set "commonPath=!commonPath:CV =Common !"
    set "commonStatus= "
    if exist "!commonPath!\Database\Database_Name.txt" (
        set /p commonDb=<"!commonPath!\Database\Database_Name.txt"
        if not "!commonDb!"=="!currentDb!" (
            set "commonStatus=Common:!commonDb! "
        )
    )

    :: Check S2M database
    set "s2mPath=%CVPath%\!versionName!"
    set "s2mPath=!s2mPath:CV =S2M !"
    set "s2mStatus= "
    if exist "!s2mPath!\Database\Database_Name.txt" (
        set /p s2mDb=<"!s2mPath!\Database\Database_Name.txt"
        if not "!s2mDb!"=="!currentDb!" (
            set "s2mStatus=S2M:!s2mDb! "
        )
    )

    :: Display with any mismatch warnings
    if "!commonStatus!!s2mStatus!"=="  " (
        echo   !versionName!: [!currentDb!]
    ) else (
        echo   !versionName!: [!currentDb!] ^(WARNING: !commonStatus!!s2mStatus!^)
    )
)

:: Select CV version
echo.
echo ============================================
echo.
echo Select CV Version to switch database:
echo   (or press Enter to return to main menu)
echo.

set vcount=0
for /d %%i in ("%CVPath%\CV 20*") do (
    set /a vcount+=1
    set "switchVersion!vcount!=%%~nxi"
    set "versionPath=%%i"

    :: Get current database for display
    if exist "!versionPath!\Database\Database_Name.txt" (
        set /p currentDb=<"!versionPath!\Database\Database_Name.txt"
    ) else (
        set currentDb=Unconfigured
    )

    echo !vcount!. %%~nxi ^(currently: !currentDb!^)
)

echo.
set /p versionChoice=Enter number (or press Enter to return):

if "%versionChoice%"=="" goto MainMenu

set "SelectedVersion=!switchVersion%versionChoice%!"

if not defined SelectedVersion (
    echo Invalid selection!
    pause
    goto MainMenu
)

set "VersionPath=%CVPath%\%SelectedVersion%"

:: Check if database is configured
if not exist "%VersionPath%\Database\Database_Name.txt" (
    echo.
    echo This database is not configured yet.
    echo Please use option 2 from the main menu to set it up first.
    echo.
    pause
    goto MainMenu
)

:: Get current database
set /p CurrentDatabase=<"%VersionPath%\Database\Database_Name.txt"

:: Find available databases
echo.
echo Current Database: [%CurrentDatabase%]
echo.
echo Available Databases:
set dbcount=0
for /d %%i in ("%VersionPath%\Database - *") do (
    set /a dbcount+=1
    set "dbname=%%~nxi"
    set "dbname=!dbname:Database - =!"
    set "db!dbcount!=!dbname!"
    echo !dbcount!. !dbname!
)

if !dbcount!==0 (
    echo.
    echo No alternate databases found!
    echo To create: Copy 'Database' folder and rename to 'Database - ClientName'
    echo.
    pause
    goto MainMenu
)

:: Select database
echo.
set /p dbChoice=Select database to switch to (or Enter to cancel):
if "%dbChoice%"=="" goto MainMenu

set "NewDatabase=!db%dbChoice%!"

if not defined NewDatabase (
    echo Invalid selection!
    pause
    goto MainMenu
)

:: Confirm switch
echo.
echo ========================================
echo Switching from: [%CurrentDatabase%]
echo            to: [%NewDatabase%]
echo     Version: %SelectedVersion%
echo ========================================
echo.
set /p confirm=Continue? (Y/N):
if /i not "%confirm%"=="Y" goto MainMenu

:: Perform the switch
call :PerformSwitch "%SelectedVersion%" "%CurrentDatabase%" "%NewDatabase%"
echo.
pause
goto MainMenu

:: ========================================
:: OPTION 2: SETUP DATABASE
:: ========================================
:SetupDatabase
cls
echo.
echo Cabinet Vision Database Setup
echo =======================================
echo.

if !cvRunning!==1 (
    echo ERROR: Cabinet Vision is running!
    echo Please close all CV instances before running setup.
    echo.
    pause
    goto MainMenu
)

:: Scan for unconfigured versions using simple method from original
echo Scanning for unconfigured installations...
echo.

set setupCount=0
for /d %%i in ("%CVPath%\CV 20*") do (
    if exist "%%i\Database" (
        if not exist "%%i\Database\Database_Name.txt" (
            set /a setupCount+=1
            set "setupOption!setupCount!=%%~nxi"
            echo !setupCount!. %%~nxi
        )
    )
)

if !setupCount!==0 (
    echo No unconfigured databases found.
    echo.
    echo This option is for setting up fresh installs or newly imported databases.
    echo All your current databases already have identifier files.
    echo.
    pause
    goto MainMenu
)

echo.
set /p selection=Select which to configure (1-!setupCount!) or Enter to cancel:

if "%selection%"=="" goto MainMenu

set "SelectedInstallation=!setupOption%selection%!"

if not defined SelectedInstallation (
    echo Invalid selection!
    pause
    goto MainMenu
)

:: Get profile name from user
echo.
set /p profileName=Enter name for this profile (e.g., "Client Name", "Testing"):

if "%profileName%"=="" (
    echo Profile name cannot be empty!
    pause
    goto MainMenu
)

:: Perform setup
call :SetupIdentifier "%SelectedInstallation%" "%profileName%"
echo.
pause
goto MainMenu

:: ========================================
:: OPTION 3: PREPARE FOR NEW CLIENT IMPORT
:: ========================================
:PrepareImport
cls
echo.
echo Cabinet Vision New Client Import Preparation
echo ===================================================
echo.

if !cvRunning!==1 (
    echo ERROR: Cabinet Vision is running!
    echo Please close all CV instances before preparation.
    echo.
    pause
    goto MainMenu
)

echo This will preserve your current database and prepare for importing a new client.
echo Your existing database will be saved as a switchable profile.
echo.
echo Current Database Status:
echo.

:: Show all versions
set vcount=0
for /d %%i in ("%CVPath%\CV 20*") do (
    set /a vcount+=1
    set "prepVersion!vcount!=%%~nxi"
    set "versionPath=%%i"

    :: Get current database
    if exist "!versionPath!\Database\Database_Name.txt" (
        set /p currentDb=<"!versionPath!\Database\Database_Name.txt"
    ) else (
        set currentDb=Unconfigured
    )

    echo !vcount!. %%~nxi - currently: !currentDb!
)

echo.
echo Select version to prepare for import:
set /p versionChoice=Enter number (1-!vcount!) or Enter to cancel:

if "%versionChoice%"=="" goto MainMenu

set "SelectedVersion=!prepVersion%versionChoice%!"

if not defined SelectedVersion (
    echo Invalid selection!
    pause
    goto MainMenu
)

:: Confirm preparation
call :PrepareForRestore "%SelectedVersion%"
echo.
pause
goto MainMenu

:: ========================================
:: OPTION 5: VIEW LOG
:: ========================================
:ViewLog
cls
echo.
echo Cabinet Vision Database Switch Log
echo ===================================
echo.

if not exist "%LogFile%" (
    echo No log file found.
    echo Log will be created after first database operation.
    echo.
    pause
    goto MainMenu
)

echo Recent entries:
echo.
:: Display last 20 lines using a simple method
set lineCount=0
for /f "usebackq delims=" %%a in ("%LogFile%") do (
    set /a lineCount+=1
    set "line!lineCount!=%%a"
)

:: Check if file has content
if !lineCount!==0 (
    echo Log file is empty.
) else (
    :: Calculate starting line (show last 20)
    set /a startLine=lineCount-20
    if !startLine! lss 1 set startLine=1

    :: Display the lines
    for /l %%i in (!startLine!,1,!lineCount!) do (
        echo !line%%i!
    )
)
echo.
pause
goto MainMenu

:: ========================================
:: OPTION 6: HELP
:: ========================================
:ShowHelp
cls
echo.
echo Cabinet Vision Database Manager - Help
echo =======================================
echo.
echo OPTION 1: Dashboard and Switch Databases
echo   - View current database status for all CV versions
echo   - Switch between different database profiles
echo   - Shows warnings if Common/S2M databases are mismatched
echo   - Automatically runs UpdateDatabase after switching
echo.
echo OPTION 2: Setup New Database
echo   - Configures databases that don't have identifier files
echo   - Used after fresh CV install or importing via Restore CV
echo   - Creates Database_Name.txt files for tracking
echo   - Sets SQL permissions on database files
echo.
echo OPTION 3: Prepare for New Client Import
echo   - Preserves your current database as a switchable profile
echo   - Copies current database to "Database - [Name]"
echo   - Leaves Database folder ready for Restore CV to import into
echo   - After restore, use Option 2 to name the new database
echo.
echo OPTION 4: View Audit Log
echo   - Shows history of all database operations
echo   - Tracks switches, setups, imports, and fixes
echo   - Useful for troubleshooting and tracking changes
echo.
echo NOTE: Database Mismatches
echo   - If you see mismatch warnings in the dashboard
echo   - Use Option 1 to properly switch to the desired database
echo   - This will align all three databases correctly
echo.
echo Press any key to return to main menu...
pause >nul
goto MainMenu

:: ========================================
:: SUBROUTINES
:: ========================================

:PerformSwitch
:: Parameters: %1=Version %2=CurrentDB %3=NewDB
set "Version=%~1"
set "Current=%~2"
set "New=%~3"
set "VPath=%CVPath%\%Version%"

echo.
echo Saving registry settings...
reg export "HKEY_CURRENT_USER\Software\Hexagon\CABINET VISION\%Version%\Settings" "%VPath%\Database\Settings.reg" /y >nul 2>&1

echo Switching databases...

:: Switch main database
ren "%VPath%\Database" "Database - %Current%"
if errorlevel 1 (
    echo ERROR: Failed to rename current database!
    goto :eof
)

ren "%VPath%\Database - %New%" "Database"
if errorlevel 1 (
    echo ERROR: Failed to activate new database!
    echo Attempting rollback...
    ren "%VPath%\Database - %Current%" "Database"
    goto :eof
)

:: Switch Common folder if exists
set "CommonPath=%CVPath%\%Version:CV =Common %"
if exist "%CommonPath%\Database" (
    echo Switching Common database...
    ren "%CommonPath%\Database" "Database - %Current%" 2>nul
    ren "%CommonPath%\Database - %New%" "Database" 2>nul
)

:: Switch S2M folder if exists
set "S2MPath=%CVPath%\%Version:CV =S2M %"
if exist "%S2MPath%\Database" (
    echo Switching S2M database...
    ren "%S2MPath%\Database" "Database - %Current%" 2>nul
    ren "%S2MPath%\Database - %New%" "Database" 2>nul
)

:: Switch Default.dat (layer schedules and dimension styles - Cabinet module)
if exist "%VPath%\Default.dat" (
    echo Switching layer settings...
    ren "%VPath%\Default.dat" "Default - %Current%.dat" 2>nul
)
if exist "%VPath%\Default - %New%.dat" (
    ren "%VPath%\Default - %New%.dat" "Default.dat" 2>nul
)

:: Switch DefaultCLST.dat (layer schedules and dimension styles - Closet module)
if exist "%VPath%\DefaultCLST.dat" (
    ren "%VPath%\DefaultCLST.dat" "DefaultCLST - %Current%.dat" 2>nul
)
if exist "%VPath%\DefaultCLST - %New%.dat" (
    ren "%VPath%\DefaultCLST - %New%.dat" "DefaultCLST.dat" 2>nul
)

:: Always clean registry when switching profiles to prevent contamination
echo Cleaning registry for profile switch...
reg delete "HKEY_CURRENT_USER\Software\Hexagon\CABINET VISION\%Version%\Settings" /f >nul 2>&1

:: Import registry settings if available for new profile
if exist "%VPath%\Database\Settings.reg" (
    echo Restoring registry settings...
    regedit /s "%VPath%\Database\Settings.reg"
)

:: Log the switch
echo %date% %time% ^| %username% ^| %Version% ^| %Current% -^> %New% >> "%LogFile%"

echo.
echo ========================================
echo Database switch successful!
echo Now using: [%New%]
echo ========================================

:: Run UpdateDatabase
set "ProgramPath=C:\Program Files\Hexagon\CABINET VISION\%Version%"
if exist "%ProgramPath%\CVUpdateVersion.exe" (
    echo.
    echo Starting UpdateDatabase...
    start "" "%ProgramPath%\CVUpdateVersion.exe"
)

goto :eof

:SetupIdentifier
:: Parameters: %1=Installation %2=ProfileName
set "Installation=%~1"
set "Profile=%~2"
set "VPath=%CVPath%\%Installation%"

echo.
echo Setting up profile: [%Profile%]
echo.

:: Check if Database folder exists
if not exist "%VPath%\Database" (
    echo ERROR: Database folder not found at:
    echo   %VPath%\Database
    echo.
    echo Please ensure CV %Installation% has a Database folder.
    goto :eof
)

:: Remove read-only attribute if file exists
if exist "%VPath%\Database\Database_Name.txt" (
    attrib -r "%VPath%\Database\Database_Name.txt" >nul 2>&1
)

:: Create identifier file in main Database
echo %Profile%>"%VPath%\Database\Database_Name.txt"

:: Verify the file was actually created instead of relying on errorlevel
if not exist "%VPath%\Database\Database_Name.txt" (
    echo ERROR: Failed to create identifier file at:
    echo   %VPath%\Database\Database_Name.txt
    echo.
    echo Please check permissions or if the path is valid.
    goto :eof
)
echo Created Database_Name.txt for %Installation%

:: Handle Common folder
set "CommonPath=%CVPath%\%Installation:CV =Common %"
if exist "%CommonPath%\Database" (
    if exist "%CommonPath%\Database\Database_Name.txt" (
        attrib -r "%CommonPath%\Database\Database_Name.txt" >nul 2>&1
    )
    echo %Profile%>"%CommonPath%\Database\Database_Name.txt"
    if exist "%CommonPath%\Database\Database_Name.txt" (
        echo Created Common Database_Name.txt
    ) else (
        echo WARNING: Failed to create Common Database_Name.txt
    )
)

:: Handle S2M folder
set "S2MPath=%CVPath%\%Installation:CV =S2M %"
if exist "%S2MPath%\Database" (
    if exist "%S2MPath%\Database\Database_Name.txt" (
        attrib -r "%S2MPath%\Database\Database_Name.txt" >nul 2>&1
    )
    echo %Profile%>"%S2MPath%\Database\Database_Name.txt"
    if exist "%S2MPath%\Database\Database_Name.txt" (
        echo Created S2M Database_Name.txt
    ) else (
        echo WARNING: Failed to create S2M Database_Name.txt
    )
)

:: Set SQL permissions
echo Setting SQL permissions...
for %%f in ("%VPath%\Database\*.mdf" "%VPath%\Database\*.ldf") do (
    if exist "%%f" (
        icacls "%%f" /grant Everyone:F /Q >nul 2>&1
    )
)

:: Check if System Parameters exist for this profile
reg query "HKEY_CURRENT_USER\Software\Hexagon\CABINET VISION\%Installation%\Settings" >nul 2>&1
if errorlevel 1 (
    echo.
    echo WARNING: No System Parameters found in registry for %Installation%
    echo This may indicate the imported backup did not include System Parameters.
    echo The profile will work but may use default system variables.
    echo.
)

:: Log the setup
echo %date% %time% ^| %username% ^| SETUP ^| %Installation% ^| %Profile% >> "%LogFile%"

echo.
echo Setup complete! Profile "%Profile%" is ready to use.

goto :eof

:PrepareForRestore
:: Parameters: %1=Version
set "Version=%~1"
set "VPath=%CVPath%\%Version%"

:: Get current database name
if exist "%VPath%\Database\Database_Name.txt" (
    set /p CurrentDb=<"%VPath%\Database\Database_Name.txt"
) else (
    set CurrentDb=Unknown
)

echo.
echo ==========================================
echo Preparing %Version% for import
echo ==========================================
echo.
echo Current database: [%CurrentDb%]
echo.
echo This will:
echo 1. Preserve your current database as "Database - %CurrentDb%"
echo 2. Keep the Database folder for Restore CV to import into
echo 3. Also preserve Common and S2M databases if present
echo.
set /p confirm=Continue? (Y/N):
if /i not "%confirm%"=="Y" goto :eof

echo.
echo Preserving current databases...

:: Copy main Database
if not exist "%VPath%\Database - %CurrentDb%" (
    xcopy "%VPath%\Database" "%VPath%\Database - %CurrentDb%\" /E /I /H /Y /Q
    echo Copied main database to "Database - %CurrentDb%"

    :: Set SQL permissions
    for %%f in ("%VPath%\Database - %CurrentDb%\*.mdf" "%VPath%\Database - %CurrentDb%\*.ldf") do (
        if exist "%%f" icacls "%%f" /grant Everyone:F /Q >nul 2>&1
    )
)

:: Handle Common
set "CommonPath=%CVPath%\%Version:CV =Common %"
if exist "%CommonPath%\Database" (
    if exist "%CommonPath%\Database\Database_Name.txt" (
        set /p commonDb=<"%CommonPath%\Database\Database_Name.txt"
    ) else (
        set commonDb=Unknown
    )

    if not exist "%CommonPath%\Database - !commonDb!" (
        xcopy "%CommonPath%\Database" "%CommonPath%\Database - !commonDb!\" /E /I /H /Y /Q
        echo Copied Common database to "Database - !commonDb!"
    )
)

:: Handle S2M
set "S2MPath=%CVPath%\%Version:CV =S2M %"
if exist "%S2MPath%\Database" (
    if exist "%S2MPath%\Database\Database_Name.txt" (
        set /p s2mDb=<"%S2MPath%\Database\Database_Name.txt"
    ) else (
        set s2mDb=Unknown
    )

    if not exist "%S2MPath%\Database - !s2mDb!" (
        xcopy "%S2MPath%\Database" "%S2MPath%\Database - !s2mDb!\" /E /I /H /Y /Q
        echo Copied S2M database to "Database - !s2mDb!"
    )
)

:: Remove identifier files for clean import
del "%VPath%\Database\Database_Name.txt" >nul 2>&1
del "%CommonPath%\Database\Database_Name.txt" >nul 2>&1
del "%S2MPath%\Database\Database_Name.txt" >nul 2>&1

:: Clean registry for fresh import (prevents stacking of mixed settings)
echo Cleaning registry for fresh import...
reg delete "HKEY_CURRENT_USER\Software\Hexagon\CABINET VISION\%Version%\Settings" /f >nul 2>&1

:: Log the preparation
echo %date% %time% ^| %username% ^| PREP ^| %Version% ^| %CurrentDb% >> "%LogFile%"

echo.
echo Preparation complete!
echo.
echo Next steps:
echo 1. Run "Restore CV %Version% Settings" from Start Menu
echo 2. Import your client backup
echo 3. Return here and use Option 2 to setup the new database

goto :eof