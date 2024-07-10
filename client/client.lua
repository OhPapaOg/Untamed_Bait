local VORPcore = exports.vorp_core:GetCore()

local freeTrapPrompt = nil
local trappedNPC = nil  -- Variable to track if an NPC is trapped

local baitProp = nil
local spawnedAnimal = nil
local baitPlaced = false
local noAnimalTimeout = nil
local baitPrompt = nil
local animalBlip = nil
local baitPickupPrompt = nil
local bearTrapProp = nil
local baitItemName = nil
local spawnAnimalTimer = nil
local trapDeactivated = false

-- List of known animal models
local animalModels = {
    "a_c_alligator_01",
     "a_c_alligator_02",
     "a_c_alligator_03",
     "a_c_armadillo_01",
     "a_c_badger_01",
     "a_c_bat_01",
     "a_c_bear_01",
     "a_c_bearblack_01",
     "a_c_beaver_01",
     "a_c_bighornram_01",
     "a_c_bluejay_01",
     "a_c_boar_01",
     "a_c_boarlegendary_01",
     "a_c_buck_01",
     "a_c_buffalo_01",
     "a_c_buffalo_tatanka_01",
     "a_c_bull_01",
     "a_c_californiacondor_01",
     "a_c_cardinal_01",
     "a_c_carolinaparakeet_01",
     "a_c_cat_01",
     "a_c_cedarwaxwing_01",
     "a_c_chicken_01",
     "a_c_chipmunk_01",
     "a_c_cormorant_01",
     "a_c_cougar_01",
     "a_c_cow",
     "a_c_coyote_01",
     "a_c_crab_01",
     "a_c_cranewhooping_01",
     "a_c_crawfish_01",
     "a_c_crow_01",
     "a_c_deer_01",
     "a_c_dogamericanfoxhound_01",
     "a_c_dogaustraliansheperd_01",
     "a_c_dogbluetickcoonhound_01",
     "a_c_dogcatahoulacur_01",
     "a_c_dogchesbayretriever_01",
     "a_c_dogcollie_01",
     "a_c_doghobo_01",
     "a_c_doghound_01",
     "a_c_doghusky_01",
     "a_c_doglab_01",
     "a_c_doglion_01",
     "a_c_dogpoodle_01",
     "a_c_dogrufus_01",
     "a_c_dogstreet_01",
     "a_c_donkey_01",
     "a_c_duck_01",
     "a_c_eagle_01",
     "a_c_egret_01",
     "a_c_elk_01",
     "a_c_fishbluegil_01_ms",
     "a_c_fishbluegil_01_sm",
     "a_c_fishbullheadcat_01_ms",
     "a_c_fishbullheadcat_01_sm",
     "a_c_fishchainpickerel_01_ms",
     "a_c_fishchainpickerel_01_sm",
     "a_c_fishchannelcatfish_01_lg",
     "a_c_fishchannelcatfish_01_xl",
     "a_c_fishlakesturgeon_01_lg",
     "a_c_fishlargemouthbass_01_lg",
     "a_c_fishlargemouthbass_01_ms",
     "a_c_fishlongnosegar_01_lg",
     "a_c_fishmuskie_01_lg",
     "a_c_fishnorthernpike_01_lg",
     "a_c_fishperch_01_ms",
     "a_c_fishperch_01_sm",
     "a_c_fishrainbowtrout_01_lg",
     "a_c_fishrainbowtrout_01_ms",
     "a_c_fishredfinpickerel_01_ms",
     "a_c_fishredfinpickerel_01_sm",
     "a_c_fishrockbass_01_ms",
     "a_c_fishrockbass_01_sm",
     "a_c_fishsalmonsockeye_01_lg",
     "a_c_fishsalmonsockeye_01_ml",
     "a_c_fishsalmonsockeye_01_ms",
     "a_c_fishsmallmouthbass_01_lg",
     "a_c_fishsmallmouthbass_01_ms",
     "a_c_fox_01",
     "a_c_frogbull_01",
     "a_c_gilamonster_01",
     "a_c_goat_01",
     "a_c_goosecanada_01",
     "a_c_hawk_01",
     "a_c_heron_01",
     "a_c_horse_americanpaint_greyovero",
     "a_c_horse_americanpaint_overo",
     "a_c_horse_americanpaint_splashedwhite",
     "a_c_horse_americanpaint_tobiano",
     "a_c_horse_americanstandardbred_black",
     "a_c_horse_americanstandardbred_buckskin",
     "a_c_horse_americanstandardbred_lightbuckskin",
     "a_c_horse_americanstandardbred_palominodapple",
     "a_c_horse_americanstandardbred_silvertailbuckskin",
     "a_c_horse_andalusian_darkbay",
     "a_c_horse_andalusian_perlino",
     "a_c_horse_andalusian_rosegray",
     "a_c_horse_appaloosa_blacksnowflake",
     "a_c_horse_appaloosa_blanket",
     "a_c_horse_appaloosa_brownleopard",
     "a_c_horse_appaloosa_fewspotted_pc",
     "a_c_horse_appaloosa_leopard",
     "a_c_horse_appaloosa_leopardblanket",
     "a_c_horse_arabian_black",
     "a_c_horse_arabian_grey",
     "a_c_horse_arabian_redchestnut",
     "a_c_horse_arabian_redchestnut_pc",
     "a_c_horse_arabian_rosegreybay",
     "a_c_horse_arabian_warpedbrindle_pc",
     "a_c_horse_arabian_white",
     "a_c_horse_ardennes_bayroan",
     "a_c_horse_ardennes_irongreyroan",
     "a_c_horse_ardennes_strawberryroan",
     "a_c_horse_belgian_blondchestnut",
     "a_c_horse_belgian_mealychestnut",
     "a_c_horse_breton_grullodun",
     "a_c_horse_breton_mealydapplebay",
     "a_c_horse_breton_redroan",
     "a_c_horse_breton_sealbrown",
     "a_c_horse_breton_sorrel",
     "a_c_horse_breton_steelgrey",
     "a_c_horse_buell_warvets",
     "a_c_horse_criollo_baybrindle",
     "a_c_horse_criollo_bayframeovero",
     "a_c_horse_criollo_blueroanovero",
     "a_c_horse_criollo_dun",
     "a_c_horse_criollo_marblesabino",
     "a_c_horse_criollo_sorrelovero",
     "a_c_horse_dutchwarmblood_chocolateroan",
     "a_c_horse_dutchwarmblood_sealbrown",
     "a_c_horse_dutchwarmblood_sootybuckskin",
     "a_c_horse_eagleflies",
     "a_c_horse_gang_bill",
     "a_c_horse_gang_charles",
     "a_c_horse_gang_charles_endlesssummer",
     "a_c_horse_gang_dutch",
     "a_c_horse_gang_hosea",
     "a_c_horse_gang_javier",
     "a_c_horse_gang_john",
     "a_c_horse_gang_karen",
     "a_c_horse_gang_kieran",
     "a_c_horse_gang_lenny",
     "a_c_horse_gang_micah",
     "a_c_horse_gang_sadie",
     "a_c_horse_gang_sadie_endlesssummer",
     "a_c_horse_gang_sean",
     "a_c_horse_gang_trelawney",
     "a_c_horse_gang_uncle",
     "a_c_horse_gang_uncle_endlesssummer",
     "a_c_horse_gypsycob_palominoblagdon",
     "a_c_horse_gypsycob_piebald",
     "a_c_horse_gypsycob_skewbald",
     "a_c_horse_gypsycob_splashedbay",
     "a_c_horse_gypsycob_splashedpiebald",
     "a_c_horse_gypsycob_whiteblagdon",
     "a_c_horse_hungarianhalfbred_darkdapplegrey",
     "a_c_horse_hungarianhalfbred_flaxenchestnut",
     "a_c_horse_hungarianhalfbred_liverchestnut",
     "a_c_horse_hungarianhalfbred_piebaldtobiano",
     "a_c_horse_john_endlesssummer",
     "a_c_horse_kentuckysaddle_black",
     "a_c_horse_kentuckysaddle_buttermilkbuckskin_pc",
     "a_c_horse_kentuckysaddle_chestnutpinto",
     "a_c_horse_kentuckysaddle_grey",
     "a_c_horse_kentuckysaddle_silverbay",
     "a_c_horse_kladruber_black",
     "a_c_horse_kladruber_cremello",
     "a_c_horse_kladruber_dapplerosegrey",
     "a_c_horse_kladruber_grey",
     "a_c_horse_kladruber_silver",
     "a_c_horse_kladruber_white",
     "a_c_horse_missourifoxtrotter_amberchampagne",
     "a_c_horse_missourifoxtrotter_blacktovero",
     "a_c_horse_missourifoxtrotter_blueroan",
     "a_c_horse_missourifoxtrotter_buckskinbrindle",
     "a_c_horse_missourifoxtrotter_dapplegrey",
     "a_c_horse_missourifoxtrotter_sablechampagne",
     "a_c_horse_missourifoxtrotter_silverdapplepinto",
     "a_c_horse_morgan_bay",
     "a_c_horse_morgan_bayroan",
     "a_c_horse_morgan_flaxenchestnut",
     "a_c_horse_morgan_liverchestnut_pc",
     "a_c_horse_morgan_palomino",
     "a_c_horse_mp_mangy_backup",
     "a_c_horse_murfreebrood_mange_01",
     "a_c_horse_murfreebrood_mange_02",
     "a_c_horse_murfreebrood_mange_03",
     "a_c_horse_mustang_blackovero",
     "a_c_horse_mustang_buckskin",
     "a_c_horse_mustang_chestnuttovero",
     "a_c_horse_mustang_goldendun",
     "a_c_horse_mustang_grullodun",
     "a_c_horse_mustang_reddunovero",
     "a_c_horse_mustang_tigerstripedbay",
     "a_c_horse_mustang_wildbay",
     "a_c_horse_nokota_blueroan",
     "a_c_horse_nokota_reversedappleroan",
     "a_c_horse_nokota_whiteroan",
     "a_c_horse_norfolkroadster_black",
     "a_c_horse_norfolkroadster_dappledbuckskin",
     "a_c_horse_norfolkroadster_piebaldroan",
     "a_c_horse_norfolkroadster_rosegrey",
     "a_c_horse_norfolkroadster_speckledgrey",
     "a_c_horse_norfolkroadster_spottedtricolor",
     "a_c_horse_shire_darkbay",
     "a_c_horse_shire_lightgrey",
     "a_c_horse_shire_ravenblack",
     "a_c_horse_suffolkpunch_redchestnut",
     "a_c_horse_suffolkpunch_sorrel",
     "a_c_horse_tennesseewalker_blackrabicano",
     "a_c_horse_tennesseewalker_chestnut",
     "a_c_horse_tennesseewalker_dapplebay",
     "a_c_horse_tennesseewalker_flaxenroan",
     "a_c_horse_tennesseewalker_goldpalomino_pc",
     "a_c_horse_tennesseewalker_mahoganybay",
     "a_c_horse_tennesseewalker_redroan",
     "a_c_horse_thoroughbred_blackchestnut",
     "a_c_horse_thoroughbred_bloodbay",
     "a_c_horse_thoroughbred_brindle",
     "a_c_horse_thoroughbred_dapplegrey",
     "a_c_horse_thoroughbred_reversedappleblack",
     "a_c_horse_turkoman_black",
     "a_c_horse_turkoman_chestnut",
     "a_c_horse_turkoman_darkbay",
     "a_c_horse_turkoman_gold",
     "a_c_horse_turkoman_grey",
     "a_c_horse_turkoman_perlino",
     "a_c_horse_turkoman_silver",
     "a_c_horse_winter02_01",
     "a_c_horsemule_01",
     "a_c_horsemulepainted_01",
     "a_c_iguana_01",
     "a_c_iguanadesert_01",
     "a_c_javelina_01",
     "a_c_lionmangy_01",
     "a_c_loon_01",
     "a_c_moose_01",
     "a_c_muskrat_01",
     "a_c_oriole_01",
     "a_c_owl_01",
     "a_c_ox_01",
     "a_c_panther_01",
     "a_c_parrot_01",
     "a_c_pelican_01",
     "a_c_pheasant_01",
     "a_c_pig_01",
     "a_c_pigeon",
     "a_c_possum_01",
     "a_c_prairiechicken_01",
     "a_c_pronghorn_01",
     "a_c_quail_01",
     "a_c_rabbit_01",
     "a_c_raccoon_01",
     "a_c_rat_01",
     "a_c_raven_01",
     "a_c_redfootedbooby_01",
     "a_c_robin_01",
     "a_c_rooster_01",
     "a_c_roseatespoonbill_01",
     "a_c_seagull_01",
     "a_c_sharkhammerhead_01",
     "a_c_sharktiger",
     "a_c_sheep_01",
     "a_c_skunk_01",
     "a_c_snake_01",
     "a_c_snake_pelt_01",
     "a_c_snakeblacktailrattle_01",
     "a_c_snakeblacktailrattle_pelt_01",
     "a_c_snakeferdelance_01",
     "a_c_snakeferdelance_pelt_01",
     "a_c_snakeredboa10ft_01",
     "a_c_snakeredboa_01",
     "a_c_snakeredboa_pelt_01",
     "a_c_snakewater_01",
     "a_c_snakewater_pelt_01",
     "a_c_songbird_01",
     "a_c_sparrow_01",
     "a_c_squirrel_01",
     "a_c_toad_01",
     "a_c_turkey_01",
     "a_c_turkey_02",
     "a_c_turkeywild_01",
     "a_c_turtlesea_01",
     "a_c_turtlesnapping_01",
     "a_c_vulture_01",
     "a_c_wolf",
     "a_c_wolf_medium",
     "a_c_wolf_small",
     "a_c_woodpecker_01",
     "a_c_woodpecker_02",
     "cs_mp_policechief_lambert",
     "cs_mp_senator_ricard",
     "mp_a_c_alligator_01",
     "mp_a_c_bear_01",
     "mp_a_c_beaver_01",
     "mp_a_c_bighornram_01",
     "mp_a_c_boar_01",
     "mp_a_c_buck_01",
     "mp_a_c_buffalo_01",
     "mp_a_c_chicken_01",
     "mp_a_c_cougar_01",
     "mp_a_c_coyote_01",
     "mp_a_c_deer_01",
     "mp_a_c_dogamericanfoxhound_01",
     "mp_a_c_elk_01",
     "mp_a_c_fox_01",
     "mp_a_c_horsecorpse_01",
     "mp_a_c_moose_01",
     "mp_a_c_owl_01",
     "mp_a_c_panther_01",
     "mp_a_c_possum_01",
     "mp_a_c_pronghorn_01",
     "mp_a_c_rabbit_01",
     "mp_a_c_sheep_01",
     "mp_a_c_wolf_01",
      -- Add other animal models as needed
 }

