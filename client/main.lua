local QBCore = exports['qb-core']:GetCoreObject()

local function OpenMenu()
    DoScreenFadeOut(0)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false)
    SetNuiFocus(true, true)
    Wait(2000)
    local Locations = {}
    for key, value in pairs(Config.Locations) do
        value.type = 'default'
        Locations[#Locations+1] = value
    end
    QBCore.Functions.GetPlayerData(function(PlayerData)
        Locations[#Locations+1] = {
            type = 'last_location',
            label = 'Son Konum',
            coords = {
                x = PlayerData.position.x,
                y = PlayerData.position.y,
                z = PlayerData.position.z
            }
        }
    end)
    sendNuiMessage('OpenMenu', {
        locations = Locations,
        images = Config.Images
    })
    DoScreenFadeIn(1000)
end

RegisterNetEvent('nSpawn:client:OpenMenu', OpenMenu)

RegisterNUICallback('SelectLocation', function(data)
    DoScreenFadeOut(0)
    SetNuiFocus(false)
    local ped = PlayerPedId()
    SetEntityCoords(ped, data.coords.x, data.coords.y, data.coords.z)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true)
    Wait(2000)
    DoScreenFadeIn(1000)
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
end)

RegisterNUICallback('GoBack', function()
    SetNuiFocus(false)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true)
    TriggerEvent('nMulticharacter:client:OpenMulticharacter')
end)

RegisterCommand('spawn', function()
    TriggerEvent('nSpawn:client:OpenMenu')
end)