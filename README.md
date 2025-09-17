# CV Database Switcher - Simple Terminal Version

A suite of 3 batch files that manages Cabinet Vision databases using the proven folder-rename method.

📖 **[Technical Background - How and Why This Works](docs/Database_Switcher_Technical_Background.md)**

## Features
- Terminal menu system (no GUI needed)
- Auto-detects all CV versions (2023/2024/2025)
- Shows available database profiles
- Process safety check (won't run if CV is open)
- Registry settings preserved between switches
- Synchronizes CV, Common, and S2M databases
- Audit logging
- Automatic UpdateDatabase run for compatibility

## Setup

1. **Set up Database Identifiers** (First Time):
   - Run `bat files/setup_identifiers.bat` as administrator
   - Enter a profile name for your current database (e.g., "Factory Reset", "Clean Install")
   - Script handles SQL permissions and creates identifier files automatically

2. **Run the Switcher**:
   - Run `bat files/cv_switch.bat` as administrator  
   - Follow the numbered menu prompts

## Usage Example

```
Cabinet Vision Database Switcher / Dashboard
============================================

Current Database Status:

  CV 2023: [Internal]
  CV 2024: [Testing]
  CV 2025: [Acme] (WARNING: Common:Testing S2M:Production )

============================================

Select CV Version to switch database:
  (or press Enter to exit if just checking status)

1. CV 2023 (currently: Internal)
2. CV 2024 (currently: Testing)
3. CV 2025 (currently: Acme)

Enter number (or press Enter to exit): 2

Current Database: [Testing]

Available Databases:
1. Acme
2. Internal
3. Production

Select database to switch to: 1

========================================
Switching from: [Testing]
           to: [Acme]
    Version: CV 2024
========================================

Continue? (Y/N): Y

Saving registry settings...
Switching databases...
Switching Common database...
Switching S2M database...
Restoring registry settings...

========================================
Database switch successful!
Now using: [Acme]
========================================

Starting UpdateDatabase...
```

### Dashboard-Only Mode

Just press Enter at the version selection to exit after viewing the current status - perfect for quickly checking which databases are active without making any changes.

### Mismatch Warnings

If Common or S2M databases don't match the main CV database, you'll see warnings like:
- `(WARNING: Common:Testing S2M:Production )` - Shows which databases are out of sync
- This helps identify when database folders got switched independently

### Adding New Clients via Restore CV

When importing a new client database using Restore CV (which overwrites existing databases):

1. **Before restoring**: Run `bat files/prep_for_restore.bat`
   - Shows all CV versions with current database status
   - Select which specific version to prepare for import
   - Preserves selected version's database safely (others remain untouched)
   - Creates empty Database folder for Restore CV to overwrite

2. **Restore the new client**: Use "Restore CV [Version] Settings" from Start Menu
   - Import your client backup as normal
   - It will overwrite the empty folder (safely)

3. **Complete setup**: Run `bat files/setup_identifiers.bat`
   - Automatically detects the newly imported database
   - Prompts for client name and creates identifier files
   - Sets SQL permissions on all database files
   - Handles CV, Common, and S2M databases

4. **Start using**: Run `bat files/cv_switch.bat`
   - The new client appears in the switcher immediately
   - Switch between clients as normal

**Complete workflow**: `prep_for_restore.bat` → Restore CV → `setup_identifiers.bat` → Done!

This prevents losing existing database profiles while allowing selective preparation of just the CV version you want to import into.

## Improvements over Original

Based on Tristan's proven approach with minimal additions:
- Process checking (prevents corruption)
- Dynamic version/database discovery (no hardcoding)
- Clear confirmations
- Error handling with rollback
- Readable terminal interface

Total: ~236 lines (vs 20 original, but much more flexible)