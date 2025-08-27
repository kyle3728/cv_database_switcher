@echo off
setlocal enabledelayedexpansion


:: Configuration
set "CVPath=C:\ProgramData\Hexagon\CABINET VISION"

echo.
echo Cabinet Vision Selective Database Restore Preparation
echo ===================================================
echo.
echo This will copy the database for ONE selected CV version before using Restore CV.
echo Other CV versions will remain active and untouched.
echo.

:: Check if CV is running
tasklist /FI "IMAGENAME eq cv.exe" 2>NUL | find /I /N "cv.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ERROR: Cabinet Vision is running!
    echo Please close all CV instances before running this preparation.
    echo.
    pause
    exit /b
)

:: Display dashboard of all versions
echo Current Database Status:
echo.

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
        echo   %%~nxi: [!currentDb!] WARNING: !commonStatus!!s2mStatus!
    )
)

if !count!==0 (
    echo No CV installations found!
    pause
    exit /b
)

:: Select CV version to prep
echo.
echo ============================================
echo.
echo Select which CV version to prepare for restore:
echo This will preserve ONLY the selected version
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
    
    echo !vcount!. %%~nxi - currently: !currentDb!
)

echo.
set /p versionChoice=Enter number of version to prep or press Enter to cancel: 

if "%versionChoice%"=="" (
    echo Cancelled.
    pause
    exit /b
)

set "SelectedVersion=!version%versionChoice%!"

if not defined SelectedVersion (
    echo Invalid selection!
    pause
    exit /b
)

set "VersionPath=%CVPath%\%SelectedVersion%"

:: Get current database name for selected version
if exist "%VersionPath%\Database\Database_Name.txt" (
    set /p CurrentDatabase=<"%VersionPath%\Database\Database_Name.txt"
) else (
    set CurrentDatabase=Unknown
)

:: Show what will be preserved for selected version only
echo.
echo ==========================================
echo Preparing: %SelectedVersion%
echo ==========================================
echo.
echo This will copy the current database in %SelectedVersion% ONLY:
echo   %SelectedVersion%: [%CurrentDatabase%] will be copied to "Database - %CurrentDatabase%"

:: Check for Common and S2M variants for selected version
set "CommonPath=%CVPath%\%SelectedVersion:CV =Common %"
if exist "%CommonPath%\Database" (
    if exist "%CommonPath%\Database\Database_Name.txt" (
        set /p commonDb=<"%CommonPath%\Database\Database_Name.txt"
        echo   + Common: [!commonDb!] will be copied to "Database - !commonDb!"
    )
)

set "S2MPath=%CVPath%\%SelectedVersion:CV =S2M %"
if exist "%S2MPath%\Database" (
    if exist "%S2MPath%\Database\Database_Name.txt" (
        set /p s2mDb=<"%S2MPath%\Database\Database_Name.txt"
        echo   + S2M: [!s2mDb!] will be copied to "Database - !s2mDb!"
    )
)

echo.
echo Other CV versions will be left untouched and remain active.
echo.
echo After preparation:
echo 1. %SelectedVersion% database copied to backup folder
echo 2. Original Database folder remains intact for Restore CV
echo 3. Run "Restore CV %SelectedVersion%" to import new client  
echo 4. Run post_import.bat to complete setup
echo.
set /p confirm=Continue with preparation of %SelectedVersion%? Y/N: 
if /i not "%confirm%"=="Y" (
    echo Preparation cancelled.
    pause
    exit /b
)

echo.
echo Preparing %SelectedVersion% for restoration...
echo.

:: Process only the selected CV version
echo Processing %SelectedVersion%...

