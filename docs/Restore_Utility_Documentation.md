# Cabinet Vision Restore Utility - Complete Documentation

## File Locations
- **Primary Documentation**: `/HTML_Extracted/2025/CVEnglish/Introduction/CABINET_VISION_Startup_Group/CABINET_VISION_startup_group.htm`
- **Backup Utility Documentation**: `/HTML_Extracted/2025/CVEnglish/System_Level/Ribbonbar/Utilities_Tab/Tools_Group/SL_Backup_Utility.htm`
- **Transfer Standards Guide**: `/HTML_Extracted/2025/CVEnglish/Tips_Tricks_FAQs/Computer_Specific/Transfer_Standards.htm`
- **Job Recovery**: `/HTML_Extracted/2025/CVEnglish/Introduction/File_Menu/The_CV_Button.htm`

## Overview
The Restore CV Settings utility allows restoration of Cabinet Vision databases and settings from backups created by:
- CV Backup Utility
- Automatic backups during installations
- UpdateVersion automatic backups
- Manual backup operations

## How to Access

### Windows 11
1. Click Windows Start Button
2. Click **All apps**
3. Scroll to **CABINET VISION 2025** group
4. Select **Restore CV 2025 Settings**

### Windows 10 and Earlier
1. Click Start
2. Navigate to **All Programs**
3. Find **CABINET VISION 2025**
4. Select **Restore CV 2025 Settings**

## Restore Interface

### Main Window Components
1. **Left Panel**: Available Backup Folders
   - Shows all backups in Automatic Backups folder
   - Listed by date/time stamp
   - Includes manual and automatic backups

2. **Right Panel**: Files Within Selected Backup
   - Displays all files in selected backup
   - Shows file sizes and dates
   - Checkboxes to select files for restoration

### File Selection Options
- Select individual files using checkboxes
- Select all files for complete restoration
- Mix and match files as needed

## Types of Restorable Content

### Core Database Files

| File | Contents | When to Restore |
|------|----------|-----------------|
| **CVData.mdf** | Construction methods, materials, material schedules, doors, parts, UCS, Intelli-Joints | After database corruption or unwanted changes |
| **Report.mdf** | Reports, report groups, bid rate tables, current job data | When reports are missing or corrupted |
| **Default.dat** | Layer schedules and dimension styles (Cabinet module) | When layer settings are lost |
| **DefaultCLST.dat** | Layer schedules and dimension styles (Closet module) | When closet layer settings are lost |
| **ManageIT.accdb** | xCRM customer information database | When customer data is corrupted |

### Configuration Files
- **.cfg files**: Job property schemes
- **System Parameters**: Windows Registry settings
- **Posts**: CNC post processor configurations

### Graphics and Textures
- **Assigned Material Textures**: Graphics linked to materials
- **All Graphics**: Complete Graphics folder contents

## Restoration Process

### Step 1: Preparation
1. **Close Cabinet Vision** completely
2. Verify all network users have exited
3. Locate backup to restore from

