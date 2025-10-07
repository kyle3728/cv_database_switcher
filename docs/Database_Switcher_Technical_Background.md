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

## The Three Scripts

### cv_switch.bat (Main Switcher)
Provides the interactive switching interface:
- Displays dashboard showing all CV versions and current databases
- Detects mismatches between CV, Common, and S2M databases
- Prevents switching if CV is running
- Performs the folder renaming operations
- Handles registry backup/restore
- Launches UpdateVersion automatically
- Logs all operations

### setup_identifiers.bat (Database Configuration)
Sets up new databases for the switching system:
- Creates Database_Name.txt identifier files
- Sets SQL permissions on database files
- Handles all three database types (CV, Common, S2M)
- Used after importing new databases or fresh installs

### prep_for_restore.bat (Import Preparation)
Prepares for importing new client databases via Restore CV:
- Preserves current database by copying it
- Handles selective version preparation
- Sets SQL permissions on backed-up files
- Removes old identifiers for clean import

## Workflow Examples

### Adding a New Client Database

1. **Prepare**: Run `prep_for_restore.bat`
   - Select CV version to prepare
   - Current database is copied to "Database - [Name]"
   - Original Database folder left for Restore CV

2. **Import**: Use Restore CV from Start Menu
   - Import client's backup file
   - Overwrites the Database folder

3. **Configure**: Run `setup_identifiers.bat`
   - Name the new database
   - Creates identifier files
   - Sets SQL permissions

4. **Use**: Run `cv_switch.bat` to switch between databases

### Daily Database Switching

1. Run `cv_switch.bat` as administrator
2. Select CV version (2023, 2024, or 2025)
3. Choose target database from list
4. Confirm switch
5. Script handles:
   - Registry save/restore
   - Folder renaming for all three databases
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