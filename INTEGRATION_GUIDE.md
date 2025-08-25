# RSG-MDT Integration Guide

## Overview
RSG-MDT is now a standalone resource that was separated from RSG-Lawman. This guide explains how to integrate it into your RedM server.

## Installation

### 1. Copy the Resource
Copy the `rsg-mdt` folder to your server's resources directory.

### 2. Import Database Schema
Execute the SQL files in order:
- `mdt_schema.sql` - Main MDT database structure
- `mdt_schema_updated.sql` - Recent updates and fixes

### 3. Configure Server.cfg
Add the following to your server.cfg:
```
ensure rsg-mdt
ensure rsg-lawman  # Must load after rsg-mdt
```

### 4. Configure Permissions
Edit `rsg-mdt/config.lua` to set:
- Allowed jobs for MDT access
- Keybinds and commands
- Feature toggles
- Integration settings

## Usage

### Opening MDT
- **Keybind**: Press 'M' (configurable in config.lua)
- **Command**: Type `/mdt` in chat
- **Menu**: Use the Law Office Menu

### Features
- Person search and records
- Vehicle registration and history
- Horse registration and BOLOs
- Warrant management
- BOLO (Be On Lookout) system
- Incident reporting
- Citation management
- Telegram integration

## Dependencies
- rsg-core
- ox_lib
- oxmysql
- rsg-horses (optional)
- rsg-telegram (optional)

## Database Tables
The MDT system uses these database tables:
- `mdt_persons` - Person records
- `mdt_vehicles` - Vehicle information
- `mdt_horses` - Horse registration
- `mdt_incidents` - Incident reports
- `mdt_warrants` - Active warrants
- `mdt_bolos` - Be On Lookout notices
- `mdt_citations` - Citation records
- `mdt_telegrams` - Telegram messages

## Troubleshooting

### Common Issues
1. **MDT not opening**: Check keybind configuration and job permissions
2. **Database errors**: Ensure SQL files are imported correctly
3. **Missing features**: Verify dependencies are installed and configured

### Debug Mode
Enable debug mode in config.lua to see detailed logs:
```lua
Config.Debug = true
```

## Migration from Integrated MDT
If you were using the integrated MDT in RSG-Lawman:
1. Backup your existing MDT data
2. Import the new schema
3. The system will automatically migrate existing data
4. Update your server configuration as described above

## Support
For issues and questions, refer to the main README.md file or check the RSG Discord community.