# Cabinet Vision UpdateVersion Utility - Complete Documentation

## File Locations
- **Primary Documentation**: `/HTML_Extracted/2025/CVEnglish/Introduction/CABINET_VISION_Startup_Group/Update_Version.htm`
- **Startup Group Reference**: `/HTML_Extracted/2025/CVEnglish/Introduction/CABINET_VISION_Startup_Group/CABINET_VISION_startup_group.htm`
- **Database Information**: `/HTML_Extracted/2025/CVEnglish/Tips_Tricks_FAQs/The_Databases/CVData_mdf.htm`

## Overview
The UpdateVersion utility is a critical maintenance tool that ensures Cabinet Vision database integrity and compatibility when updating to new versions or builds.

## How to Access
### Windows 11
1. Click Windows Start Button
2. Click **All apps**
3. Scroll to **CABINET VISION 2025** group
4. Select **Update Version for CV 2025**

### Windows 10 and Earlier
1. Click Start
2. Navigate to **All Programs**
3. Find **CABINET VISION 2025**
4. Select **Update Version for CV 2025**

## What UpdateVersion Does

The UpdateVersion utility performs five critical functions in sequence:

### 1. Create Backups
- **Purpose**: Creates a complete set of database backups
- **Benefit**: Provides a restore point if you need to revert
- **Location**: Backups stored in `C:\ProgramData\Hexagon\CABINET VISION\Common 2025\Automatic Backups\`
- **Format**: Timestamped folder with date and time of backup

### 2. Cleanup Databases
- **Purpose**: Scans and removes errors from database files
- **Process**: Validates database integrity
- **Files Affected**:
  - CVData.mdf (main database)
  - Report.mdf (reports database)
  - ManageIT.accdb (xCRM database)

### 3. Compact Databases
- **Purpose**: Removes empty space in Cabinet Vision database files
- **Benefit**: Improves performance and reduces file size
- **Technical**: Reorganizes database pages for optimal storage

### 4. Update Databases
- **Purpose**: Modifies database structure for new version compatibility
- **Changes**:
  - Adds new fields required by updated features
  - Modifies existing tables for compatibility
  - Updates stored procedures and indexes
- **Critical**: Required when moving between Cabinet Vision versions

### 5. Register Files
- **Purpose**: Re-registers system files used by Cabinet Vision
- **Components**:
  - COM components
  - .NET assemblies
  - System DLLs
- **Benefit**: Ensures all components are properly registered with Windows

## Progress Window
During the update process, you'll see a progress window showing:
- Current operation being performed
- Progress bar for each step
- Status messages
- Any errors or warnings encountered

## When to Use UpdateVersion

### Required Scenarios
1. **After Installing New Version**: Always run after upgrading Cabinet Vision
2. **After Build Updates**: Required after installing service packs or builds
3. **Database Corruption**: If experiencing database errors or corruption
4. **Performance Issues**: When Cabinet Vision is running slowly
5. **Before Major Projects**: As preventive maintenance

### Automatic Triggers
UpdateVersion may run automatically when:
- Cabinet Vision detects version mismatch
- Database structure needs updating
- Critical updates are installed

## Important Notes

### Before Running
- **Close Cabinet Vision**: Ensure all instances are closed
- **Backup Jobs**: Save any open jobs before starting
- **Network Users**: Ensure all network users have exited Cabinet Vision
- **Disk Space**: Verify adequate space for backup creation

### During Process
- **Do Not Interrupt**: Let the process complete
- **Time Required**: Can take 5-30 minutes depending on database size
- **Network**: Process may be slower on network installations

### After Completion
- **Verify Operation**: Check that Cabinet Vision opens normally
- **Test Standards**: Verify construction methods and materials
- **Check UCS**: Test User Created Standards functionality

## Database Files Affected

| File | Location | Purpose |
|------|----------|---------|
| CVData.mdf | `C:\ProgramData\Hexagon\CABINET VISION\Common 2025\Database\` | Main database - Construction methods, materials, doors, UCS |
| Report.mdf | `C:\ProgramData\Hexagon\CABINET VISION\CV 2025\Database\` | Report definitions and current job data |
| Default.dat | `C:\ProgramData\Hexagon\CABINET VISION\CV 2025\` | Layer schedules and dimension styles |
| DefaultCLST.dat | `C:\ProgramData\Hexagon\CABINET VISION\CV 2025\` | Closet module layer schedules |
| ManageIT.accdb | `C:\ProgramData\Hexagon\CABINET VISION\CV 2025\Repository\` | xCRM customer information |

## Troubleshooting

### Common Issues
1. **"Database is in use" Error**
   - Solution: Ensure all Cabinet Vision instances are closed
   - Check Task Manager for CV processes

2. **"Insufficient Permissions" Error**
   - Solution: Run as Administrator
   - Check folder permissions

3. **Process Fails During Update**
   - Solution: Restore from automatic backup
   - Contact technical support

### Recovery Options
If UpdateVersion fails:
1. Use **Restore CV 2025 Settings** to restore backup
2. Manually copy backup files from Automatic Backups folder
3. Contact Cabinet Vision technical support

## Related Utilities
- **Backup CV 2025 Settings**: Create manual backups
- **Restore CV 2025 Settings**: Restore from backups
- **System Information 2025**: Diagnostic tool
- **Update S2M CENTER 2025 Databases**: For S2M Center updates

## Best Practices
1. Run UpdateVersion after every Cabinet Vision update
2. Create manual backup before major version upgrades
3. Document any custom UCS before updating
4. Test thoroughly after update completes
5. Keep at least 3 automatic backups

## Technical Details
- Creates restore point automatically
- Uses SQL Server Compact for database operations
- Maintains backward compatibility where possible
- Preserves custom settings and configurations
- Updates registry entries as needed

---
*Documentation based on Cabinet Vision 2025 Help Files*