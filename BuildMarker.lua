BuildMarker = {}
BuildMarker.name = "BuildMarker"
LSET = LibSets
local logger = LibDebugLogger.Create(BuildMarker.name)
local show_log = false
local SDLV = DebugLogViewer

function is_empty_or_nil(t)
    if not t then return true end
    if type(t) == "table" then
        if next(t) == nil then
            return true
        else
            return false
        end
    elseif type(t) == "string" then
        if t == nil then
            return true
        elseif t == "" then
            return true
        else
            return false
        end
    elseif type(t) == "nil" then
        return true
    end
end

local function is_in(search_value, search_table)
    if is_empty_or_nil(search_value) then return false end
    for k, v in pairs(search_table) do
        if search_value == v then return true end
        if type(search_value) == "string" then
            if string.find(string.lower(v), string.lower(search_value)) then return true end
        end
    end
    return false
end

local function is_meta_set(set_name, set_id)
    local new_cp_sets = {
        "Caluurion's Legacy",
        "Plaguebreak",
    }
    local meta_sets = {
        -- Medium Armor
        "Shield Breaker",
        "Defiler",
        "Tooth of Lokkestiiz",
        "Arms of Relequen",
        -- "New Moon Acolyte", << also Magicka Set?
        "Deadly Strike",
        "Vicious Serpent",
        "Armor of Truth",
        "Aegis Caller",
        "Roar of Alkosh",
        "War Machine",
        "Twice-Fanged Serpent",
        "Berserking Warrior",
        "The Morag Tong",
        "Mechanical Acuity",
        "Dragonguard Elite",
        "Yandir's Might",
        "Shadow of the Red Mountain",
        "Essence Thief",
        "Spriggan's Thorns",
        "Azureblight Reaper",
        "Heem-Jas' Retribution",
        "Scavenging Demise",
        "Powerful Assault",
        "Draugr Hulk",
        -- Light Armor
        "Elemental Catalyst",
        "Robes of Transmutation",
        "Ysgramor's Birthright",
        "Vampire Lord",
        "Winter's Respite",
        "Desert Rose",
        "Silks of the Sun",
        "Mantle of Siroria",
        "Mother's Sorrow",
        "New Moon Acolyte",
        "Master Architect",
        "Elf Bane",
        "Spell Strategist",
        "Elemental Succession",
        -- "Mechanical Acuity", << also Stam Set?
        "Burning Spellweave",
        "Scathing Mage",
        "Draugrkin's Grip",
        "Z'en's Redress",
        "Way of Martial Knowledge",
        "Moondancer",
        "Overwhelming Surge",
        "Infallible Mage",
        -- Heavy Armor
        "The Ice Furnace",
        "Green Pact",
        "Akaviri Dragonguard",
        "Plague Doctor",
        "Warrior-Poet",
        "Bahraha's Curse",
        -- Maelstrom Arena
        "Perfected Rampaging Slash",
        -- Dragonstar Arena
        "Puncturing Remedy",
        "Perfected Puncturing Remedy",
        --  Asylum Sanctorium
        "Disciplined Slash",
        --Blackrose Prison
        "Mender's Ward",
        "Perfected Mender's Ward",
        -- Mythic
        "Torc of Tonal Constancy",
        --  Craftable, meaning Light, Heavy, or Medium
        "Stuhn's Favor",
        "Coldharbour's Favorite",
        "Jorvuld's Guidance",
        "Vestment of Olorime",
        "Kagrenac's Hope",
        -- PVP Sets
        "Warrior's Fury",
        "Vengeance Leech",
        "Clever Alchemist",
        "Endurance",
        "Eternal Hunt",
        "Caustic Arrow",
        "Crafty Alfiq",
        "Shacklebreaker",
        "Blessing of the Potentates",
        "Titanborn Strength",
        -- Newly found
        "Armor of the Trainee",
        "Icy Conjuror",
        "Impregnable Armor",
        "Seventh Legion Brute",
        "Mark of the Pariah",
        "Death's Wind",
        "Knight-Errant's Mail",
        "Ravager",
        "Gossamer",
        "Durok's Bane",
        "Shroud of the Lich",
        "Daring Corsair",
        "Hanu's Compassion",
        "Rattlecage",
        "Sheer Venom",
        "Eternal Vigor",
        "Orgnum's Scales",
        "The Worm's Raiment",
        "Medusa",
        "Venomous Smite",
        "Vicious Death",
        "Robes of Destruction Mastery",
        "Swamp Raider",
        "Trappings of Invigoration",
        "Gallant Charge",
        "Imperial Physique",
        "Vesture of Darloc Brae",
        "Jailbreaker",
        "Combat Physician",
        "Diamond's Victory",
        -- 03/22 New/Verified
        "Armor of the Seducer",
        "False God's Devotion",
        "Leviathan",
        "Hunding's Rage",
        "Briarheart",
        "Night Mother's Gaze",
        "Tzogvin's Warband",
        "Spell Power Cure",
        "Hollowfang Thirst",
        "Ebon Armory",
        "Battalion Defender",
        "Fortified Brass",
        "Torug's Pact",
        "Claw of Yolnahkriin",
        "Night's Silence",
        "Necropotence",
        "Spinner's Garments",
        "Brands of Imperium",
        "Ancient Dragonguard",
    }
    local beginner_sets = {
        "Agility",
        "Willpower",
    }
    local dottzgaming_pve_sets = {
        "Berserking Warrior",
        "Saxhleel Champion",
        "Crimson Oath's Rive",
        "Magma Incarnate",
        "Frostbite",
    }
    local dottzgaming_pvp_sets = {
        "Eternal Vigor",
        "Daedric Trickery",
        "Heartland Conqueror",
        "Stygian",
        "War Maiden",
        "Black Rose",
    }
    local alcasthq_pve_sets = {
        -- 03/22 Verified
        "Mother's Sorrow",
        "Law of Julianos",
        "Magnus' Gift",
        -- 03/22 New
        "Kinra’s Wrath",
    }
    local alcasthq_pvp_sets = {
        "Bright-Throat's Boast",
    }
    local monster_sets = {
        "Balorgh",
        "Bloodspawn",
        "Chokethorn",
        "Domihaus",
        "Engine Guardian",
        "Grothdarr",
        "Grundwulf",
        "Ilambris",
        "Infernal Guardian",
        "Kra'gh",
        "Lady Thorn",
        "Maarselok",
        "Mighty Chudan",
        "Molag Kena",
        "Mother Ciannait",
        "Nerien'eth",
        "Nightflame",
        "Pirate Skeleton",
        "Scourge Harvester",
        "Selene",
        "Sellistrix",
        "Shadowrend",
        "Slimecraw",
        "Spawn of Mephala",
        "Stone Husk",
        "Stonekeeper",
        "Symphony of Blades",
        "The Troll King",
        "Thurvokun",
        "Tremorscale",
        "Valkyn Skoria",
        "Velidreth",
        "Vykosa",
        "Zaan",
        -- 03/22 New/Verified
        "Swarm Mother",
        "Earthgore",
        "Kjalnar's Nightmare",
        "Stormfist",
        "Sentinel of Rkugamz",
        "Lord Warden",
        "Maw of the Infernal",
        "Iceheart",
    }
    local arena_sets = {
        "Archer's Mind",
        "Caustic Arrow",
        "Cruel Flurry",
        "Elemental Succession",
        "Executioner's Blade",
        "Footman's Fortune",
        "Force Overflow",
        "Frenzied Momentum",
        "Gallant Charge",
        "Glorious Defender",
        "Healer's Habit",
        "Hunt Leader",
        "Mender's Ward",
        "Merciless Charge",
        "Para Bellum",
        "Perfect Gallant Charge",
        "Perfect Mender's Ward",
        "Perfect Radial Uppercut",
        "Perfect Virulent Shot",
        "Perfect Wild Impulse",
        "Perfected Caustic Arrow",
        "Perfected Cruel Flurry",
        "Perfected Executioner's Blade",
        "Perfected Force Overflow",
        "Perfected Frenzied Momentum",
        "Perfected Merciless Charge",
        "Perfected Precise Regeneration",
        "Perfected Puncturing Remedy",
        "Perfected Rampaging Slash",
        "Perfected Stinging Slashes",
        "Perfected Void Bash",
        "Perfected Wrath of Elements",
        "Permafrost",
        "Precise Regeneration",
        "Puncturing Remedy",
        "Radial Uppercut",
        "Rampaging Slash",
        "Robes of Destruction Mastery",
        "Stinging Slashes",
        "Virulent Shot",
        "Void Bash",
        "Wild Impulse",
        "Winterborn",
        "Wrath of Elements",
        "Destructive Impact",
        "Perfected Destructive Impact",
        -- 03/22 New/Verified
        "Perfected Bahsei's Mania",
        "Perfected Arms of Relequen",
        "Thunderous Volley",
        "Perfected Thunderous Volley",
        "Crushing Wall",
        "Perfected Crushing Wall",
        "Point-Blank Snipe",
        "Perfected Point-Blank Snipe",
        "Grand Rejuvenation",
        "Perfected Grand Rejuvenation",
        "Spectral Cloak",
        "Perfect Spectral Cloak",
        "Titanic Cleave",
        "Perfected Titanic Cleave",
    }
    local sharlikran_sets = {
        "Mad Tinkerer",
        "Unfathomable Darkness",
        "Flame Blossom",
        "Poisonous Serpent",
        "Sheer Venom",
        "Viper's Sting",
    }
    local speed_sets = {
        "Marauder's Haste",
        "Skooma Smuggler",
    }
    if is_in(set_name, new_cp_sets) then return true end
    if is_in(set_name, meta_sets) then return true end
    if is_in(set_name, beginner_sets) then return true end
    if is_in(set_name, dottzgaming_pve_sets) then return true end
    if is_in(set_name, dottzgaming_pvp_sets) then return true end
    if is_in(set_name, alcasthq_pve_sets) then return true end
    if is_in(set_name, alcasthq_pvp_sets) then return true end
    if is_in(set_name, monster_sets) then return true end
    if is_in(set_name, arena_sets) then return true end
    if is_in(set_name, sharlikran_sets) then return true end
    if is_in(set_name, speed_sets) then return true end
    return false
