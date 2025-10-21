# CV Database Manager

A database management tool for Cabinet Vision that enables instant switching between databases. Essential for safely testing quarterly updates (2024.1, 2024.2, etc.) and managing multiple client configurations. Single `cv_manager.bat` file using the proven folder-rename method.

**Open Source** • **Free to Use** • **Community Built**

📖 **[Technical Background - How and Why This Works](docs/Database_Switcher_Technical_Background.md)**
🙏 **[Credits & Attribution](CREDITS.md)** - Built on discoveries by Tristan R, Kevin (Valley Cabinet), and the CV community
📄 **[MIT License](LICENSE)** - Free for personal and commercial use

## Features

### `cv_manager.bat` Features
- **Single entry point** - One script for all operations
- **Intelligent detection** - Automatically finds unconfigured databases and mismatches
- **Mismatch warnings** - Alerts when CV/Common/S2M databases don't match
- **Built-in help** - Detailed explanations of each option
- **Guided workflows** - Step-by-step assistance for complex operations

### Core Capabilities
- Terminal menu system (no GUI needed)
- Auto-detects all CV versions (2023/2024/2025)
- Shows available database profiles
- Process safety check (won't run if CV is open)
- Registry settings preserved between switches
- Synchronizes CV, Common, and S2M databases
- Audit logging with viewer
- Automatic UpdateDatabase run for compatibility

## Quick Start

1. **Run the Manager**:
   - Run `cv_manager.bat` as administrator
   - The script will analyze your system and suggest actions
   - All operations available from one menu

**Note**: If Cabinet Vision databases are not in the default location (`C:\ProgramData\Hexagon\CABINET VISION`), edit line 11 of `cv_manager.bat` to match your database path (not the program files path).

## Usage Example

```
Cabinet Vision Database Manager v2.0
=====================================

System Status:
  CV versions found: 3
  Total database profiles: 5
  WARNING: 1 unconfigured database(s)
  WARNING: 2 database mismatch(es)

=====================================

Main Menu:

1. Dashboard and Switch Databases
2. Setup New Database
3. Prepare for New Client Import
4. View Audit Log
5. Help
6. Exit

Select option (1-6): 1
```

When selecting option 1 (Dashboard and Switch), you'll see:

```
Current Database Status:

  CV 2023: [Internal]
  CV 2024: [Testing] (WARNING: Common:Acme S2M:Production)
  CV 2025: [Unconfigured]

Select CV Version to switch database:
  (or press Enter to return to main menu)

1. CV 2023 (currently: Internal)
2. CV 2024 (currently: Testing)
3. CV 2025 (currently: Unconfigured)

Enter number: 2
```

### Common Use Cases

**Testing Quarterly Updates (Most Common)**:
Cabinet Vision releases quarterly updates (e.g., 2024.1, 2024.2) that overwrite the previous version. This tool lets you:
- Keep your current working database safe before updating
- Test the new quarterly release with a copy of your database
- Instantly roll back if the update causes issues
- Compare behavior between versions using the same data

**Managing Multiple Client Databases**:
- Work with different clients' custom databases
- Switch between production and testing environments
- Keep a clean "factory reset" database for troubleshooting

**Smart Detection**: The manager automatically detects:
- Unconfigured databases needing setup
- Database mismatches between CV/Common/S2M
- Running CV processes that could cause conflicts

### Adding New Clients via Restore CV

1. **Prepare for import**: Select option 3 (Prepare for New Client Import)
   - Shows all CV versions with current database status
   - Select which specific version to prepare for import
   - Preserves selected version's database safely
   - Creates empty Database folder for Restore CV to overwrite

2. **Restore the new client**: Use "Restore CV [Version] Settings" from Start Menu
   - Import your client backup as normal
   - It will overwrite the empty folder (safely)

3. **Complete setup**: Return to the manager, select option 2 (Setup New Database)
   - Manager detects the newly imported database automatically
   - Prompts for client name and creates identifier files
   - Sets SQL permissions on all database files
   - Handles CV, Common, and S2M databases

4. **Start using**: Select option 1 to switch between databases
   - The new client appears in the switcher immediately
   - Switch between clients as normal

**Complete workflow**: Option 3 → Restore CV → Option 2 → Done!

This prevents losing existing database profiles while allowing selective preparation of just the CV version you want to import into.

## Technical Details

Based on Tristan's proven folder-rename approach with:
- Process checking (prevents corruption)
- Dynamic version/database discovery (no hardcoding)
- Clear confirmations and error handling with rollback
- Readable terminal interface with status indicators
- Comprehensive audit logging with built-in viewer
- Single file solution (~730 lines)

## Credits & License

This tool builds upon methods discovered and shared by the Cabinet Vision community:
- **Tristan R** - Original database switching method and implementation (2020-2023)
- **Kevin (Valley Cabinet)** - Version switching discovery (2023)
- **John "Zeke" Charles** - Co-discoverer and technical insights
- **The Cabinet Visionary (TCV)** - Historical context and validation

**Implementation:** Kyle - [Nomadtek Consulting](https://nomadtekconsulting.com)

See [CREDITS.md](CREDITS.md) for detailed attribution.

Released under the [MIT License](LICENSE) - free for personal and commercial use.