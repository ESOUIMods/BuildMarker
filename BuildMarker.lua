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
    local meta_sets = {
        -- Medium Armor
        "Shield Breaker",
        "Defiler",
        "Tooth of Lokkestiiz",
        "Arms of Relequen",
        -- "New Moon Acolyte", << also Magicka Set?
        "Deadly Strike",
        "Tzogvin's Warband",
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
        "Leviathan",
        "Yandir's Might",
        "Briarheart",
        "Shadow of the Red Mountain",
        "Hunding's Rage",
        "Essence Thief",
        "Spriggan's Thorns",
        "Azureblight Reaper",
        "Heem-Jas' Retribution",
        "Scavenging Demise",
        "Powerful Assault",
        "Draugr Hulk",
        -- Light Armor
        "Robes of Transmutation",
        "Ysgramor's Birthright",
        "Vampire Lord",
        "Hollowfang Thirst",
        "Winter's Respite",
        "Desert Rose",
        "Night Mother's Gaze",
        "Grothdarr",
        "Silks of the Sun",
        "Zaan",
        "False God's Devotion",
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
        "Law of Julianos",
        "Draugrkin's Grip",
        "Z'en's Redress",
        "Way of Martial Knowledge",
        "Necropotence",
        "Spinner's Garments",
        "Moondancer",
        "Overwhelming Surge",
        "Infallible Mage",
        -- Heavy Armor
        "Green Pact",
        "Akaviri Dragonguard",
        "Ebon Armory",
        "Claw of Yolnahkriin",
        "Lord Warden",
        "Fortified Brass",
        "Torug's Pact",
        "Night's Silence",
        "Brands of Imperium",
        "Battalion Defender",
        "Engine Guardian",
        "Plague Doctor",
        "Warrior-Poet",
        "Bahraha's Curse",
        -- Monster Sets
        "Balorgh",
        "Maw of the Infernal",
        "Symphony of Blades",
        "Bloodspawn",
        "Stormfist",
        "Slimecraw",
        "Thurvokun",
        "Kra'gh",
        "Selene",
        "Ilambris",
        "Stonekeeper",
        "Earthgore",
        "Sentinel of Rkugamz",
        "Nightflame",
        "Scourge Harvester",
        "Mighty Chudan",
        "Iceheart",
        -- Maelstrom Arena
        "Thunderous Volley",
        -- Mythic
        "Torc of Tonal Constancy",
        --  Craftable, meaning Light, Heavy, or Medium
        "Stuhn's Favor",
        "Coldharbour's Favorite",
        "Armor of the Seducer",
        "Jorvuld's Guidance",
        "Vestment of Olorime",
        "Grand Rejuvenation",
        "Magnus' Gift",
        "Kagrenac's Hope",
        -- PVP Sets
        "Warrior's Fury",
        "Vengeance Leech",
        "Clever Alchemist",
        "Endurance",
        "Eternal Hunt",
        "Caustic Arrow",
        "Crafty Alfiq",
        "Bright-Throat's Boast",
        "Shacklebreaker",
        "Valkyn Skoria",
        "Spectral Cloak",
        "Blessing of the Potentates",
        "Kjalnar's Nightmare",
        "Destructive Impact",
        "Titanborn Strength",
        "Molag Kena",
        "Velidreth",
        -- Misc
        "Agility",
        "Willpower",
        -- For Fun
        "Mad Tinkerer",
        "Unfathomable Darkness",
        "Flame Blossom",
    }
    if is_in(set_name, meta_sets) then return true end
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

function BuildMarker:get_slot_bagid(rowControl)
end

function BuildMarker:ToggleMarker(rowControl, slot)
    local markerControl = rowControl:GetNamedChild(BuildMarker.name)

    local item_link = GetItemLink(slot.bagId, slot.slotIndex)
    local hasSet, setName, _, _, _, setId = GetItemLinkSetInfo(item_link)
    local item_trait = GetItemLinkTraitType(item_link)
    local isMeta = hasSet and is_meta_set(setName, setId)
    if hasSet then
        BuildMarker.dm("Debug", item_trait)
        BuildMarker.dm("Debug", setName)
    end

    if (not markerControl) then
        if not isMeta then return end
        -- Create and initialize the marker control
        BuildMarker.dm("Debug", "Meta Set")
        BuildMarker.dm("Debug", rowControl:GetName() .. BuildMarker.name)
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
    BuildMarker.dm("Debug", "check_inventory")
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
