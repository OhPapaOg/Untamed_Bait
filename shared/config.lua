Config = {}

Config.Debug = true  -- Set to true to enable debug prints

Config.BaitItems = { -- You can make certain bait be more effective than others. 
    ["grizzly_bait"] = { -- item in your db
        prop = "s_grizzlybait01x",
        animals = {"a_c_bear_01", "a_c_buffalo_01"}, -- I don't suggest wolves, they behave weirdly.
        waitBeforeSpawn = 15000,  -- Time in milliseconds to wait before the animal spawns
        noAnimalChance = 0.25    -- Chance that no animal will spawn (0.25 means 25%)
    },
    -- Add more bait items here
}

Config.BlacklistZones = {
    {x = -296.72, y = 790.21, z = 118.38, radius = 250.0}, -- Valentine
    -- Add more blacklist zones here
}

Config.BearTrap = { -- Trap instantly kills animals
    Enabled = true, -- Enable or disable the bear trap feature
    ItemName = "bear_trap", -- Item name for the bear trap
    Model = "p_beartrap01x", -- Bear trap model
    TrapDetectionRadius = 2.0, -- Radius to detect entities
    FreePrompt = "Release Trap", -- Prompt text to free NPCs
}

Config.SpawnDistance = 80.0  -- Distance at which animals spawn far from the bait
Config.BaitUseTime = 3000     -- Time in milliseconds it takes to place the bait
Config.AnimalApproachTime = 5000  -- Time in milliseconds before the animal starts moving towards the bait
Config.BaitStayTime = 10000   -- Time in milliseconds the animal stays at the bait if not alerted
Config.NoAnimalSpawnNotificationTime = 15000 -- Time in milliseconds to wait before notifying no animal spawned

Config.Locale = {
    baitRestricted = "You cannot use bait in this area.",
    baitPlaced = "Bait placed successfully.",
    animalApproaching = "An animal has been attracted to the bait.",
    noAnimal = "No animal seems to be approaching.",
    pickUpBait = "Pick Up",
    returnBait = "You picked up the bait and got it back.",
    trapShot = "The trap has been deactivated by shooting!",
}