-- Prompts

function SetupPrompt(promptType)
    Citizen.CreateThread(function()
        local str = Config.BearTrap.FreePrompt
        freeTrapPrompt = PromptRegisterBegin()
        PromptSetControlAction(freeTrapPrompt, 0xE8342FF2) -- INPUT_CONTEXT (E key)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(freeTrapPrompt, str)
        PromptSetEnabled(freeTrapPrompt, false)
        PromptSetVisible(freeTrapPrompt, false)
        PromptSetHoldMode(freeTrapPrompt, true)
        PromptRegisterEnd(freeTrapPrompt)
    end)
end

function ShowPrompt(prompt)
    if prompt then
        PromptSetEnabled(prompt, true)
        PromptSetVisible(prompt, true)
    end
end

function HidePrompt(prompt)
    if prompt then
        PromptSetEnabled(prompt, false)
        PromptSetVisible(prompt, false)
    end
end

function SetupPickupPrompt()
    Citizen.CreateThread(function()
        local str = Config.Locale.pickUpBait
        baitPickupPrompt = PromptRegisterBegin()
        PromptSetControlAction(baitPickupPrompt, 0xE8342FF2) -- INPUT_CONTEXT (E key)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(baitPickupPrompt, str)
        PromptSetEnabled(baitPickupPrompt, false)
        PromptSetVisible(baitPickupPrompt, false)
        PromptSetHoldMode(baitPickupPrompt, true)
        PromptRegisterEnd(baitPickupPrompt)
    end)
