-- View Person Details (cu Bounty Alerts)
local RSGCore = exports['rsg-core']:GetCoreObject()

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
        
        -- Bounty Alerts
        table.insert(options, {
            title = 'Bounty Alerts',
            description = 'View bounty alerts for this person',
            icon = 'fa-solid fa-user-secret',
            event = 'rsg-mdt:client:viewPersonBountyAlerts',
            args = {citizenid = citizenid},
            arrow = true
        })
        
        -- Back button
        table.insert(options, {
            title = 'Back',
            description = 'Return to persons search',
            icon = 'fa-solid fa-arrow-left',
            event = 'rsg-mdt:client:openPersons',
            arrow = true
        })
        
        lib.registerContext({
            id = 'mdt_person_details',
            title = 'Person Details',
            menu = 'mdt_persons_results',
            options = options
        })
        
        lib.showContext('mdt_person_details')
    end, citizenid)
end)