ESX.RegisterServerCallback('rRadio:getItem', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local qtty = xPlayer.getInventoryItem(item).count

    cb(qtty)
end)