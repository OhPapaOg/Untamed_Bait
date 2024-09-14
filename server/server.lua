local VorpCore = {}
local VorpInv = {}

local playerBaits = {}
local bearTraps = {}
local spawnedAnimals = {}

TriggerEvent("getCore", function(core)
    VorpCore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

-- Handles spawning of animals when bait is placed
RegisterServerEvent('untamed_bait:spawnAnimal')
AddEventHandler('untamed_bait:spawnAnimal', function(itemName, baitCoords)
    local src = source

    -- Ensure only one animal spawn per bait
    if spawnedAnimals[src] then
        return
    end

    local animals = Config.BaitItems[itemName].animals
    local animal = animals[math.random(#animals)]

    if Config.Debug then print('Broadcasting animal spawn from server') end

    -- Save the spawned animal for this bait event to prevent multiple spawns
    spawnedAnimals[src] = true

    -- Broadcast to all clients to spawn a networked animal
    TriggerClientEvent('untamed_bait:spawnAnimalClient', -1, animal, baitCoords, src)
end)

-- Register usable items for bait and bear traps
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

-- Clean up player data when they disconnect
AddEventHandler('playerDropped', function()
    local _source = source
    if spawnedAnimals[_source] then
        spawnedAnimals[_source] = nil
    end
    playerBaits[_source] = nil
    bearTraps[_source] = nil
end)