end

local function create_log(log_type, log_content)
    if logger and SDLV then
        if log_type == "Debug" then
            logger:Debug(log_content)
        end
        if log_type == "Verbose" then
            logger:Verbose(log_content)
        end
    else
        d(log_content)
    end
end

local function emit_message(log_type, text)
    if (text == "") then
        text = "[Empty String]"
    end
    create_log(log_type, text)
end

local function emit_table(log_type, t, indent, table_history)
    indent = indent or "."
    table_history = table_history or {}

    for k, v in pairs(t) do
        local vType = type(v)

        emit_message(log_type, indent .. "(" .. vType .. "): " .. tostring(k) .. " = " .. tostring(v))

        if (vType == "table") then
            if (table_history[v]) then
                emit_message(log_type, indent .. "Avoiding cycle on table...")
            else
                table_history[v] = true
                emit_table(log_type, v, indent .. "  ", table_history)
            end
        end
    end
end

function BuildMarker.dm(log_type, ...)
    if not show_log then return end
    for i = 1, select("#", ...) do
        local value = select(i, ...)
        if (type(value) == "table") then
            emit_table(log_type, value)
        else
            emit_message(log_type, tostring(value))
        end
    end
end

function BuildMarker:is_marked(bagId, slotIndex)
    local isMeta = false
    local item_link = GetItemLink(bagId, slotIndex)
    local hasSet, setName, _, _, _, setId = GetItemLinkSetInfo(item_link)
    local item_trait = GetItemLinkTraitType(item_link)
    if hasSet then
        --BuildMarker.dm("Debug", item_trait)
        --BuildMarker.dm("Debug", setName)
    end
    if (hasSet and is_meta_set(setName, setId)) then isMeta = true end
    return isMeta
