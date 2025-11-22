# MDT Sheriff Archives (SA)

The Sheriff Archive (SA) is a standalone law enforcement database system for RedM servers. It provides officers with access to criminal records, warrants, BOLOs, incident reports, and citation management through an intuitive in-game interface.

## Features

- **Person Search**: Search for citizens by name or citizen ID
- **horse Search**: Search for horses be owner
- **Criminal Records**: View and manage criminal history
- **Warrants**: Issue, view, and manage arrest warrants
- **BOLOs**: Create and track Be On the Lookout alerts for horses
- **Incident Reports**: File and view incident reports
- **Citations**: Issue and manage traffic/parking citations
- **Dashboard**: View recent incidents, active warrants, and BOLOs at a glance

## Installation

1. Download and place the `KK-mdt` folder in your server's resources directory
2. Add `ensure kk-mdt` to your server.cfg
3. Run the SQL schema in `mdt_schema.sql` to create the necessary database tables
4. Configure job access in `config.lua`
5. Restart your server

## Usage

### Opening the SA

1. **Command**: Type `/mdt` in chat when on duty as a law enforcement officer
2. **Keybind**: Press `M` (default) when on duty as a law enforcement officer

### Features Overview

#### Dashboard
The dashboard provides a quick overview of recent activity:
- Recent incidents from the past 7 days
- Active warrants
- Active BOLOs
- Your recent reports

#### Persons Tab
Search for citizens and view their records:
- Search by name or citizen ID
- View personal information
- Check criminal history
- See issued citations
- View incident involvement
- Issue citations directly

#### horses Tab
Search for horses and view related information:
- Search by owner
- View horse details
- Check for active BOLOs
- View incident involvement
- Create BOLOs directly

#### Reports Tab
Create incident reports:
- File new reports with title, description, and location

#### Warrants Tab
Manage arrest warrants:
- Issue new warrants with reason

#### BOLOs Tab
Manage horse alerts:
- Access horse BOLO management through the horses section

#### Citations Tab
Manage citations:
- Access citation management through the Persons section

## Commands

- `/mdt` - Open the Sheriff Archive

## Keybinds

- `M` - Open SA (when on duty as law enforcement)

## Database Schema

The SA system uses several database tables to store information:
- `mdt_criminal_records` - Criminal charges and records
- `mdt_warrants` - Arrest warrants
- `mdt_bolos` - Be On the Lookout alerts
- `mdt_incidents` - Incident reports
- `mdt_citations` - Traffic/parking citations
- `mdt_horses` - horse records
- `mdt_reports` - General reports
- `mdt_logs` - System logs

## Configuration

The SA system can be configured through the main `config.lua` file:
- `Config.SAKeybind` - Key to open SA (default: 'M')

## Requirements

- RSG Framework
- rsg-lawman resource
- oxmysql
- ox_lib

## Support

For issues or feature requests, please contact the resource maintainer or submit an issue on the GitHub repository.