end

function ShowPickupPrompt()
    if baitPickupPrompt then
        PromptSetEnabled(baitPickupPrompt, true)
        PromptSetVisible(baitPickupPrompt, true)
    end
end

function HidePickupPrompt()
    if baitPickupPrompt then
        PromptSetEnabled(baitPickupPrompt, false)
        PromptSetVisible(baitPickupPrompt, false)
    end
end

-- Functions

function IsInBlacklistZone(coords)
    for _, zone in pairs(Config.BlacklistZones) do
        local distance = #(coords - vector3(zone.x, zone.y, zone.z))
        if distance <= zone.radius then
            return true
        end
    end
    return false
end

function PlayInspectingAnimation()
    local ped = PlayerPedId()
    local dict = 'amb_work@world_human_crouch_inspect@male_a@idle_a'
    local anim = 'idle_a'

    -- Load and play the animation
    LoadAnimDict(dict)
    Wait(100)
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, Config.BaitUseTime, 1, 0, true, 0, false, 0, false)
    local progressbar = exports.vorp_progressbar:initiate()
    progressbar.start("Placing Bait...", Config.BaitUseTime, function() end, 'circle')
end

function DeleteBaitProp()
    if DoesEntityExist(baitProp) then
        DeleteEntity(baitProp)
        baitProp = nil
    end