### Step 2: Select Backup Source
Backups can come from:
- **Automatic Backups Folder**: `C:\ProgramData\Hexagon\CABINET VISION\Common 2025\Automatic Backups\`
- **Manual Backup Location**: User-specified location
- **Transferred Backup**: From USB or network location

### Step 3: Run Restore Utility
1. Launch **Restore CV 2025 Settings** from Start Menu
2. Select backup folder from left panel
3. Check files to restore in right panel
4. Click **OK** to begin restoration

### Step 4: Restoration Process
The utility will:
1. Copy selected files to appropriate locations
2. Run necessary update routines
3. Update database structures if needed
4. Re-register components

### Step 5: Post-Restoration
1. Launch Cabinet Vision
2. Verify restoration success
3. Test critical functions
4. Regenerate door icons if needed

## Special Restoration Scenarios

### Transferring Standards Between Versions
Use when moving from older Cabinet Vision versions:

1. **Create Backup in Old Version**
   - Open old version
   - Go to Utilities → Backup Utility
   - Include all necessary components
   - Save backup

2. **Transfer Backup Folder**
   - Copy backup folder from old version's Automatic Backups
   - Paste to new version's Automatic Backups folder
   - Path: `C:\ProgramData\Hexagon\CABINET VISION\Common 2025\Automatic Backups\`

3. **Restore in New Version**
   - Run Restore CV 2025 Settings
   - Select transferred backup
   - Choose files to restore
   - Click OK

### Job File Recovery (.bak files)
For recovering individual job files:

1. **Enable Backup on Open** (Preferences)
   - Creates .bak file when opening jobs
   - Stored in same folder as .cvj file

2. **Recover Job**
   - Locate .bak file
   - Rename from .bak to .cvj
   - Open in Cabinet Vision

### Network Installation Restoration
Special considerations for network setups:

1. Ensure all users logged out
2. Run restore from server
3. Update all client workstations
4. Verify network paths

## Post-Restoration Tasks

### Required Updates

1. **Door Manager Icons**
   - Open Door Manager
   - Go to Utilities
   - Run Generate Icons

2. **S2M Center Configuration**
   - Reselect primary/secondary machines
   - Create new output directory path
   - Reselect post processor paths
   - Re-enter post codes if applicable

3. **Verify Critical Components**
   - Construction methods
   - Material Manager settings
   - User Created Standards
   - Report definitions
   - Hardware configurations

## Backup Locations Reference

| Backup Type | Default Location |
|-------------|------------------|
| Automatic Backups | `C:\ProgramData\Hexagon\CABINET VISION\Common 2025\Automatic Backups\` |
| Job Files | `C:\Users\Public\Documents\CABINET VISION\CV 2025\` |
| Database Files | `C:\ProgramData\Hexagon\CABINET VISION\Common 2025\Database\` |
| Configuration | `C:\ProgramData\Hexagon\CABINET VISION\CV 2025\` |
| Graphics | `C:\ProgramData\Hexagon\CABINET VISION\CV 2025\Database\Graphics\` |

## Important Warnings

### Version Compatibility
- Jobs edited in newer versions cannot be used in older versions
- Always keep copies of original jobs before upgrading
- Test restored standards thoroughly before production

### Database Integrity
- Restoration overwrites existing files
- Cannot undo restoration process
- Backup current state before restoring

### Network Considerations
- All users must be logged out
- Network paths may need reconfiguration
- Client workstations may need updating

## Troubleshooting

### Common Issues

1. **"Cannot find backup folder"**
   - Verify backup exists in Automatic Backups folder
   - Check folder permissions
   - Ensure correct path

2. **"Database in use"**
   - Close all Cabinet Vision instances
   - Check Task Manager for processes
   - Restart computer if necessary

3. **"Restoration failed"**
   - Check disk space
   - Verify file permissions
   - Try restoring individual files

4. **Missing functionality after restore**
   - Run UpdateVersion utility
   - Regenerate required components
   - Verify all files were selected

### Recovery Options
If restoration fails:
1. Try restoring from different backup
2. Restore files individually
3. Manually copy database files
4. Contact technical support

## Best Practices

### Before Restoration
1. Document current settings
2. Create backup of current state
3. Note any customizations
4. Close all Cabinet Vision instances

### During Restoration
1. Don't interrupt the process
2. Select appropriate files carefully
3. Monitor for error messages
4. Allow sufficient time

### After Restoration
1. Test all critical functions
2. Verify custom settings
3. Regenerate necessary components
4. Document what was restored

## Related Utilities

- **Backup CV 2025 Settings**: Creates backups
- **Update Version**: Updates and repairs databases
- **System Information 2025**: Diagnostic information
- **Network Administrator 2025**: User access rights

## Command Line Options
The Backup utility (which creates restorable backups) supports:
- `/e` - Create email with zip attachment
- `/d` - Delete backups after creation
- `/g` - Silent backup using last settings

Example: `CVBackup.exe /e /d`

---
*Documentation based on Cabinet Vision 2025 Help Files*