:: Copy main Database folder
if exist "%VersionPath%\Database - %CurrentDatabase%" (
    echo   Warning: "Database - %CurrentDatabase%" already exists, skipping CV database
) else (
    xcopy "%VersionPath%\Database" "%VersionPath%\Database - %CurrentDatabase%\" /E /I /H /Y /Q
    if errorlevel 1 (
        echo   ERROR: Failed to copy CV database folder
    ) else (
        echo   ✓ CV database copied to "Database - %CurrentDatabase%"
        
        :: Set SQL permissions on copied database files
        echo   Setting SQL permissions on copied database files...
        for %%f in ("%VersionPath%\Database - %CurrentDatabase%\*.mdf" "%VersionPath%\Database - %CurrentDatabase%\*.ldf" "%VersionPath%\Database - %CurrentDatabase%\*.ndf") do (
            if exist "%%f" (
                icacls "%%f" /grant Everyone:F /Q >nul 2>&1
                if errorlevel 1 (
                    echo   Warning: Could not set permissions on %%~nxf
                ) else (
                    echo   ✓ Set permissions on %%~nxf
                )
            )
        )
    )
)

:: Handle Common folder if it exists
if exist "%CommonPath%\Database" (
    if exist "%CommonPath%\Database\Database_Name.txt" (
        set /p commonCurrentDb=<"%CommonPath%\Database\Database_Name.txt"
    ) else (
        set commonCurrentDb=Unknown
    )
    
    if exist "%CommonPath%\Database - !commonCurrentDb!" (
        echo   Warning: Common "Database - !commonCurrentDb!" already exists, skipping
    ) else (
        xcopy "%CommonPath%\Database" "%CommonPath%\Database - !commonCurrentDb!\" /E /I /H /Y /Q
        if errorlevel 1 (
            echo   ERROR: Failed to copy Common database folder
        ) else (
            echo   ✓ Common database copied to "Database - !commonCurrentDb!"
            
            :: Set SQL permissions on copied Common database files
            echo   Setting SQL permissions on copied Common database files...
            for %%f in ("%CommonPath%\Database - !commonCurrentDb!\*.mdf" "%CommonPath%\Database - !commonCurrentDb!\*.ldf" "%CommonPath%\Database - !commonCurrentDb!\*.ndf") do (
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
)

:: Handle S2M folder if it exists
if exist "%S2MPath%\Database" (
    if exist "%S2MPath%\Database\Database_Name.txt" (
        set /p s2mCurrentDb=<"%S2MPath%\Database\Database_Name.txt"
    ) else (
        set s2mCurrentDb=Unknown
    )
    
    if exist "%S2MPath%\Database - !s2mCurrentDb!" (
        echo   Warning: S2M "Database - !s2mCurrentDb!" already exists, skipping
    ) else (
        xcopy "%S2MPath%\Database" "%S2MPath%\Database - !s2mCurrentDb!\" /E /I /H /Y /Q
        if errorlevel 1 (
            echo   ERROR: Failed to copy S2M database folder
        ) else (
            echo   ✓ S2M database copied to "Database - !s2mCurrentDb!"
            
            :: Set SQL permissions on copied S2M database files
            echo   Setting SQL permissions on copied S2M database files...
            for %%f in ("%S2MPath%\Database - !s2mCurrentDb!\*.mdf" "%S2MPath%\Database - !s2mCurrentDb!\*.ldf" "%S2MPath%\Database - !s2mCurrentDb!\*.ndf") do (
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
)

echo   ✓ Original Database folder remains intact for Restore CV

echo.

:: Log the preparation
echo %date% %time% ^| %username% ^| PREP ^| %SelectedVersion% preserved for Restore CV >> "%CVPath%\switch-log.txt"

echo ==========================================
echo Preparation Complete!
echo ==========================================
echo.
echo %SelectedVersion% has been safely prepared for restoration.
echo Original database remains intact for the import process.
echo.
echo What was completed:
echo - Database copied to backup folder with proper SQL permissions
echo - Original Database folder left intact for Restore CV process
echo.
echo Next steps:
echo 1. Run "Restore CV %SelectedVersion% Settings" from Start Menu
echo 2. Select your backup file and restore the new client database
echo 3. Run post_import.bat to set up the new database profile
echo.
echo Other CV versions remain active and untouched.
echo The new database will appear in cv_switch.bat after restoration.
echo.
pause