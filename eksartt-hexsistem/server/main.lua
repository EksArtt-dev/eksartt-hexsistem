local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('hexekle:hexelmesiki')
AddEventHandler('hexekle:hexelmesiki', function(hex)
    local src = source

    if not hex or not string.match(hex, '^steam:%x+$') then
        TriggerClientEvent('QBCore:Notify', src, 'Geçersiz Hex İd!', 'error')
        return
    end


    exports.oxmysql:insert('INSERT INTO eksartt_hex (hex) VALUES (?)', {hex}, function(id)
        if id then
            TriggerClientEvent('QBCore:Notify', src, 'Hex başarıyla eklendi!', 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Hex eklenemedi.', 'error')
        end
    end)
end)

RegisterServerEvent('hexsil:hexsilmesiki')
AddEventHandler('hexsil:hexsilmesiki', function(hex)
    local src = source
    exports.oxmysql:update('DELETE FROM eksartt_hex WHERE hex = ?', {hex}, function(affectedRows)
        if affectedRows > 0 then
            TriggerClientEvent('QBCore:Notify', src, 'Hex başarıyla silindi!', 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Hex bulunamadı.', 'error')
        end
    end)
end)
RegisterNetEvent("hexmenu:checkAdmin", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player and Player.PlayerData.group == "admin" then
        TriggerClientEvent("hexmenu:open", src)
    else
        TriggerClientEvent('QBCore:Notify', src, "Bu komutu kullanma yetkiniz yok.", "error") 
    end
end)


AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local steamHex = nil

    for _, id in pairs(identifiers) do
        if string.sub(id, 1, 6) == "steam:" then
            steamHex = id
            break
        end
    end

    deferrals.defer()

    if not steamHex then
        deferrals.done('Steam hesabınız bağlı değil. Lütfen Steam ile giriş yapın.')
        return
    end


    exports.oxmysql:scalar('SELECT COUNT(*) FROM eksartt_hex WHERE hex = ?', {steamHex}, function(count)
        if count > 0 then
            deferrals.done()
        else
            local message = ('Bu sunucuya giriş izniniz bulunmuyor. Steam Hex ID\'niz: %s\nLütfen admin ile iletişime geçin.'):format(steamHex)
            deferrals.done(message)
        end
    end)
end)

RegisterCommand("hexmenu", function(source, args, rawCommand)
    local src = source

    if IsPlayerAceAllowed(src, "admin") then
        TriggerClientEvent('eksartt-hexsistem:ac', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Komutu kullanmaya yetkiniz yetmiyor!', 'error')
    end
end)