end

function BuildMarker:ToggleMarker(rowControl, slot)
    local markerControl = rowControl:GetNamedChild(BuildMarker.name)
    local isMeta = BuildMarker:is_marked(slot.bagId, slot.slotIndex)

    if (not markerControl) then
        if not isMeta then return end
        -- Create and initialize the marker control
        --BuildMarker.dm("Debug", "Meta Set")
        --BuildMarker.dm("Debug", rowControl:GetName() .. BuildMarker.name)
        markerControl = WINDOW_MANAGER:CreateControl(rowControl:GetName() .. BuildMarker.name, rowControl, CT_TEXTURE)
        -- EsoUI/Art/Inventory/newItem_icon.dds
        markerControl:SetTexture("/esoui/art/inventory/newitem_icon.dds")
        markerControl:SetColor(0.9, 0.3, 0.2, 1)
        markerControl:SetDimensions(34, 34)
        markerControl:SetAnchor(LEFT, rowControl, LEFT)
        markerControl:SetDrawTier(DT_HIGH)
    end

    markerControl:SetHidden(not isMeta)
end

local function check_inventory()
    --BuildMarker.dm("Debug", "check_inventory")
    for _, v in pairs(PLAYER_INVENTORY.inventories) do
        local listView = v.listView
        if (listView and listView.dataTypes and listView.dataTypes[1]) then
            local hookedFunctions = listView.dataTypes[1].setupCallback

            listView.dataTypes[1].setupCallback = function(rowControl, slot)
                hookedFunctions(rowControl, slot)
                BuildMarker:ToggleMarker(rowControl, slot)
            end
        end
    end
    local backpacks = {
        ZO_SmithingTopLevelDeconstructionPanelInventoryBackpack,
        ZO_SmithingTopLevelImprovementPanelInventoryBackpack,
        ZO_RetraitStation_KeyboardTopLevelRetraitPanelInventoryBackpack,
    }
    for i = 1, #backpacks do
      local oldCallback = backpacks[i].dataTypes[1].setupCallback

      backpacks[i].dataTypes[1].setupCallback = function( rowControl, slot )
        oldCallback(rowControl, slot)
        BuildMarker:ToggleMarker(rowControl, slot)
      end
    end
end

local function OnAddOnLoaded(eventCode, addonName)
    if (addonName ~= BuildMarker.name) then return end

    check_inventory()

    EVENT_MANAGER:UnregisterForEvent(BuildMarker.name, EVENT_ADD_ON_LOADED)
end
EVENT_MANAGER:RegisterForEvent(BuildMarker.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
