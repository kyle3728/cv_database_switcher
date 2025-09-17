# Cabinet Vision Database Applications Technical Report
## Update Version and Restore CV Applications Analysis

**Version:** 2024-2025  
**Date:** January 2025  
**Purpose:** Technical documentation for building a Cabinet Vision database switcher

---

## Executive Summary

This report provides comprehensive technical documentation for the **Update Version** and **Restore CV** applications that are part of the Cabinet Vision ecosystem. These applications serve distinct but complementary roles: Update Version maintains and modifies existing databases in-place (with limited database-only backups), while Restore CV replaces current databases with backup data from CV Backup Utility. A critical finding is that Update Version's backups appear to be database-only and their compatibility with Restore CV is undocumented, requiring the use of CV Backup Utility for comprehensive backups. This analysis is intended to support the development of a database switcher application that integrates with Cabinet Vision's existing infrastructure.

---

## 1. Application Overview and Key Distinctions

### 1.1 Update Version Application

**Primary Function:** In-place database maintenance, optimization, and version migration

**Location:** 
- Start Menu: `CABINET VISION 2025 > Update Version for CV 2025`
- Executable Path: `C:\Program Files\Hexagon\CABINET VISION\CV 2025\`

**Core Operations:**
- **Modifies existing databases** without replacement
- **Creates database backups** before making changes (scope limited to database files only)
- **Performs schema updates** for version compatibility (2022→2025)
- **Cleans and compacts** databases to remove corruption and optimize storage
- **Re-registers system files** (DLLs and OCX) required by Cabinet Vision

**Important Note:** Update Version creates "database backups" which appear to be limited to core database files (CVData.mdf, etc.), not the comprehensive system backups created by CV Backup Utility

**Use Cases:**
- Cabinet Vision version upgrades
- Database corruption repairs
- Routine maintenance and optimization
- System file registration issues
- Pre-migration preparation for database switching

### 1.2 Restore CV Application

**Primary Function:** Complete database replacement from backup files

**Location:**
- Start Menu: `CABINET VISION 2025 > Restore CV 2025 Settings`
- Version-specific naming (e.g., "Restore CV 2024 Settings")

**Core Operations:**
- **Replaces entire database** with backup version
- **Provides interactive UI** for selective restoration
- **Processes CV Backup Utility files** (.bak, automatic backups)
- **Overwrites current configuration** with backup settings
- **Calls Update Version post-restore** to ensure compatibility

**Use Cases:**
- Disaster recovery after corruption
- Reverting to previous configurations
- System migration to new hardware
- Testing different database setups
- Implementing database switches in a switcher application

### 1.3 Critical Operational Differences

| Aspect | Update Version | Restore CV |
|--------|----------------|------------|
| **Database Impact** | Modifies in-place | Complete replacement |
| **Data Source** | Current live database | Backup files only |
| **User Interaction** | Automated process | Interactive selection |
| **Backup Behavior** | Creates new backups | Uses existing backups |
| **Primary Risk** | Potential data modification | Complete data overwrite |

---

## 2. Database Architecture

### 2.1 Primary Database Files

#### CVData.mdf (SQL Server Master Data File)
- **Function:** Central repository for all Cabinet Vision and S2M CENTER data
- **Update Version Role:** Modifies schema, compacts, and repairs this file
- **Restore CV Role:** Completely replaces this file with backup version
- **Content Structure:**
  - Assembly catalog objects with cross-references
  - Material definitions, properties, and pricing
  - Construction methods and parameters
  - Hardware connection specifications
  - System configuration data

#### Secondary Database Files
- **report.accdb** - Report Center data (Update Version: maintains; Restore CV: replaces)
- **psnc.accdb** - S2M CENTER catalogs (both apps handle differently)
- **BidData.accdb** - Bid Center database
- **prices.accdb** - Simple Price Table
- **MatSum.mdb** - Material summaries (legacy format)

### 2.2 SQL Server Integration

**Version Support:**
- SQL Server 2008 R2 Express (SP1)
- SQL Server 2012 Express (SP3)
- SQL Server 2019 Express

**Application-Specific Behaviors:**
- **Update Version:** Runs SQL DDL scripts to modify schema, uses SQL maintenance commands
- **Restore CV:** Detaches current database, copies backup files, re-attaches database
- **Connection Handling:** Both applications update connection strings post-operation

---

## 3. System Integration Architecture

### 3.1 Registry Configuration

**Update Version Registry Operations:**
- Updates version-specific keys during upgrades
- Modifies database connection strings for new schemas
- Maintains user preferences during updates
- Creates new registry entries for version migrations

**Restore CV Registry Operations:**
- Replaces entire registry sections with backup data
- Restores previous connection strings
- Reverts user preferences to backup state
- May downgrade registry entries to match backup version

**Key Registry Paths:**
```
HKEY_LOCAL_MACHINE\SOFTWARE\Hexagon\CABINET VISION\[Version]
├── DatabasePath (modified by Update Version, replaced by Restore CV)
├── ServerInstance (maintained vs. replaced)
├── ConnectionString (updated vs. restored)
└── SystemParameters (preserved vs. overwritten)
```

### 3.2 File System Integration

**Update Version File Operations:**
```
C:\Program Files\Hexagon\CABINET VISION\CV 2025\
├── Registers/re-registers system DLLs
├── Updates configuration files in-place
├── Maintains file structure integrity
└── Creates backup copies before modifications
```

**Restore CV File Operations:**
```
C:\ProgramData\Hexagon\CABINET VISION\Common [Year]\Automatic Backups\
├── Reads backup file manifests
├── Extracts compressed backup data
├── Replaces entire directory structures
└── Overwrites existing configurations
```

### 3.3 Network Configuration

**Multi-User Considerations:**
- **Update Version:** Can update network databases with users offline
- **Restore CV:** Requires exclusive database access (no active users)
- **Database Locking:** Update Version uses row-level locks; Restore CV needs exclusive locks
- **Network Path Handling:** Both validate network paths differently

---

## 4. Backup and Restore Mechanisms

### 4.1 Backup Creation and Usage

**Important Distinction - Two Types of Backups:**
1. **Database Backups** (Update Version) - Limited to database files only
2. **Comprehensive System Backups** (CV Backup Utility) - Full system including databases, graphics, registry, configuration files

**Update Version Backup Behavior:**
- Automatically creates timestamped database backups before operations
- Stores in: `Automatic Backups\UpdateVersion_[timestamp]\`
- Backup scope: Database files only (CVData.mdf and related database files)
- Cannot be disabled (safety feature)
- **Note:** Documentation unclear if these backups are compatible with Restore CV

**Restore CV Backup Requirements:**
- Documented to work with backups from CV Backup Utility
- Backup sources explicitly mentioned in documentation:
  - Manual backups via CV Backup Utility (comprehensive)
  - Automatic installation backups (comprehensive)
- **Uncertainty:** Documentation does not confirm if Update Version's database-only backups can be restored via Restore CV
- Validates backup integrity before restoration

### 4.2 CV Backup Utility Integration

**Command Line Interface:**
```bash
CVBackup.exe /g /p /z    # Silent backup with compression (CV Backup Utility)
```

**Backup Components - Critical Differences:**
- **Update Version:** Creates database-only backups (not using CVBackup.exe)
  - Limited to CVData.mdf and related database files
  - Does NOT include graphics, registry, configuration files
  - Internal backup mechanism (not CV Backup Utility)
  
- **CV Backup Utility:** Creates comprehensive backups including:
  - Core database files (CVData.mdf, report.accdb, etc.)
  - Graphics and material textures
  - Registry settings (System Parameters)
  - Configuration files and job schemes
  - Post-processor files
  - User Created Standards
  
- **Restore CV:** Works with CV Backup Utility backups
  - Allows selective restoration of components
  - Can restore database only or full system
  - Compatibility with Update Version backups is undocumented

### 4.3 Restoration Process Workflow

**Update Version Post-Backup Flow:**
1. Create database-only backup (limited scope)
2. Perform in-place modifications
3. Validate changes
4. Keep backup for potential database rollback (not full system restore)

**Restore CV Restoration Flow:**
1. Display available backups
2. User selects components
3. Exclusive lock on database
4. Replace selected components
5. Call Update Version for compatibility check
6. Restart services

---

## 5. Version Management and Migration

### 5.1 Version-Specific Behaviors

**Update Version Migration Process:**
- Detects current database version
- Applies incremental schema updates
- Preserves user data during migration
- Updates version markers in database
- Maintains data integrity throughout

**Restore CV Version Handling:**
- Can restore older version databases
- Automatically detects version mismatch
- Calls Update Version if restoration is from older version
- Handles version downgrade scenarios
- May require additional user confirmation

### 5.2 Multi-Version Coexistence

**Registry Separation:**
- Update Version maintains separate keys per version
- Restore CV can cross-restore between versions
- Version conflicts handled differently by each application

**Database Compatibility Matrix:**
| From Version | To Version | Update Version | Restore CV |
|--------------|------------|----------------|------------|
| 2022 | 2025 | Direct upgrade path | Restore + Update |
| 2025 | 2022 | Not supported | Direct restore |
| Same version | Same version | Maintenance only | Full restore |

---

## 6. Network and Multi-User Management

### 6.1 Application-Specific Network Behaviors

**Update Version Network Operations:**
- Can operate with database server online
- Minimal downtime requirements
- Progressive updates minimize user impact
- Supports rolling updates in some scenarios

**Restore CV Network Requirements:**
- Requires all users disconnected
- Complete database server access needed
- Network share permissions for backup access
- More disruptive to operations

### 6.2 Database Connection Management

**Connection String Updates:**
- **Update Version:** Modifies existing connection parameters
- **Restore CV:** Replaces entire connection configuration
- **Failover Handling:** Different strategies for each application

---

## 7. Database Switcher Implementation Requirements

### 7.1 Leveraging Application Strengths

**Update Version Integration Points:**
- Use for pre-switch database optimization
- Leverage backup creation capabilities
- Utilize schema update functions for compatibility
- Call for post-switch file registration

**Restore CV Integration Points:**
- Core mechanism for database switching
- Use selective restoration for flexibility
- Leverage existing backup validation
- Integrate UI for switch operations

### 7.2 Recommended Architecture

**Database Switch Workflow:**
```
1. Pre-Switch Phase
   ├── Validate current database (Update Version)
   ├── Create comprehensive backup (CV Backup Utility - NOT Update Version)
   │   └── Must use CVBackup.exe for full system backup
   ├── Optimize database (Update Version)
   └── Register system files (Update Version)

