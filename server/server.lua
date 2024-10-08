local VorpCore = {}
local VorpInv = {}

local playerBaits = {}
local bearTraps = {}

TriggerEvent("getCore", function(core)
    VorpCore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

-- Register usable items for each bait item in the config
Citizen.CreateThread(function()
    for itemName, _ in pairs(Config.BaitItems) do
        VorpInv.RegisterUsableItem(itemName, function(data)
            local _source = data.source

            -- Track player bait usage
            playerBaits[_source] = true 
            if Config.Debug then print('Bait placed by player: ', playerBaits[_source]) end
            
            -- Close player's inventory and remove one bait item from their inventory
            VorpInv.CloseInv(data.source)
            VorpInv.subItem(_source, itemName, 1)

            -- Trigger the client event to place the bait
            if Config.Debug then print('Usable item registered: ' .. itemName) end
            TriggerClientEvent('untamed_bait:useBait', _source, itemName)
        end)
    end

    -- Register usable bear trap item if enabled in config
    if Config.BearTrap.Enabled then
        VorpInv.RegisterUsableItem(Config.BearTrap.ItemName, function(data)
            local _source = data.source

            -- Track player bear trap usage
            bearTraps[_source] = true

            -- Close player's inventory and remove one bear trap item from their inventory
            if Config.Debug then print('Trap placed by player: ', bearTraps[_source]) end
            VorpInv.CloseInv(_source)
            VorpInv.subItem(_source, Config.BearTrap.ItemName, 1)

            -- Trigger the client event to place the bear trap
            if Config.Debug then print('Bear trap usable item registered: ' .. Config.BearTrap.ItemName) end
            TriggerClientEvent('untamed_bait:useBearTrap', _source)
        end)
    end
end)

-- Handle the spawning of animals
RegisterServerEvent('untamed_bait:spawnAnimal')
AddEventHandler('untamed_bait:spawnAnimal', function(itemName, baitCoords)
    local src = source
    local animals = Config.BaitItems[itemName].animals
    local animal = animals[math.random(#animals)]
    if Config.Debug then print('Broadcasting animal spawn from server') end
    TriggerClientEvent('untamed_bait:spawnAnimalClient', -1, animal, baitCoords, src)
end)

-- Return bear trap to the player if the trap was deactivated
RegisterServerEvent('untamed_bait:returnBearTrap')
AddEventHandler('untamed_bait:returnBearTrap', function()
    local _source = source

    if not bearTraps[_source] then
        return
    end

    if Config.Debug then print('Returning bear trap to player: ', _source) end
    VorpInv.addItem(_source, Config.BearTrap.ItemName, 1) -- Return the bear trap item
    VorpCore.NotifyRightTip(_source, Config.Locale.returnBait, 4000)
    bearTraps[_source] = nil
end)

-- Return bait to the player if the bait is picked up
RegisterServerEvent('untamed_bait:returnBait')
AddEventHandler('untamed_bait:returnBait', function(itemName)
    local _source = source

    if not playerBaits[_source] then
        return
    end

    if Config.Debug then print('Returning bait to player: ', _source) end

    for baitName, _ in pairs(Config.BaitItems) do
        if baitName == itemName then
            VorpInv.addItem(_source, itemName, 1)
            VorpCore.NotifyRightTip(_source, Config.Locale.returnBait, 4000)
            playerBaits[_source] = nil
        end
    end
end)

-- Event to clear player baits if the player leaves or the script stops
AddEventHandler('playerDropped', function()
    local _source = source

    if playerBaits[_source] then
        playerBaits[_source] = nil
    end
    if bearTraps[_source] then
        bearTraps[_source] = nil
    end
end)

-- Clean up on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for _source, _ in pairs(playerBaits) do
            if playerBaits[_source] then
                playerBaits[_source] = nil
            end
        end
        for _source, _ in pairs(bearTraps) do
            if bearTraps[_source] then
                bearTraps[_source] = nil
            end
        end
    end
end)