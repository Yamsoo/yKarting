TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("Yams:PayKart")
AddEventHandler("Yams:PayKart", function(prix)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeMoney(prix)
    TriggerClientEvent('esx:showNotification', source, '<C>Karting ~y~YamsBase\n~s~Vous avez payé ~g~'..prix..' $ ~s~pour le Karting')
end)