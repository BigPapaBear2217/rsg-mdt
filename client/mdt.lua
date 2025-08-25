local RSGCore = exports['rsg-core']:GetCoreObject()
local MDTOpen = false
local MDTData = {}
lib.locale()

-- Helper function to close MDT and cleanup state
local function CloseMDTCompletely()
    if MDTOpen then
        MDTOpen = false
        print('[^2RSG-MDT^7] Cleaning up MDT state...')
        TriggerEvent('rsg-mdt:client:closeMDT')
    end
end

------------------------------------------
-- Open MDT Interface (called from main.lua after permission check)
------------------------------------------
RegisterNetEvent('rsg-mdt:client:openMDTInterface', function()
    -- Request MDT data from server
    RSGCore.Functions.TriggerCallback('rsg-mdt:server:getMDTData', function(data)
        MDTData = data
        -- Open MDT Context Menu
        OpenMDT()
    end)
end)

------------------------------------------
-- Open MDT Context Menu
------------------------------------------
function OpenMDT()
    MDTOpen = true
    
    -- Cleanup function when menu closes
    local function cleanupMDTState()
        CloseMDTCompletely()
    end
    
    lib.registerContext({
        id = 'mdt_dashboard',
        title = 'Sheriff Archives',
        options = {
            {
                title = 'Dashboard',
                description = 'Recent incidents and active cases',
                icon = 'fa-solid fa-house',
                event = 'rsg-mdt:client:openDashboard',
                arrow = true
            },
            {
                title = 'Citizens',
                description = 'Search and view citizen records',
                icon = 'fa-solid fa-user',
                event = 'rsg-mdt:client:openPersons',
                arrow = true
            },
            {
                title = 'Horses',
                description = 'Search and view horse records',
                icon = 'fa-solid fa-horse',
                event = 'rsg-mdt:client:openHorses',
                arrow = true
            },
            {
                title = 'Reports',
                description = 'Create and view incident reports',
                icon = 'fa-solid fa-file-lines',
                event = 'rsg-mdt:client:openReports',
                arrow = true
            },
            {
                title = 'Warrants',
                description = 'Issue and manage arrest warrants',
                icon = 'fa-solid fa-gavel',
                event = 'rsg-mdt:client:openWarrants',
                arrow = true
            },
            {
                title = 'Bounty Alerts',
                description = 'Create and manage bounty alerts',
                icon = 'fa-solid fa-user-secret',
                event = 'rsg-mdt:client:openBountyAlerts',
                arrow = true
            },
            {
                title = 'Read Telegrams',
                description = 'Read and manage telegrams',
                icon = 'fa-solid fa-envelope-open-text',
                event = 'rsg-mdt:client:openTelegrams',
                arrow = true
            },
            {
                title = 'Citations',
                description = 'Issue and manage citations',
                icon = 'fa-solid fa-ticket',
                event = 'rsg-mdt:client:openCitations',
                arrow = true
            }
        }
    })
    
    lib.showContext('mdt_dashboard')
    
    -- Monitor menu state and cleanup when closed
    CreateThread(function()
        Wait(100)
        while MDTOpen do
            Wait(500)
            if not lib.getOpenContextMenu() then
                cleanupMDTState()
                break
            end
        end
    end)
end

