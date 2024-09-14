local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('samifix-emlakv2:client:SetupJobLocations', function()
    local playerData = QBCore.Functions.GetPlayerData()
    local job = playerData.job.name
    local jobLocations = Config.JobLocations[job]

    if jobLocations then
        for _, location in ipairs(jobLocations) do
            exports['qb-target']:AddTargetZone({
                coords = location,
                options = {
                    {
                        type = "client",
                        event = "samifix-emlakv2:client:StartMoneyWash",
                        icon = "fas fa-money-check",
                        label = "Kara Para Bozdurma",
                        job = job 
                    }
                },
                distance = 5.0 
            })
        end
    else
        QBCore.Functions.Notify("Bu meslek için geçerli bir konum bulunmuyor!", "error")
    end
end)

RegisterNetEvent('samifix-emlakv2:client:StartMoneyWash', function()
    local playerData = QBCore.Functions.GetPlayerData()
    local job = playerData.job.name
    local jobLocations = Config.JobLocations[job]

    if jobLocations then
        QBCore.Functions.TriggerCallback('samifix-emlakv2:client:GetPlayerDirtyMoney', function(dirtyMoney)
                local input = exports['qb-input']:ShowInput({
                header = "Kara Para Bozdurma",
                submitText = "Boz",
                inputs = {
                    {
                        type = 'number',
                        isRequired = true,
                        name = 'amount',
                        text = 'Miktar (Mevcut Kara Para: $'..dirtyMoney..')'
                    }
                }
            })

            if input and tonumber(input.amount) then
                local amount = tonumber(input.amount)
                if amount <= dirtyMoney then
                    TriggerServerEvent('samifix-emlakv2:server:MoneyWash', amount)
                else
                    QBCore.Functions.Notify("Girdiğiniz miktar, mevcut kara paradan fazla!", "error")
                end
            end
        end)
    else
        QBCore.Functions.Notify("Bu meslek için geçerli bir konum bulunmuyor!", "error")
    end
end)


QBCore.Functions.CreateCallback('samifix-emlakv2:client:GetPlayerDirtyMoney', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local dirtyMoneyItem = Config.DirtyMoneyItem
    local dirtyMoney = Player.Functions.GetItemByName(dirtyMoneyItem) and Player.Functions.GetItemByName(dirtyMoneyItem).amount or 0
    cb(dirtyMoney)
end)


AddEventHandler('QBCore:Client:OnJobUpdate', function()
    TriggerEvent('samifix-emlakv2:client:SetupJobLocations')
end)
