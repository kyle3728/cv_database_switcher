# Cabinet Vision Database Switcher - Technical Background

## The Problem

Cabinet Vision is designed to work with a single database at a time. Users who need multiple databases (different clients, testing environments, version comparisons) traditionally had to backup and restore entire databases each time they wanted to switch - a time-consuming and error-prone process.

## The Core Discovery

In 2020, Cabinet Vision users on the forum discovered that CV uses a simple folder-based database selection method. The software always reads from a folder named exactly "Database" in its installation directory:

```
C:\ProgramData\Hexagon\CABINET VISION\CV 2025\
├── Database\              <- CV always uses this folder
├── Database - Client A\   <- Ignored by CV
├── Database - Client B\   <- Ignored by CV
└── Database - Testing\    <- Ignored by CV
```

To switch databases, you simply rename the folders - make the active "Database" folder something else, then rename your desired database folder to "Database". Cabinet Vision immediately uses whatever database is in the folder named "Database".

## Implementation Evolution

The original implementation by Tristan R was a 20-line batch script that:
1. Renamed the current Database folder
2. Renamed the desired database to Database
3. Saved and restored registry settings
4. Ran UpdateVersion for compatibility

This evolved into today's 800+ line implementation with critical improvements:
- Process checking to prevent corruption if CV is running
- Automatic detection of all CV versions
- Synchronization of Common and S2M databases
- Switching of layer/dimension style files (Default.dat, DefaultCLST.dat)
- Complete registry isolation (delete before import to prevent contamination)
- Error handling and rollback capabilities
- Database identification files
- Audit logging

## Critical Components

### Three Database Locations

Cabinet Vision actually uses three related databases that must stay synchronized:

