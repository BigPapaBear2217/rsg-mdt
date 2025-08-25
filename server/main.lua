-- RSG Mobile Data Terminal (MDT)
-- Server-side main entry point

-- Wait for RSGCore to be ready
local RSGCore = nil

CreateThread(function()
    while RSGCore == nil do
        if GetResourceState('rsg-core') == 'started' then
            RSGCore = exports['rsg-core']:GetCoreObject()
        end
        Wait(100)
    end
    
    print('[^2RSG-MDT^7] Mobile Data Terminal system initialized')
end)

-- Check player permission for MDT access
lib.callback.register('rsg-mdt:server:getPlayerData', function(source)
    if not RSGCore then return nil end
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then return nil end
    
    local job = Player.PlayerData.job.name
    local allowed = false
    
    for _, allowedJob in ipairs(Config.AllowedJobs) do
        if job == allowedJob then
            allowed = true
            break
        end
    end
    
    if not allowed then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Access Denied',
            description = 'You do not have permission to access the MDT system',
            type = 'error'
        })
        return nil
    end
    
    return {
        citizenid = Player.PlayerData.citizenid,
        name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
        job = job,
        grade = Player.PlayerData.job.grade.level
    }
end)

-- Event to check MDT permission
RegisterNetEvent('rsg-mdt:server:checkPermission', function()
    local src = source
    if not RSGCore then return end
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local job = Player.PlayerData.job.name
    local allowed = false
    
    for _, allowedJob in ipairs(Config.AllowedJobs) do
        if job == allowedJob then
            allowed = true
            break
        end
    end
    
    if allowed then
        TriggerClientEvent('rsg-mdt:client:openMDT', src)
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Access Denied',
            description = 'You do not have permission to access the MDT system',
            type = 'error'
        })
    end
end)

-- Version check
CreateThread(function()
    if GetCurrentResourceName() ~= 'rsg-mdt' then
        print('[^3WARNING^7] Resource name should be ^2rsg-mdt^7 for proper functionality')
    end
end)