end

function DeleteBearTrapProp()
    if DoesEntityExist(bearTrapProp) then
        DeleteEntity(bearTrapProp)
        bearTrapProp = nil
    end
end

function GetEntitiesInArea(coords, radius)
    local entities = {}
    local pedPool = GetGamePool('CPed')
    for _, ped in ipairs(pedPool) do
        if #(coords - GetEntityCoords(ped)) < radius then
            table.insert(entities, ped)
        end
    end
    return entities
end

function PlayTrapAnimation(ped)
    local dict = "script_re@bear_trap"
    local anim = "crouch_l_victim"
    local boneIndex = GetEntityBoneIndexByName(ped, "skel_l_foot")
    LoadAnimDict(dict)
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    AttachEntityToEntity(bearTrapProp, ped, boneIndex, -0.1, 0.5, -0.5, 0, 0, 105, false, false, true, false, 2, true)
    -- Freeze the NPC in place
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    -- Set trapped NPC state
    trappedNPC = ped
    -- Show prompt to free NPC
    ShowPrompt(freeTrapPrompt)
end

function ApplyDamageToEntity(entity)
    SetEntityHealth(entity, 0) -- Instantly kill the animal
end

function IsAnimal(model)
    for _, animalModel in ipairs(animalModels) do
        if GetHashKey(animalModel) == model then
            return true
        end
    end
    return false
