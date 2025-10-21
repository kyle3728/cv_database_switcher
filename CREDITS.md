# Credits & Attribution

This tool builds upon discoveries and implementations shared by the Cabinet Vision community. We are deeply grateful to those who pioneered these methods and shared their knowledge openly.

## Core Contributors

### Database Switching Method

**Tristan R** (2020-2023)
- Original discoverer and implementer of the folder-rename database switching technique
- Developed the first batch script implementation for CV database switching
- Shared comprehensive guidance on SQL permissions, registry handling, and troubleshooting
- Continued to support and refine the method through multiple CV versions (CV10-CV2022+)

**Forum Discussion:** [CV 12 Database Switcher](https://nexus.hexagon.com/community/cabinet_vision/f/cv-legacy-versions/70968/cv-12-database-switcher/448912)

**Key Innovation:** Discovered that Cabinet Vision always reads from a folder named exactly "Database" - making database switching as simple as renaming folders, avoiding time-consuming backup/restore cycles.

### Version Switching Method

**Kevin (Valley Cabinet)** (2023)
- Discovered that the folder-rename method also works for maintaining multiple Cabinet Vision program versions
- Documented the process for safely testing quarterly CV updates while preserving rollback capability
- Shared practical workflows for managing CV version folders alongside S2M folders

**Forum Discussion:** [With CV having new build every 3 months...](https://nexus.hexagon.com/community/cabinet_vision/f/cv-sharing-shop-talk-careers/96796/with-cv-having-new-build-every-3-months-to-be-able-to-have-all-installs-in-different-folder-locations)

### Additional Contributors

**John "Zeke" Charles**
- Co-discoverer of the database switching method (independently using same technique since CV9)
- Provided the critical insight about SysParams.reg file for system parameters switching
- Contributed expertise on SQL permissions and network database configurations
- Helped identify and troubleshoot compatibility issues across different Windows versions

**The Cabinet Visionary (TCV)**
- Created earlier database switching applications for pre-SQL Cabinet Vision versions
- Provided historical context and validation of the folder-rename approach

## This Implementation

**Developed by:** Kyle - [Nomadtek Consulting](https://nomadtekconsulting.com)

This tool (CV Database Manager) extends the community-discovered methods with:
- Unified interface combining database switching, setup, and import preparation
- Automatic detection of CV versions and database profiles
- Synchronization of CV, Common, and S2M databases
- Database mismatch detection and warnings
- Process safety checks to prevent corruption
- Comprehensive error handling and rollback capabilities
- Audit logging
- Guided workflows for complex operations

## Philosophy

This project embodies the spirit of the Cabinet Vision community: sharing knowledge and tools to help fellow users work more efficiently. Just as Tristan, Kevin, and others freely shared their discoveries, this tool is released as open source for the benefit of all CV users.

## For Users With Forum Access

The complete forum discussions contain valuable context, troubleshooting tips, and implementation details. If you have access to the Hexagon Nexus Cabinet Vision forums, we highly recommend reading the original threads linked above.

---

*This tool is released under the MIT License. See LICENSE file for details.*
