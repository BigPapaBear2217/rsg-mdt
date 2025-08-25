-- View Citations
local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterNetEvent('rsg-mdt:client:viewCitations', function(data)
    TriggerEvent('rsg-mdt:client:viewCitationsWithPay', data)
end)