end

function CreateAnimalBlip(entity)
    local blip = Citizen.InvokeNative(0x23f74c2fda6e7c61, 953018525, entity)
    return blip
end

function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(50)
    end
end

-- Event to handle bear trap use
RegisterNetEvent('untamed_bait:useBearTrap')
AddEventHandler('untamed_bait:useBearTrap', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local forwardVector = GetEntityForwardVector(playerPed)
    local spawnCoords = coords + forwardVector * 1.5 -- Adjust the distance as needed

    if IsInBlacklistZone(spawnCoords) then
        VORPcore.NotifyTip(Config.Locale.baitRestricted, 4000)
        if Config.Debug then print('Bear trap use attempted in a blacklist zone') end
        TriggerServerEvent('untamed_bait:returnBearTrap') -- Return the bear trap item
        return
    end

    PlayInspectingAnimation()

    local trapModel = GetHashKey(Config.BearTrap.Model)
    RequestModel(trapModel)
    while not HasModelLoaded(trapModel) do
        Citizen.Wait(0)
    end

    bearTrapProp = CreateObject(trapModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, true, true, false)
    PlaceObjectOnGroundProperly(bearTrapProp)
    bearTrapPlaced = true
    trapDeactivated = false

    if Config.Debug then print('Bear trap placed with model: ' .. Config.BearTrap.Model) end
    VORPcore.NotifyTip(Config.Locale.baitPlaced, 4000)

    Citizen.CreateThread(function()
        while DoesEntityExist(bearTrapProp) do
            Citizen.Wait(500)
            if trapDeactivated then
                break
            end

            local entities = GetEntitiesInArea(GetEntityCoords(bearTrapProp), Config.BearTrap.TrapDetectionRadius)
            if Config.Debug then print('Entities detected: ' .. #entities) end
            for _, entity in ipairs(entities) do
                if Config.Debug then print('Entity detected: ' .. GetEntityModel(entity)) end
                if IsEntityAPed(entity) and not IsPedAPlayer(entity) then
                    local model = GetEntityModel(entity)
                    if IsAnimal(model) then
                        if Config.Debug then print('Animal detected and trapped') end
                        ApplyDamageToEntity(entity, Config.BearTrap.TrapDamage)
                        DeleteEntity(bearTrapProp)
                        bearTrapProp = nil
                        break -- Ensure we only trigger once per trap
                    elseif IsPedHuman(entity) then
                        if Config.Debug then print('Human detected and trapped') end
                        if not IsPedOnMount(entity) then
                            PlayTrapAnimation(entity)
                            DeleteEntity(bearTrapProp)
                            bearTrapProp = nil
                            break -- Ensure we only trigger once per trap
                        end
                    end
                end
            end
        end
    end)

    -- Listen for shots and deactivate trap if hit
    Citizen.CreateThread(function()
        while DoesEntityExist(bearTrapProp) do
            Citizen.Wait(0)
            if HasEntityBeenDamagedByAnyPed(bearTrapProp) or HasEntityBeenDamagedByAnyVehicle(bearTrapProp) then
                if Config.Debug then print('Bear trap shot and deactivated') end
                VORPcore.NotifyTip(Config.Locale.trapShot, 4000)
                trapDeactivated = true
                DeleteEntity(bearTrapProp)
                bearTrapProp = nil
                break
            end
        end
    end)
end)

Citizen.CreateThread(function()
    SetupPrompt("freeTrap")
    SetupPickupPrompt()
    while true do
        Citizen.Wait(0) -- Reduced wait time for prompt interaction
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        -- Free trapped NPC
        if trappedNPC then
            local distance = #(playerCoords - GetEntityCoords(trappedNPC))
            if distance < 2.0 then
                ShowPrompt(freeTrapPrompt)
                if PromptHasHoldModeCompleted(freeTrapPrompt) then
                    ClearPedTasksImmediately(trappedNPC)
                    FreezeEntityPosition(trappedNPC, false)
                    SetEntityInvincible(trappedNPC, false)
                    SetBlockingOfNonTemporaryEvents(trappedNPC, false)
                    trappedNPC = nil
                    HidePrompt(freeTrapPrompt)
                end
            else
                HidePrompt(freeTrapPrompt)
            end
        end

        -- Pickup bait
        if DoesEntityExist(baitProp) then
            local distance = #(playerCoords - GetEntityCoords(baitProp))
            if distance < 2.0 then
                ShowPickupPrompt()
                if PromptHasHoldModeCompleted(baitPickupPrompt) then
                    DeleteBaitProp()
                    if spawnAnimalTimer then
                        Citizen.ClearTimeout(spawnAnimalTimer)
                        spawnAnimalTimer = nil
                    end
                    TriggerServerEvent('untamed_bait:returnBait', baitItemName)
                    HidePickupPrompt()
                end
            else
                HidePickupPrompt()
            end
        end
    end
end)

RegisterNetEvent('untamed_bait:useBait')
AddEventHandler('untamed_bait:useBait', function(itemName)
    baitItemName = itemName
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if IsInBlacklistZone(coords) then
        VORPcore.NotifyTip(Config.Locale.baitRestricted, 4000)
        if Config.Debug then print('Bait use attempted in a blacklist zone') end
        TriggerServerEvent('untamed_bait:returnBait', itemName) -- Return the bait item
        return
    end

    PlayInspectingAnimation()

    local propName = Config.BaitItems[itemName].prop
    RequestModel(propName)
    while not HasModelLoaded(propName) do
        Citizen.Wait(0)
    end

    baitProp = CreateObject(GetHashKey(propName), coords.x, coords.y, coords.z, true, true, false)
    PlaceObjectOnGroundProperly(baitProp)
    baitPlaced = true

    if Config.Debug then print('Bait placed with prop: ' .. propName) end
    VORPcore.NotifyTip(Config.Locale.baitPlaced, 4000)

    local noAnimalChance = Config.BaitItems[itemName].noAnimalChance
    if math.random() < noAnimalChance then
        noAnimalTimeout = SetTimeout(Config.NoAnimalSpawnNotificationTime, function()
            VORPcore.NotifyTip(Config.Locale.noAnimal, 4000)
        end)
    else
        spawnAnimalTimer = Citizen.SetTimeout(Config.BaitItems[itemName].waitBeforeSpawn, function()
            if baitProp then -- Check if baitProp still exists before spawning the animal
                TriggerServerEvent('untamed_bait:spawnAnimal', itemName, coords)
            end
        end)
    end
end)

RegisterNetEvent('untamed_bait:spawnAnimalClient')
AddEventHandler('untamed_bait:spawnAnimalClient', function(animal, baitCoords)
    if noAnimalTimeout then
        ClearTimeout(noAnimalTimeout)
        noAnimalTimeout = nil
    end

    local spawnCoords = {
        x = baitCoords.x + math.random(-Config.SpawnDistance, Config.SpawnDistance),
        y = baitCoords.y + math.random(-Config.SpawnDistance, Config.SpawnDistance),
        z = baitCoords.z
    }

    RequestModel(animal)
    while not HasModelLoaded(animal) do
        Citizen.Wait(0)
    end

    local found, groundZ = GetGroundZFor_3dCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z, 0)
    if found then
        spawnCoords.z = groundZ
    end

    spawnedAnimal = CreatePed(animal, spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, false, false, false, false)
    SetRandomOutfitVariation(spawnedAnimal, true)
    animalBlip = CreateAnimalBlip(spawnedAnimal)

    if Config.Debug then print('Animal created with model: ' .. animal) end
    VORPcore.NotifyTip(Config.Locale.animalApproaching, 4000)

    TaskGoToCoordAnyMeans(spawnedAnimal, baitCoords.x, baitCoords.y, baitCoords.z, 1.0, 0, 0, 786603, 0xbf800000)

    while #(GetEntityCoords(spawnedAnimal) - baitCoords) > 1.0 do
        Citizen.Wait(500)
    end

    ClearPedTasks(spawnedAnimal)
    if Config.Debug then print('Animal reached the bait') end

    Citizen.Wait(Config.BaitStayTime)

    local playerPed = PlayerPedId()
    if #(GetEntityCoords(spawnedAnimal) - GetEntityCoords(playerPed)) < 20.0 then
        TaskReactAndFleePed(spawnedAnimal, playerPed)
        if Config.Debug then print('Animal spotted player and is fleeing') end
    else
        TaskWanderStandard(spawnedAnimal, 10.0, 10)
        if Config.Debug then print('Animal is wandering off') end
    end

    DeleteBaitProp()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeleteBearTrapProp()
        HidePrompt(freeTrapPrompt)
        HidePickupPrompt()
        DeleteBaitProp()
        if DoesEntityExist(spawnedAnimal) then
            DeleteEntity(spawnedAnimal)
            if Config.Debug then print('Spawned animal deleted on resource stop') end
        end
        if DoesBlipExist(animalBlip) then
            RemoveBlip(animalBlip)
            if Config.Debug then print('Animal blip removed on resource stop') end
        end
        -- Ensure any active free trap prompt is deleted
        if freeTrapPrompt then
            PromptSetEnabled(freeTrapPrompt, false)
            PromptSetVisible(freeTrapPrompt, false)
            PromptDelete(freeTrapPrompt)
            freeTrapPrompt = nil
        end
    end
end)