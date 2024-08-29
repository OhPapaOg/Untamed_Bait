local VorpCore = {}
local VorpInv = {}

local playerBaits = {}
local bearTraps = {}

TriggerEvent("getCore", function(core)
    VorpCore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

-- Handles spawning of animals when bait is placed
RegisterServerEvent('untamed_bait:spawnAnimal')
AddEventHandler('untamed_bait:spawnAnimal', function(itemName, baitCoords)
    local src = source
    local animals = Config.BaitItems[itemName].animals
    local animal = animals[math.random(#animals)]
    if Config.Debug then print('Broadcasting animal spawn from server') end
    -- Only notify the player who placed the bait to spawn the animal
    TriggerClientEvent('untamed_bait:spawnAnimalClient', src, animal, baitCoords, src)
end)

-- Register usable items for bait and bear traps
Citizen.CreateThread(function()
    for itemName, _ in pairs(Config.BaitItems) do
        VorpInv.RegisterUsableItem(itemName, function(data)
            local _source = data.source

            -- Mark that this player has placed bait
            playerBaits[_source] = true 
            if Config.Debug then print('Bait placed for player: ', _source) end
            VorpInv.CloseInv(data.source)
            VorpInv.subItem(_source, itemName, 1) -- Remove one bait item from inventory
            if Config.Debug then print('Usable item registered: ' .. itemName) end
            -- Notify client to use bait
            TriggerClientEvent('untamed_bait:useBait', _source, itemName)
        end)
    end

    if Config.BearTrap.Enabled then
        VorpInv.RegisterUsableItem(Config.BearTrap.ItemName, function(data)
            local _source = data.source

            -- Mark that this player has placed a bear trap
            bearTraps[_source] = true
            if Config.Debug then print('Bear trap placed for player: ', _source) end
            VorpInv.CloseInv(_source)
            VorpInv.subItem(_source, Config.BearTrap.ItemName, 1) -- Remove bear trap item from inventory
            if Config.Debug then print('Bear trap usable item registered: ' .. Config.BearTrap.ItemName) end
            -- Notify client to use bear trap
            TriggerClientEvent('untamed_bait:useBearTrap', _source)
        end)
    end
end)

-- Handle returning bear trap to inventory
RegisterServerEvent('untamed_bait:returnBearTrap')
AddEventHandler('untamed_bait:returnBearTrap', function()
    local _source = source

    if not bearTraps[_source] then
        return
    end

    if Config.Debug then print('Returning bear trap for player: ', _source) end
    VorpInv.addItem(_source, Config.BearTrap.ItemName, 1) -- Return the bear trap item
    VorpCore.NotifyRightTip(_source, Config.Locale.returnBait, 4000)
    bearTraps[_source] = nil -- Clear the trap placement status
    if Config.Debug then print('Bear trap returned for player: ', _source) end
end)

-- Handle returning bait to inventory
RegisterServerEvent('untamed_bait:returnBait')
AddEventHandler('untamed_bait:returnBait', function(itemName)
    local _source = source

    if not playerBaits[_source] then
        return
    end

    if Config.Debug then print('Returning bait for player: ', _source) end

    for baitName, _ in pairs(Config.BaitItems) do
        if baitName == itemName then
            VorpInv.addItem(_source, itemName, 1) -- Return the bait item
            VorpCore.NotifyRightTip(_source, Config.Locale.returnBait, 4000)
            playerBaits[_source] = nil -- Clear the bait placement status
        end
    end

    if Config.Debug then print('Bait returned for player: ', _source) end
end)

-- Clean up player data when they disconnect
AddEventHandler('playerDropped', function()
    local _source = source
    playerBaits[_source] = nil
    bearTraps[_source] = nil
end)