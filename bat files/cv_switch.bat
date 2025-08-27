@echo off
setlocal enabledelayedexpansion

:: Check for administrator privileges and self-elevate if needed
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo This script requires administrator privileges to modify Cabinet Vision database files.
    echo Requesting administrator access...
    echo.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Configuration
set "CVPath=C:\ProgramData\Hexagon\CABINET VISION"
set "LogFile=%CVPath%\switch-log.txt"

:: Check if CV is running
tasklist /FI "IMAGENAME eq cv.exe" 2>NUL | find /I /N "cv.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo.
    echo WARNING: Cabinet Vision is running!
    echo Please close all CV instances before switching databases.
    echo.
)

:: Display dashboard header
echo.
echo Cabinet Vision Database Switcher / Dashboard
echo ============================================
echo.
echo Current Database Status:
echo.

:: Show all versions and their current databases
set count=0
for /d %%i in ("%CVPath%\CV 20*") do (
    set /a count+=1
    set "version!count!=%%~nxi"
    set "versionPath=%%i"
    
    :: Get current database for this version
    if exist "!versionPath!\Database\Database_Name.txt" (
        set /p currentDb=<"!versionPath!\Database\Database_Name.txt"
    ) else (
        set currentDb=Default
    )
    
    :: Check Common database
    set "commonPath=%CVPath%\%%~nxi"
    set "commonPath=!commonPath:CV =Common !"
    set "commonStatus= "
    if exist "!commonPath!\Database\Database_Name.txt" (
        set /p commonDb=<"!commonPath!\Database\Database_Name.txt"
        if not "!commonDb!"=="!currentDb!" (
            set "commonStatus=Common:!commonDb! "
        )
    )
    
    :: Check S2M database
    set "s2mPath=%CVPath%\%%~nxi"
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
        echo   %%~nxi: [!currentDb!]
    ) else (
        echo   %%~nxi: [!currentDb!] ^(WARNING: !commonStatus!!s2mStatus!^)
    )
)

if !count!==0 (
    echo No CV installations found!
    pause
    exit /b
)

:: Select CV version
echo.
echo ============================================
echo.
echo Select CV Version to switch database:
echo   (or press Enter to exit if just checking status)
echo.

set vcount=0
for /d %%i in ("%CVPath%\CV 20*") do (
    set /a vcount+=1
    set "version!vcount!=%%~nxi"
    set "versionPath=%%i"
    
    :: Get current database for display
    if exist "!versionPath!\Database\Database_Name.txt" (
        set /p currentDb=<"!versionPath!\Database\Database_Name.txt"
    ) else (
        set currentDb=Default
    )
    
    echo !vcount!. %%~nxi (currently: !currentDb!)
)

echo.
set /p versionChoice=Enter number (or press Enter to exit): 

if "%versionChoice%"=="" (
    exit /b
)

set "SelectedVersion=!version%versionChoice%!"

if not defined SelectedVersion (
    echo Invalid selection!
    pause
    exit /b
)

set "VersionPath=%CVPath%\%SelectedVersion%"

:: Get current database
if exist "%VersionPath%\Database\Database_Name.txt" (
    set /p CurrentDatabase=<"%VersionPath%\Database\Database_Name.txt"
) else (
    set CurrentDatabase=Default
)

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
    exit /b
)

:: Select database
echo.
set /p dbChoice=Select database to switch to: 
set "NewDatabase=!db%dbChoice%!"

if not defined NewDatabase (
    echo Invalid selection!
    pause
    exit /b
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
if /i not "%confirm%"=="Y" exit /b

:: Export current registry settings
echo.
echo Saving registry settings...
reg export "HKEY_CURRENT_USER\Software\Cabinet Vision\%SelectedVersion:CV =Solid_%" "%VersionPath%\Database\Settings.reg" /y >nul 2>&1

:: Perform the switch
echo Switching databases...

:: Switch main database
ren "%VersionPath%\Database" "Database - %CurrentDatabase%"
if errorlevel 1 (
    echo ERROR: Failed to rename current database!
    pause
    exit /b
)

ren "%VersionPath%\Database - %NewDatabase%" "Database"
if errorlevel 1 (
    echo ERROR: Failed to activate new database!
    echo Attempting rollback...
    ren "%VersionPath%\Database - %CurrentDatabase%" "Database"
    pause
    exit /b
)

:: Switch Common folder if exists
set "CommonPath=%CVPath%\%SelectedVersion:CV =Common %"
if exist "%CommonPath%\Database" (
    echo Switching Common database...
    ren "%CommonPath%\Database" "Database - %CurrentDatabase%" 2>nul
    ren "%CommonPath%\Database - %NewDatabase%" "Database" 2>nul
)

:: Switch S2M folder if exists
set "S2MPath=%CVPath%\%SelectedVersion:CV =S2M %"
if exist "%S2MPath%\Database" (
    echo Switching S2M database...
    ren "%S2MPath%\Database" "Database - %CurrentDatabase%" 2>nul
    ren "%S2MPath%\Database - %NewDatabase%" "Database" 2>nul
)

:: Import registry settings if available
if exist "%VersionPath%\Database\Settings.reg" (
    echo Restoring registry settings...
    regedit /s "%VersionPath%\Database\Settings.reg"
)

:: Log the switch
echo %date% %time% ^| %username% ^| %SelectedVersion% ^| %CurrentDatabase% -^> %NewDatabase% >> "%LogFile%"

:: Success
echo.
echo ========================================
echo Database switch successful!
echo Now using: [%NewDatabase%]
echo ========================================
echo.

:: Run UpdateDatabase automatically
set "ProgramPath=C:\Program Files\Hexagon\CABINET VISION\%SelectedVersion%"
if exist "%ProgramPath%\CVUpdateVersion.exe" (
    echo.
    echo Starting UpdateDatabase...
    start "" "%ProgramPath%\CVUpdateVersion.exe"
) else (
    echo Warning: CVUpdateVersion.exe not found at %ProgramPath%!
)

echo.
pause