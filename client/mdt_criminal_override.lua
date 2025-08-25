-- View Criminal Record
local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterNetEvent('rsg-mdt:client:viewCriminalRecord', function(data)
    TriggerEvent('rsg-mdt:client:viewCriminalRecordWithAdd', data)
end)