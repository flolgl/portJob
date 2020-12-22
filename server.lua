ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("portjob:getMoney")
AddEventHandler("portjob:getMoney", function(salaire)
    local xPlayer = ESX.GetPlayerFromId(source)
    local i = 0

    for k,v in pairs (salaire) do 
        if v > Config.MaxSalaire then 
            print (xPlayer.identifier.." is a cheater")
            return
        end
        xPlayer.addAccountMoney('bank', v)
        i = i + v
    end
    --xPlayer.showNotification("Tu as reçu ~g~"..i.."$", i)
    xPlayer.showNotification("You've received ~g~$"..i, i)

end)