2. Switch Phase (Restore CV)
   ├── Lock database exclusively
   ├── Select target backup/database
   │   └── Ensure backup is from CV Backup Utility
   ├── Perform restoration
   └── Update configuration

3. Post-Switch Phase (Update Version)
   ├── Verify database compatibility
   ├── Update schema if needed
   ├── Re-register components
   └── Validate system integrity
```

**Critical Implementation Note:** 
- Do NOT rely on Update Version's database-only backups for switching operations
- Always use CV Backup Utility (CVBackup.exe) to create comprehensive backups before switching
- Test backup/restore compatibility thoroughly before production deployment

### 7.3 Safety Validations by Application

**Update Version Validations:**
- Database integrity checks
- Schema version compatibility
- System file availability
- Sufficient disk space

**Restore CV Validations:**
- Backup file integrity
- No active user sessions
- Target version compatibility
- Sufficient permissions

---

## 8. Technical Specifications

### 8.1 Application-Specific Requirements

**Update Version Requirements:**
- Administrative privileges for registry
- SQL Server maintenance permissions
- Read/write access to database files
- Ability to restart SQL services

**Restore CV Requirements:**
- Exclusive database access
- Full backup file permissions
- Network share access (if applicable)
- Higher privilege level than Update Version

### 8.2 Performance Characteristics

**Update Version Performance:**
- Incremental operations (faster)
- Can work on live databases
- Progress reporting available
- Resumable operations

**Restore CV Performance:**
- Complete replacement (slower)
- Requires downtime
- All-or-nothing operation
- Not resumable

---

## 9. Critical Uncertainties and Testing Requirements

### 9.1 Backup Compatibility Uncertainty

**Key Unknown:** The Cabinet Vision documentation does not explicitly confirm whether Update Version's database-only backups can be restored using the Restore CV application.

**What We Know:**
- Update Version creates "database backups" (database files only)
- Restore CV is documented to work with CV Backup Utility backups (comprehensive)
- CV Backup Utility creates full system backups including databases, graphics, registry, etc.

**What We Don't Know:**
- Can Restore CV process Update Version's database-only backups?
- Are the backup formats compatible between the two systems?
- Would attempting to restore a database-only backup cause issues?

**Testing Requirements:**
1. Test if Restore CV can detect and list Update Version backups
2. Verify if restoration of Update Version backups is possible
3. Document any error messages or compatibility issues
4. Test partial restoration scenarios

**Recommended Approach for Database Switcher:**
- Always use CV Backup Utility (CVBackup.exe) for creating backups
- Do not assume Update Version backups are suitable for restoration
- Implement comprehensive backup creation as a separate step
- Consider Update Version backups as emergency rollback only

---

## 10. Security and Safety Considerations

### 10.1 Risk Profiles

**Update Version Risks:**
- In-place modifications could corrupt data
- Mitigated by automatic backups
- Lower risk due to incremental changes

**Restore CV Risks:**
- Complete data replacement
- Could restore outdated information
- Higher risk but cleaner operation

### 10.2 Audit Requirements

**Logging by Application:**
- **Update Version:** Detailed operation logs with rollback points
- **Restore CV:** Restoration audit trail with source tracking
- **Database Switcher:** Must log both application calls

---

## 11. Implementation Recommendations

### 11.1 Database Switcher Design Principles

1. **Use Update Version for:**
   - Pre-switch validation and optimization
   - Database maintenance (NOT for comprehensive backups)
   - Post-switch compatibility updates
   - System file management

2. **Use Restore CV for:**
   - Actual database switching operation
   - Backup selection interface
   - Configuration replacement
   - Disaster recovery fallback

3. **Custom Development Focus:**
   - Orchestration between applications
   - Enhanced UI for database selection
   - Automated validation workflows
   - Multi-database management

### 11.2 Implementation Phases

**Phase 1: Basic Integration**
- Wrap existing Update Version and Restore CV functionality
- Add database detection and enumeration
- Implement basic switch operations

**Phase 2: Enhanced Automation**
- Automate pre/post validations
- Add scheduling capabilities
- Implement rollback mechanisms

**Phase 3: Enterprise Features**
- Multi-database management
- Network-wide configuration
- Advanced monitoring and reporting

---

## 12. Source Documentation References

This technical analysis is based on the following Cabinet Vision documentation files:

### Primary Source Files

**1. Update Version Documentation**
- `/Introduction/CABINET_VISION_Startup_Group/Update_Version.htm`
  - States: "The Update Version Utility first creates a full set of database backups"
  - Lists the five core functions of Update Version

**2. Cabinet Vision Startup Group**
- `/Introduction/CABINET_VISION_Startup_Group/CABINET_VISION_startup_group.htm`
  - Describes all startup group applications
  - Documents CV Backup Utility command line switches
  - Explains Restore CV Settings functionality

**3. Transfer Standards Guide**
- `/Tips_Tricks_FAQs/Computer_Specific/Transfer_Standards.htm`
  - Details CV Backup Utility components
  - Shows backup/restore workflow
  - Lists what gets backed up by CV Backup Utility

**4. Backup Utility Documentation**
- `/System_Level/Ribbonbar/Utilities_Tab/Tools_Group/SL_Backup_Utility.htm`
  - Describes backup interface and options
  - Lists all backup components

**5. Database Structure Documentation**
- `/Tips_Tricks_FAQs/The_Databases/CVData_mdf.htm`
  - Details CVData.mdf structure and tables
  - Explains primary database architecture

### Key Documentation Gaps

The documentation does **not** explicitly state:
- Whether Update Version uses CV Backup Utility internally
- If Restore CV can process Update Version's backups
- The exact format/structure of Update Version's "database backups"
- Compatibility between the two backup types

This uncertainty led to the recommendation to always use CV Backup Utility (CVBackup.exe) directly for comprehensive backups in a database switcher implementation.

---

## 13. Conclusion

The Update Version and Restore CV applications provide complementary functionality for Cabinet Vision database management. Update Version excels at in-place maintenance and version migration (with limited database-only backups), while Restore CV provides complete database replacement capabilities from comprehensive CV Backup Utility backups. A successful database switcher implementation should leverage the strengths of both applications:

- **Update Version** for database optimization and compatibility (not for backup creation)
- **CV Backup Utility** for comprehensive backup creation
- **Restore CV** for the actual switching mechanism
- **Custom orchestration** to provide seamless user experience

By understanding the distinct roles and capabilities of each application, developers can create a robust database switching solution that maintains data integrity while providing the flexibility needed for modern Cabinet Vision deployments.

---

## Appendices

### Appendix A: Quick Reference - Application Comparison

| Task | Use Update Version | Use Restore CV |
|------|-------------------|----------------|
| Version upgrade | ✓ Primary method | Only with backup |
| Database repair | ✓ Preferred | If corruption severe |
| Switch databases | Preparation only | ✓ Primary method |
| Routine maintenance | ✓ Designed for this | Overkill |
| Disaster recovery | Limited capability | ✓ Primary method |
| Configuration reset | Selective updates | ✓ Complete reset |

### Appendix B: Command Line Integration

```bash
# Update Version (typically GUI-only, limited CLI)
UpdateVersion.exe /silent    # If available

# CV Backup (used by Update Version)
CVBackup.exe /g /p          # Silent backup
CVBackup.exe /z             # Create ZIP

# Restore CV (typically GUI-only)
RestoreCV.exe               # Launch GUI
```

### Appendix C: File and Registry Locations

```
Database Files:
├── CVData.mdf (Modified by Update Version, Replaced by Restore CV)
├── report.accdb (Handled differently by each app)
└── [Additional .accdb/.mdb files]

Registry Keys:
└── HKLM\SOFTWARE\Hexagon\CABINET VISION\[Version]
    ├── Updated incrementally (Update Version)
    └── Replaced entirely (Restore CV)
```

This refactored report eliminates redundancy by integrating the application distinctions throughout each technical section, providing a clearer and more concise reference for database switcher development.