------------------------------------------
-- Dashboard Menu
------------------------------------------
RegisterNetEvent('rsg-mdt:client:openDashboard', function()
    local options = {}
    
    -- Recent Incidents
    table.insert(options, {
        title = 'Recent Incidents',
        description = 'Latest reported incidents',
        icon = 'fa-solid fa-fire',
        disabled = true
    })
    
    if MDTData.recentIncidents and #MDTData.recentIncidents > 0 then
        for i = 1, math.min(5, #MDTData.recentIncidents) do
            local incident = MDTData.recentIncidents[i]
            table.insert(options, {
                title = incident.title or 'Unknown Incident',
                description = string.sub(incident.description or 'No description', 1, 50) .. '...',
                icon = 'fa-solid fa-file-circle-exclamation',
                disabled = true
            })
        end
    else
        table.insert(options, {
            title = 'No recent incidents',
            description = 'No incidents reported recently',
            icon = 'fa-solid fa-circle-info',
            disabled = true
        })
    end
    
    -- Active Warrants
    table.insert(options, {
        title = 'Active Warrants',
        description = 'Currently active arrest warrants',
        icon = 'fa-solid fa-gavel',
        disabled = true
    })
    
    if MDTData.activeWarrants and #MDTData.activeWarrants > 0 then
        for i = 1, math.min(5, #MDTData.activeWarrants) do
            local warrant = MDTData.activeWarrants[i]
            table.insert(options, {
                title = 'Warrant for ' .. (warrant.citizenid or 'Unknown'),
                description = string.sub(warrant.reason or 'No reason', 1, 50) .. '...',
                icon = 'fa-solid fa-file-contract',
                disabled = true
            })
        end
    else
        table.insert(options, {
            title = 'No active warrants',
            description = 'No warrants currently active',
            icon = 'fa-solid fa-circle-info',
            disabled = true
        })
    end
    
    -- Back button
    table.insert(options, {
        title = 'Back',
        description = 'Return to main Sheriff Archives',
        icon = 'fa-solid fa-arrow-left',
        event = 'rsg-mdt:client:openMDT',
        arrow = true
    })
    
    lib.registerContext({
        id = 'mdt_dashboard_details',
        title = 'Sheriff Archives Dashboard',
        menu = 'mdt_dashboard',
        options = options
    })
    
    lib.showContext('mdt_dashboard_details')
end)

------------------------------------------
-- Citizens Menu
------------------------------------------
RegisterNetEvent('rsg-mdt:client:openPersons', function()
    local input = lib.inputDialog('Search Citizens', {
        {type = 'input', label = 'Name or Citizen ID', description = 'Enter name or citizen ID to search', required = true}
    })
    
    if input then
        local query = input[1]
        RSGCore.Functions.TriggerCallback('rsg-mdt:server:searchPersons', function(results)
            local options = {}
            
            if results and #results > 0 then
                for i = 1, math.min(10, #results) do
                    local person = results[i]
                    local charinfo = person.charinfo
                    if type(charinfo) == "string" then
                        charinfo = json.decode(charinfo)
                    end
                    
                    local name = "Unknown"
                    if charinfo and charinfo.firstname then
                        name = charinfo.firstname .. " " .. (charinfo.lastname or "")
                    end
                    
                    table.insert(options, {
                        title = name,
                        description = 'Citizen ID: ' .. (person.citizenid or 'Unknown'),
                        icon = 'fa-solid fa-user',
                        event = 'rsg-mdt:client:viewPerson',
                        args = {citizenid = person.citizenid},
                        arrow = true
                    })
                end
            else
                table.insert(options, {
                    title = 'No results found',
                    description = 'No citizens match your search',
                    icon = 'fa-solid fa-magnifying-glass',
                    disabled = true
                })
            end
            
            -- Back button
            table.insert(options, {
                title = 'Back',
                description = 'Return to main Sheriff Archives',
                icon = 'fa-solid fa-arrow-left',
                event = 'rsg-mdt:client:openMDT',
                arrow = true
            })
            
            lib.registerContext({
                id = 'mdt_persons_results',
                title = 'Citizen Search Results',
                menu = 'mdt_dashboard',
                options = options
            })
            
            lib.showContext('mdt_persons_results')
        end, query)
    else
        lib.showContext('mdt_dashboard')
    end
end)

------------------------------------------
-- View Person Details
------------------------------------------
RegisterNetEvent('rsg-mdt:client:viewPerson', function(data)
    local citizenid = data.citizenid
    RSGCore.Functions.TriggerCallback('rsg-mdt:server:getPersonDetails', function(personData)
        local options = {}
        
        -- Personal Information
        table.insert(options, {
            title = 'Personal Information',
            description = 'View citizen details',
            icon = 'fa-solid fa-user',
            event = 'rsg-mdt:client:viewPersonInfo',
            args = {personData = personData},
            arrow = true
        })
        
        -- Criminal Record
        table.insert(options, {
            title = 'Criminal Record',
            description = 'View criminal history',
            icon = 'fa-solid fa-gavel',
            event = 'rsg-mdt:client:viewCriminalRecord',
            args = {personData = personData},
            arrow = true
        })
        
        -- Citations
        table.insert(options, {
            title = 'Citations',
            description = 'View issued citations',
            icon = 'fa-solid fa-ticket',
            event = 'rsg-mdt:client:viewCitations',
            args = {personData = personData},
            arrow = true
        })
        
        -- Send Telegram option
        table.insert(options, {
            title = 'Send Telegram',
            description = 'Send a telegram to this citizen',
            icon = 'fa-solid fa-envelope',
            event = 'rsg-mdt:client:sendTelegram',
            args = {citizenid = citizenid},
            arrow = true
        })
        
        -- Back button
        table.insert(options, {
            title = 'Back',
            description = 'Return to citizens search',
            icon = 'fa-solid fa-arrow-left',
            event = 'rsg-mdt:client:openPersons',
            arrow = true
        })
        
        lib.registerContext({
            id = 'mdt_person_details',
            title = 'Citizen Details',
            menu = 'mdt_persons_results',
            options = options
        })
        
        lib.showContext('mdt_person_details')
    end, citizenid)
end)

------------------------------------------
-- View Person Information
------------------------------------------
RegisterNetEvent('rsg-mdt:client:viewPersonInfo', function(data)
    local personData = data.personData
    local playerData = personData.playerData
    local charinfo = playerData.charinfo
    if type(charinfo) == "string" then
        charinfo = json.decode(charinfo)
    end
    
    local options = {}
    
    table.insert(options, {
        title = 'Citizen ID',
        description = playerData.citizenid or 'Unknown',
        icon = 'fa-solid fa-id-card',
        disabled = true
    })
    
    table.insert(options, {
        title = 'Name',
        description = (charinfo.firstname or 'Unknown') .. ' ' .. (charinfo.lastname or ''),
        icon = 'fa-solid fa-signature',
        disabled = true
    })
    
    table.insert(options, {
        title = 'Date of Birth',
        description = charinfo.birthdate or 'Unknown',
        icon = 'fa-solid fa-cake-candles',
        disabled = true
    })
    
    table.insert(options, {
        title = 'Gender',
        description = charinfo.gender or 'Unknown',
        icon = 'fa-solid fa-venus-mars',
        disabled = true
    })
    
    -- Send Telegram option
    table.insert(options, {
        title = 'Send Telegram',
        description = 'Send a telegram to this citizen',
        icon = 'fa-solid fa-paper-plane',
        event = 'rsg-mdt:client:sendTelegram',
        args = {citizenid = playerData.citizenid},
        arrow = true
    })
    
    -- Back button
    table.insert(options, {
        title = 'Back',
        description = 'Return to citizen details',
        icon = 'fa-solid fa-arrow-left',
        event = 'rsg-mdt:client:viewPerson',
        args = {citizenid = playerData.citizenid},
        arrow = true
    })
    
    lib.registerContext({
        id = 'mdt_person_info',
        title = 'Personal Information',
        menu = 'mdt_person_details',
        options = options
    })
    
    lib.showContext('mdt_person_info')
end)

------------------------------------------
-- View Criminal Record
------------------------------------------
RegisterNetEvent('rsg-mdt:client:viewCriminalRecord', function(data)
    local personData = data.personData
    local options = {}
    
    if personData.criminalRecord and #personData.criminalRecord > 0 then
        for i = 1, #personData.criminalRecord do
            local record = personData.criminalRecord[i]
            table.insert(options, {
                title = record.charges or 'Unknown charges',
                description = 'Date: ' .. (record.created_at or 'Unknown'),
                icon = 'fa-solid fa-scale-balanced',
                disabled = true
            })
        end
    else
        table.insert(options, {
            title = 'No criminal record',
            description = 'This citizen has no criminal history',
            icon = 'fa-solid fa-circle-info',
            disabled = true
        })
    end
    
    -- Back button
    table.insert(options, {
        title = 'Back',
        description = 'Return to citizen details',
        icon = 'fa-solid fa-arrow-left',
        event = 'rsg-mdt:client:viewPerson',
        args = {citizenid = personData.playerData.citizenid},
        arrow = true
    })
    
    lib.registerContext({
        id = 'mdt_criminal_record',
        title = 'Criminal Record',
        menu = 'mdt_person_details',
        options = options
    })
    
    lib.showContext('mdt_criminal_record')
end)

------------------------------------------
-- View Citations
------------------------------------------
RegisterNetEvent('rsg-mdt:client:viewCitations', function(data)
    local personData = data.personData
    local options = {}
    
    if personData.citations and #personData.citations > 0 then
        for i = 1, #personData.citations do
            local citation = personData.citations[i]
            local status = citation.status or 'unknown'
            local statusIcon = 'fa-solid fa-question'
            if status == 'paid' then
                statusIcon = 'fa-solid fa-check'
            elseif status == 'unpaid' then
                statusIcon = 'fa-solid fa-clock'
            elseif status == 'overdue' then
                statusIcon = 'fa-solid fa-exclamation'
            end
            
            table.insert(options, {
                title = citation.reason or 'Unknown reason',
                description = 'Amount: $' .. (citation.amount or '0') .. ' | Status: ' .. status,
                icon = statusIcon,
                disabled = true
            })
        end
    else
        table.insert(options, {
            title = 'No citations',
            description = 'This citizen has no citations',
            icon = 'fa-solid fa-circle-info',
            disabled = true
        })
    end
    
    -- Issue new citation option
    table.insert(options, {
        title = 'Issue Citation',
        description = 'Issue a new citation to this citizen',
        icon = 'fa-solid fa-plus',
        event = 'rsg-mdt:client:issueCitation',
        args = {citizenid = personData.playerData.citizenid},
        arrow = true
    })
    
    -- Back button
    table.insert(options, {
        title = 'Back',
        description = 'Return to citizen details',
        icon = 'fa-solid fa-arrow-left',
        event = 'rsg-mdt:client:viewPerson',
        args = {citizenid = personData.playerData.citizenid},
        arrow = true
    })
    
    lib.registerContext({
        id = 'mdt_citations',
        title = 'Citations',
        menu = 'mdt_person_details',
        options = options
    })
    
    lib.showContext('mdt_citations')
end)

------------------------------------------
-- Issue Citation
------------------------------------------
RegisterNetEvent('rsg-mdt:client:issueCitation', function(data)
    local citizenid = data.citizenid
    local input = lib.inputDialog('Issue Citation', {
        {type = 'input', label = 'Reason', description = 'Reason for citation', required = true},
        {type = 'number', label = 'Amount', description = 'Fine amount ($)', required = true, min = 0}
    })
    
    if input then
        local reason = input[1]
        local amount = tonumber(input[2])
        
        if reason and amount then
            local citation = {
                citizenid = citizenid,
                reason = reason,
                amount = amount
            }
            
            RSGCore.Functions.TriggerCallback('rsg-mdt:server:createCitation', function(success)
                if success then
                    lib.notify({title = 'Citation Issued', description = 'Citation issued successfully', type = 'success'})
                else
                    lib.notify({title = 'Error', description = 'Failed to issue citation', type = 'error'})
                end
                -- Return to citations view
                TriggerEvent('rsg-mdt:client:viewPerson', {citizenid = citizenid})
            end, citation)
        else
            lib.notify({title = 'Error', description = 'Invalid input', type = 'error'})
            TriggerEvent('rsg-mdt:client:viewPerson', {citizenid = citizenid})
        end
    else
        TriggerEvent('rsg-mdt:client:viewPerson', {citizenid = citizenid})
    end
end)

------------------------------------------
-- Horses Menu
------------------------------------------
RegisterNetEvent('rsg-mdt:client:openHorses', function()
    local input = lib.inputDialog('Search Horses', {
        {type = 'input', label = 'Horse ID, Name, or Owner', description = 'Enter details to search', required = true}
    })
    
    if input then
        local query = input[1]
        RSGCore.Functions.TriggerCallback('rsg-mdt:server:searchHorses', function(results)
            local options = {}
            
            if results and #results > 0 then
                for i = 1, math.min(10, #results) do
                    local horse = results[i]
                    table.insert(options, {
                        title = (horse.name or 'Unknown Horse') .. ' - ' .. (horse.horseid or 'Unknown'),
                        description = 'Owner: ' .. (horse.citizenid or 'Unknown') .. ' | Breed: ' .. (horse.horse or 'Unknown'),
                        icon = 'fa-solid fa-horse',
                        event = 'rsg-mdt:client:viewHorse',
                        args = {horseid = horse.horseid},
                        arrow = true
                    })
                end
            else
                table.insert(options, {
                    title = 'No results found',
                    description = 'No horses match your search',
                    icon = 'fa-solid fa-magnifying-glass',
                    disabled = true
                })
            end
            
            -- Back button
            table.insert(options, {
                title = 'Back',
                description = 'Return to main Sheriff Archives',
                icon = 'fa-solid fa-arrow-left',
                event = 'rsg-mdt:client:openMDT',
                arrow = true
            })
            
            lib.registerContext({
                id = 'mdt_horses_results',
                title = 'Horse Search Results',
                menu = 'mdt_dashboard',
                options = options
            })
            
            lib.showContext('mdt_horses_results')
        end, query)
    else
        lib.showContext('mdt_dashboard')
    end
end)

------------------------------------------
-- View Horse Details
------------------------------------------
RegisterNetEvent('rsg-mdt:client:viewHorse', function(data)
    local horseid = data.horseid
    RSGCore.Functions.TriggerCallback('rsg-mdt:server:getHorseDetails', function(horseData)
        local options = {}
        
        -- Horse Information
        table.insert(options, {
            title = 'Horse Information',
            description = 'View horse details',
            icon = 'fa-solid fa-horse',
            event = 'rsg-mdt:client:viewHorseInfo',
            args = {horseData = horseData},
            arrow = true
        })
        
        -- Bounty Alerts
        table.insert(options, {
            title = 'Bounty Alerts',
            description = 'View active bounty alerts for this horse',
            icon = 'fa-solid fa-user-secret',
            event = 'rsg-mdt:client:viewHorseBountyAlerts',
            args = {horseid = horseid},
            arrow = true
        })
        
        -- Create Bounty Alert option
        table.insert(options, {
            title = 'Create Bounty Alert',
            description = 'Create a new bounty alert for this horse',
            icon = 'fa-solid fa-plus',
            event = 'rsg-mdt:client:createHorseBountyAlert',
            args = {horseid = horseid},
            arrow = true
        })
        
        -- Back button
        table.insert(options, {
            title = 'Back',
            description = 'Return to horses search',
            icon = 'fa-solid fa-arrow-left',
            event = 'rsg-mdt:client:openHorses',
            arrow = true
        })
        
        lib.registerContext({
            id = 'mdt_horse_details',
            title = 'Horse Details',
            menu = 'mdt_horses_results',
            options = options
        })
        
        lib.showContext('mdt_horse_details')
    end, horseid)
end)

------------------------------------------
-- View Horse Information
------------------------------------------
RegisterNetEvent('rsg-mdt:client:viewHorseInfo', function(data)
    local horseData = data.horseData
    local horse = horseData.horseData
    local options = {}
    
    table.insert(options, {
        title = 'Horse ID',
        description = horse.horseid or 'Unknown',
        icon = 'fa-solid fa-hashtag',
        disabled = true
    })
    
    table.insert(options, {
        title = 'Name',
        description = horse.name or 'Unknown',
        icon = 'fa-solid fa-signature',
        disabled = true
    })
    
    table.insert(options, {
        title = 'Owner',
        description = horse.citizenid or 'Unknown',
        icon = 'fa-solid fa-user',
        disabled = true
    })
    
    table.insert(options, {
        title = 'Breed',
        description = horse.horse or 'Unknown',
        icon = 'fa-solid fa-horse-head',
        disabled = true
    })
    
    table.insert(options, {
        title = 'Gender',
        description = horse.gender or 'Unknown',
        icon = 'fa-solid fa-venus-mars',
        disabled = true
    })
    
    table.insert(options, {
        title = 'Experience',
        description = horse.horsexp or '0',
        icon = 'fa-solid fa-chart-line',
        disabled = true
    })
    
    -- Back button
    table.insert(options, {
        title = 'Back',
        description = 'Return to horse details',
        icon = 'fa-solid fa-arrow-left',
        event = 'rsg-mdt:client:viewHorse',
        args = {horseid = horse.horseid},
        arrow = true
    })
    
    lib.registerContext({
        id = 'mdt_horse_info',
        title = 'Horse Information',
        menu = 'mdt_horse_details',
        options = options
    })
    
    lib.showContext('mdt_horse_info')
end)

------------------------------------------
-- View Horse Bounty Alerts
------------------------------------------
RegisterNetEvent('rsg-mdt:client:viewHorseBountyAlerts', function(data)
    local horseid = data.horseid
    RSGCore.Functions.TriggerCallback('rsg-mdt:server:getHorseBountyAlerts', function(alerts)
        local options = {}
        
        if alerts and #alerts > 0 then
            for i = 1, #alerts do
                local alert = alerts[i]
                local statusIcon = 'fa-solid fa-question'
                if alert.status == 'active' then
                    statusIcon = 'fa-solid fa-clock'
                elseif alert.status == 'claimed' then
                    statusIcon = 'fa-solid fa-check'
                elseif alert.status == 'expired' then
                    statusIcon = 'fa-solid fa-exclamation'
                end
                
                local rewardText = ""
                if alert.reward and alert.reward > 0 then
                    rewardText = " | Reward: $" .. alert.reward
                end
                
                table.insert(options, {
                    title = alert.reason or 'Unknown reason',
                    description = 'Status: ' .. (alert.status or 'Unknown') .. rewardText .. ' | Date: ' .. (alert.created_at or 'Unknown'),
                    icon = statusIcon,
                    disabled = true
                })
            end
        else
            table.insert(options, {
                title = 'No Bounty Alerts',
                description = 'This horse has no bounty alerts',
                icon = 'fa-solid fa-circle-info',
                disabled = true
            })
        end
        
        -- Create new bounty alert
        table.insert(options, {
            title = 'Create Bounty Alert',
            description = 'Create a new bounty alert for this horse',
            icon = 'fa-solid fa-plus',
            event = 'rsg-mdt:client:createHorseBountyAlert',
            args = {horseid = horseid},
            arrow = true
        })
        
        -- Back button
        table.insert(options, {
            title = 'Back',
            description = 'Return to horse details',
            icon = 'fa-solid fa-arrow-left',
            event = 'rsg-mdt:client:viewHorse',
            args = {horseid = horseid},
            arrow = true
        })
        
        lib.registerContext({
            id = 'mdt_horse_bounty_alerts',
            title = 'Horse Bounty Alerts',
            menu = 'mdt_horse_details',
            options = options
        })
        
        lib.showContext('mdt_horse_bounty_alerts')
    end, horseid)
end)

------------------------------------------
-- Create Horse Bounty Alert
------------------------------------------
RegisterNetEvent('rsg-mdt:client:createHorseBountyAlert', function(data)
    local horseid = data.horseid
    
    local input = lib.inputDialog('Create Horse Bounty Alert', {
        {type = 'textarea', label = 'Reason', description = 'Reason for the bounty alert', required = true},
        {type = 'number', label = 'Reward', description = 'Reward amount ($)', required = false, min = 0},
        {type = 'number', label = 'Expires in Days', description = 'Days until expiration (optional)', required = false, min = 1, max = 365}
    })
    
    if input then
        local reason = input[1]
        local reward = input[2] or 0
        local expires = input[3]
        
        if reason and reason ~= '' then
            local alertData = {
                target_citizenid = horseid,  -- Folosim horseid pentru cai
                reason = reason,
                reward = tonumber(reward) or 0,
                expires_in_days = expires and tonumber(expires) or nil
            }
            
            RSGCore.Functions.TriggerCallback('rsg-mdt:server:createBountyAlert', function(success)
                if success then
                    lib.notify({
                        title = 'Bounty Alert Created',
                        description = 'Horse bounty alert created successfully',
                        type = 'success'
                    })
                else
                    lib.notify({
                        title = 'Error',
                        description = 'Failed to create horse bounty alert',
                        type = 'error'
                    })
                end
                -- Return to horse view
                TriggerEvent('rsg-mdt:client:viewHorse', {horseid = horseid})
            end, alertData)
        else
            lib.notify({
                title = 'Error',
                description = 'Reason is required',
                type = 'error'
            })
            TriggerEvent('rsg-mdt:client:viewHorse', {horseid = horseid})
        end
    else
        TriggerEvent('rsg-mdt:client:viewHorse', {horseid = horseid})
    end
end)

------------------------------------------
-- Reports Menu
------------------------------------------
RegisterNetEvent('rsg-mdt:client:openReports', function()
    local input = lib.inputDialog('Create Report', {
        {type = 'input', label = 'Title', description = 'Report title', required = true},
        {type = 'textarea', label = 'Description', description = 'Detailed report description', required = true},
        {type = 'input', label = 'Location', description = 'Incident location'}
    })
    
    if input then
        local title = input[1]
        local description = input[2]
        local location = input[3] or ''
        
        if title and description then
            local report = {
                title = title,
                description = description,
                location = location
            }
            
            RSGCore.Functions.TriggerCallback('rsg-mdt:server:createReport', function(success)
                if success then
                    lib.notify({title = 'Report Created', description = 'Report created successfully', type = 'success'})
                else
                    lib.notify({title = 'Error', description = 'Failed to create report', type = 'error'})
                end
                lib.showContext('mdt_dashboard')
            end, report)
        else
            lib.notify({title = 'Error', description = 'Title and description are required', type = 'error'})
            lib.showContext('mdt_dashboard')
        end
    else
        lib.showContext('mdt_dashboard')
    end
end)

------------------------------------------
-- Warrants Menu
------------------------------------------
RegisterNetEvent('rsg-mdt:client:openWarrants', function()
    local input = lib.inputDialog('Issue Warrant', {
        {type = 'input', label = 'Citizen ID', description = 'Target citizen ID', required = true},
        {type = 'textarea', label = 'Reason', description = 'Reason for warrant', required = true}
    })
    
    if input then
        local citizenid = input[1]
        local reason = input[2]
        
        if citizenid and reason then
            local warrant = {
                citizenid = citizenid,
                reason = reason
            }
            
            RSGCore.Functions.TriggerCallback('rsg-mdt:server:createWarrant', function(success)
                if success then
                    lib.notify({title = 'Warrant Issued', description = 'Warrant issued successfully', type = 'success'})
                else
                    lib.notify({title = 'Error', description = 'Failed to issue warrant', type = 'error'})
                end
                lib.showContext('mdt_dashboard')
            end, warrant)
        else
            lib.notify({title = 'Error', description = 'All fields are required', type = 'error'})
            lib.showContext('mdt_dashboard')
        end
    else
        lib.showContext('mdt_dashboard')
    end
end)

------------------------------------------
-- Bounty Alerts Menu
------------------------------------------
RegisterNetEvent('rsg-mdt:client:openBountyAlerts', function()
    -- This will be handled by the bounty alerts system
    lib.showContext('mdt_dashboard')
end)

------------------------------------------
-- Citations Menu
------------------------------------------
RegisterNetEvent('rsg-mdt:client:openCitations', function()
    local input = lib.inputDialog('Issue Citation', {
        {type = 'input', label = 'Citizen ID', description = 'Target citizen ID', required = true},
        {type = 'input', label = 'Reason', description = 'Reason for citation', required = true},
        {type = 'number', label = 'Amount', description = 'Fine amount ($)', required = true, min = 0}
    })
    
    if input then
        local citizenid = input[1]
        local reason = input[2]
        local amount = tonumber(input[3])
        
        if citizenid and reason and amount then
            local citation = {
                citizenid = citizenid,
                reason = reason,
                amount = amount
            }
            
            RSGCore.Functions.TriggerCallback('rsg-mdt:server:createCitation', function(success)
                if success then
                    lib.notify({
                        title = 'Citation Issued',
                        description = 'Citation issued successfully to citizen ' .. citizenid,
                        type = 'success'
                    })
                else
                    lib.notify({
                        title = 'Error',
                        description = 'Failed to issue citation',
                        type = 'error'
                    })
                end
                lib.showContext('mdt_dashboard')
            end, citation)
        else
            lib.notify({
                title = 'Error',
                description = 'All fields are required',
                type = 'error'
            })
            lib.showContext('mdt_dashboard')
        end
    else
        lib.showContext('mdt_dashboard')
    end
end)

------------------------------------------
-- MDT Keybind
------------------------------------------
CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustReleased(0, 0x80F28E95) then -- M key
            local PlayerData = RSGCore.Functions.GetPlayerData()
            if PlayerData.job.type == "leo" then
                TriggerServerEvent('rsg-mdt:server:checkMDTAccess')
            end
        end
    end
end)

RegisterNetEvent('rsg-mdt:client:openMDTFromKeybind', function()
    TriggerEvent('rsg-mdt:client:openMDT')
end)

-- Event to properly close MDT when called from anywhere
RegisterNetEvent('rsg-mdt:client:forceMDTClose', function()
    CloseMDTCompletely()
end)

-- Register onExit handler for context menus
AddEventHandler('ox_lib:context:onExit', function(id)
    if id == 'mdt_dashboard' or string.find(id, 'mdt_') then
        CloseMDTCompletely()
    end
end)