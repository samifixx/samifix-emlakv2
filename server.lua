local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('samifix-emlakv2:server:MoneyWash', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local playerJob = Player.PlayerData.job.name
    local dirtyMoneyItem = Config.DirtyMoneyItem
    local dirtyMoney = Player.Functions.GetItemByName(dirtyMoneyItem) and Player.Functions.GetItemByName(dirtyMoneyItem).amount or 0

    if not Config.JobLocations[playerJob] then
        TriggerClientEvent('QBCore:Notify', src, "Bu iş rolü için kara para bozdurma işlemi yapılamaz!", "error")
        return
    end

    if dirtyMoney >= amount then
        local moneyToAdd = amount * (Config.MoneyWashRate / 100)
        Player.Functions.RemoveItem(dirtyMoneyItem, amount)
        Player.Functions.AddMoney('cash', moneyToAdd)
        TriggerClientEvent('QBCore:Notify', src, "Başarıyla kara para bozduruldu!", "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "Yeterli kara paranız yok!", "error")
    end
end)

QBCore.Functions.CreateCallback('samifix-emlakv2:client:GetPlayerDirtyMoney', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local dirtyMoneyItem = Config.DirtyMoneyItem
    local dirtyMoney = Player.Functions.GetItemByName(dirtyMoneyItem) and Player.Functions.GetItemByName(dirtyMoneyItem).amount or 0
    cb(dirtyMoney)
end)