1. **Main Database**: `CV 2025\Database\` - Construction methods, materials, hardware
2. **Common Database**: `Common 2025\Database\` - Shared components across CV versions
3. **S2M Database**: `S2M 2025\Database\` - CNC and machining data

When switching, all three must be switched together or you'll get mismatches and potential data corruption.

### SQL Server Permissions

When Windows copies database files (*.mdf, *.ldf), it removes SQL Server's permissions. The scripts handle this by:
1. Temporarily granting "Everyone" full control on copied files
2. Running UpdateVersion which re-establishes proper SQL permissions
3. This is why admin privileges are required

Without fixing permissions, you'll get SQL errors like "Database cannot be opened due to inaccessible files".

### Registry Settings Preservation

Cabinet Vision stores user preferences in the Windows Registry at:
```
HKEY_CURRENT_USER\Software\Hexagon\CABINET VISION\CV [version]\Settings
```

**Note for Legacy Versions**: Pre-2021 Cabinet Vision versions use a different registry path (`Software\Cabinet Vision\Solid_[version]`). If using older versions, update the registry path in cv_switch.bat line 182 accordingly.

Each database maintains its own registry export (Settings.reg) so when you switch databases, you also get the workspace configuration, preferences, and settings associated with that database.

**Registry Isolation**: To prevent settings contamination between profiles, the manager deletes the registry branch before importing each profile's settings. This ensures complete isolation - no mixing of parameters from different clients or database configurations. The setup process also checks for missing System Parameters during profile configuration, warning users when imported backups don't include these registry settings.

### UpdateVersion Integration

After switching databases, UpdateVersion must run to:
- Update database schemas to match the current CV version
- Re-register COM components and system files
- Rebuild indexes and repair any corruption
- Compact database files for optimal performance

This is critical because databases from different clients or time periods may have:
- Different CV version schemas (2023 database in 2025 software)
- Accumulated corruption or orphaned data
- Missing system file registrations
- Incompatible structures

Without UpdateVersion, switched databases may appear to work but fail when accessing certain features.

## The Unified Manager

### cv_manager.bat
A single, integrated script providing all database management functionality through an interactive menu system:

**Core Features:**
- Dashboard showing all CV versions and current databases
- Detects mismatches between CV, Common, and S2M databases
- Prevents switching if CV is running
- Performs folder renaming operations for all three database types
- Handles registry backup/restore
- Launches UpdateVersion automatically
- Comprehensive audit logging with built-in viewer

**Main Menu Options:**

1. **Dashboard and Switch Databases** - View status and switch between database profiles
2. **Setup New Database** - Configure newly imported or created databases
3. **Prepare for New Client Import** - Prepare for importing via Restore CV utility
4. **View Audit Log** - Review history of all database operations
5. **Help** - Detailed guidance for each operation

**Intelligent Detection:**
- Automatically finds all CV versions (2023/2024/2025)
- Detects unconfigured databases needing setup
- Warns about database mismatches between CV/Common/S2M
- Shows system status and suggests appropriate actions

## Workflow Examples

### Adding a New Client Database

1. **Prepare**: Run `cv_manager.bat` → Option 3 (Prepare for New Client Import)
   - Select which CV version to prepare
   - Current database is preserved as "Database - [Name]"
   - Empty Database folder created for Restore CV to overwrite

2. **Import**: Use "Restore CV [Version] Settings" from Windows Start Menu
   - Import client's backup file as normal
   - Overwrites the empty Database folder

3. **Configure**: Return to `cv_manager.bat` → Option 2 (Setup New Database)
   - Manager automatically detects the newly imported database
   - Enter client name for the database profile
   - Script creates identifier files and sets SQL permissions

4. **Use**: `cv_manager.bat` → Option 1 to switch between databases anytime

### Daily Database Switching

1. Run `cv_manager.bat` as administrator
2. Manager displays system status and warnings (if any)
3. Select Option 1 (Dashboard and Switch Databases)
4. Select CV version and target database from list
5. Confirm switch
6. Manager automatically handles:
   - Registry save/restore (with complete isolation via delete before import)
   - Folder renaming for all three databases (CV/Common/S2M)
   - Layer/dimension style file switching (Default.dat, DefaultCLST.dat)
   - UpdateVersion execution
   - Audit logging

## Technical Details

### Database File Structure
Each database folder contains:
- `CVData.mdf` - Main SQL Server database
- `CVData_log.ldf` - SQL Server transaction log
- `report.accdb` - Report Center database
- `psnc.accdb` - S2M CENTER catalogs
- `Database_Name.txt` - Identifier file (added by setup script)
- `Settings.reg` - Registry backup for this database

Additionally, each CV version maintains profile-specific layer settings:
- `Default.dat` - Layer schedules and dimension styles (Cabinet module)
- `DefaultCLST.dat` - Layer schedules and dimension styles (Closet module)

These files are switched along with databases to maintain complete profile isolation.

### Safety Features
- **Process Checking**: Verifies CV isn't running before switching
- **Atomic Operations**: Rollback if any rename fails
- **Audit Trail**: Logs all switches with timestamp and user
- **Version Detection**: Automatically finds all CV installations
- **Mismatch Warnings**: Alerts when databases aren't synchronized

### Version Switching Extension

In 2023, Kevin from Valley Cabinet discovered the same rename method works for CV versions. By renaming the program folder before installing updates, you can maintain multiple CV versions:

```
C:\Program Files\Hexagon\CABINET VISION\
├── CV 2023\        <- Active version (CV looks here)
├── CV 2023.1\      <- Preserved old version
└── CV 2023.2\      <- Another preserved version
```

This allows testing new versions without losing the ability to rollback.

## Why This Works

Cabinet Vision's database selection is remarkably simple - it just looks for a folder named "Database" and uses whatever is inside. This simplicity, combined with the UpdateVersion utility's ability to ensure compatibility, makes the folder-rename method both robust and reliable.

The community-developed solution has been proven since CV version 10 and continues to work with the latest 2025 releases. By understanding how CV's database selection works and properly managing the three database locations, registry settings, and SQL permissions, users can efficiently manage multiple databases without the overhead of constant backup/restore operations.