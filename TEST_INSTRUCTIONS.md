# RSG-MDT Testing Instructions

## Before Testing

1. **Database Setup**
   ```sql
   -- Run mdt_schema.sql in your database
   -- This creates all necessary MDT tables
   ```

2. **Configuration**
   - Edit `config.lua` and adjust allowed law jobs for your server
   - Default jobs: vallaw, rholaw, blklaw, strlaw, stdenlaw

3. **Installation**
   - Place `rsg-mdt` folder in your resources directory
   - Add `ensure rsg-mdt` to server.cfg
   - Restart server

## Testing Checklist

### Basic Functionality
- [ ] Resource starts without errors
- [ ] Players in law enforcement jobs can use `/mdt` command
- [ ] Players NOT in law enforcement get "Access Denied" message
- [ ] MDT keybind (M key) works when on duty

### MDT Interface
- [ ] Main MDT menu opens correctly
- [ ] Dashboard shows (even if empty initially)
- [ ] Citizens search works
- [ ] Horses search works (if rsg-horses installed)
- [ ] Bounty Alerts section works
- [ ] Telegrams section works (if rsg-telegram installed)

### Database Integration
- [ ] Person details load from players table
- [ ] Criminal records can be added
- [ ] Citations can be issued
- [ ] Warrants can be created
- [ ] Bounty alerts can be created

### Error Checking
- [ ] No console errors on resource start
- [ ] No errors when opening MDT
- [ ] Proper error handling for non-existent data
- [ ] ESC key closes MDT properly

## Common Issues

1. **"Access Denied" for law enforcement**
   - Check job names in config.lua match your framework jobs
   - Ensure player is on duty

2. **Database errors**
   - Verify mdt_schema.sql was executed
   - Check oxmysql connection

3. **Missing features**
   - Some features require rsg-telegram or rsg-horses
   - Check dependencies in fxmanifest.lua

## Integration Notes

- This MDT is standalone and doesn't require rsg-lawman
- It integrates with rsg-core framework
- Uses ox_lib for UI components
- Compatible with rsg-telegram and rsg-horses if installed