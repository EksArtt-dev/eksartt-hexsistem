local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('eksartt-hexsistem:ac', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "ui",
        status = true
    })
end)

RegisterNUICallback('addHex', function(data, cb)
    local hex = data.hex
    TriggerServerEvent('hexekle:hexelmesiki', hex) 
end)

RegisterNUICallback('removeHex', function(data, cb)
    local hex = data.hex
    TriggerServerEvent('hexsil:hexsilmesiki', hex) 

end)

RegisterNUICallback("closeUI", function(data, cb)
    SetNuiFocus(false, false) 
    SendNUIMessage({
        type = "ui",
        status = false 
    })
end)
