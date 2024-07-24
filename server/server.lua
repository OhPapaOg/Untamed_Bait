local VorpCore = {}
local VorpInv = {}

local playerBaits = {}
local bearTraps = {}

TriggerEvent("getCore", function(core)
    VorpCore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

RegisterServerEvent('untamed_bait:spawnAnimal')
AddEventHandler('untamed_bait:spawnAnimal', function(itemName, baitCoords)
    local src = source
    local animals = Config.BaitItems[itemName].animals
    local animal = animals[math.random(#animals)]
    if Config.Debug then print('Broadcasting animal spawn from server') end
    TriggerClientEvent('untamed_bait:spawnAnimalClient', -1, animal, baitCoords, src)
end)

Citizen.CreateThread(function()
    for itemName, _ in pairs(Config.BaitItems) do
        VorpInv.RegisterUsableItem(itemName, function(data)
            local _source = data.source


            playerBaits[_source] = true 
            if Config.Debug then print('Bait: ', playerBaits[_source]) end
            VorpInv.CloseInv(data.source)
            VorpInv.subItem(_source, itemName, 1)
            if Config.Debug then print('Usable item registered: ' .. itemName) end
            TriggerClientEvent('untamed_bait:useBait', _source, itemName)
        end)
    end
    if Config.BearTrap.Enabled then
        VorpInv.RegisterUsableItem(Config.BearTrap.ItemName, function(data)
            local _source = data.source

            bearTraps[_source] = true

            if Config.Debug then print('Trap: ', playerBaits[_source]) end
            VorpInv.CloseInv(_source)
            VorpInv.subItem(_source, Config.BearTrap.ItemName, 1) -- Ensure item is removed on placement
            if Config.Debug then print('Bear trap usable item registered: ' .. Config.BearTrap.ItemName) end
            TriggerClientEvent('untamed_bait:useBearTrap', _source)
        end)
    end
end)

RegisterServerEvent('untamed_bait:returnBearTrap')
AddEventHandler('untamed_bait:returnBearTrap', function()
    local _source = source

    if not bearTraps[_source] then
        return
    end

    if Config.Debug then print('Beartrap1: ', bearTraps[_source]) end
    VorpInv.addItem(_source, Config.BearTrap.ItemName, 1) -- Return the bear trap item
    VorpCore.NotifyRightTip(_source, Config.Locale.returnBait, 4000)
    bearTraps[source] = nil
    if Config.Debug then print('Beartrap2: ', bearTraps[_source]) end
end)

RegisterServerEvent('untamed_bait:returnBait')
AddEventHandler('untamed_bait:returnBait', function(itemName)

    local _source = source
    if not playerBaits[_source] then
        return
    end

    if Config.Debug then print('Baits1: ', playerBaits[_source]) end

    for baitName, _ in pairs(Config.BaitItems) do
        if baitName == itemName then
            VorpInv.addItem(_source, itemName, 1)
            VorpCore.NotifyRightTip(_source, Config.Locale.returnBait, 4000)
            playerBaits[_source] = nil
        end
    end

    if Config.Debug then print('Baits2: ', playerBaits[_source]) end

end)
