-- RSG Mobile Data Terminal (MDT)
-- Client-side main entry point

local isMDTOpen = false
local lastOpenAttempt = 0
local cooldownTime = 1000 -- 1 second cooldown
local RSGCore = nil

-- Wait for RSGCore to be ready
CreateThread(function()
    while RSGCore == nil do
        if GetResourceState('rsg-core') == 'started' then
            RSGCore = exports['rsg-core']:GetCoreObject()
        end
        Wait(100)
    end
    
    -- Register command for both chat and key mapping
    RegisterCommand(Config.MDTCommand, function()
        local currentTime = GetGameTimer()
        if not isMDTOpen and (currentTime - lastOpenAttempt) > cooldownTime then
            lastOpenAttempt = currentTime
            TriggerServerEvent('rsg-mdt:server:checkPermission')
        end
    end, false)
    
    -- Register key mapping (only once)
    if RegisterKeyMapping then
        RegisterKeyMapping(Config.MDTCommand, 'Open MDT System', 'keyboard', Config.MDTKeybind)
    end
end)

-- Event to open MDT after permission check
RegisterNetEvent('rsg-mdt:client:openMDT', function()
    if not isMDTOpen then
        isMDTOpen = true
        print('[^2RSG-MDT^7] Opening MDT System...')
        
        -- Trigger the actual MDT interface
        TriggerEvent('rsg-mdt:client:openMDTInterface')
        
        -- Create ESC key handler thread
        CreateThread(function()
            while isMDTOpen do
                Wait(0)
                if IsControlJustReleased(0, 0x156F7119) then -- ESC key
                    TriggerEvent('rsg-mdt:client:closeMDT')
                    break
                end
            end
        end)
        
        -- Auto-cleanup when ox_lib context menu closes
        CreateThread(function()
            Wait(500) -- Small delay to let menu open
            while isMDTOpen do
                Wait(100)
                if not lib.getOpenContextMenu() then
                    -- Menu closed, cleanup state
                    TriggerEvent('rsg-mdt:client:closeMDT')
                    break
                end
            end
        end)
    end
end)

-- Event to close MDT
RegisterNetEvent('rsg-mdt:client:closeMDT', function()
    if isMDTOpen then
        isMDTOpen = false
        print('[^2RSG-MDT^7] MDT interface closed')
    end
end)

-- Check if MDT is open
function IsMDTOpen()
    return isMDTOpen
end

-- Export function
exports('IsMDTOpen', IsMDTOpen)