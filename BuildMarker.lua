BuildMarker = {}
BuildMarker.name = "BuildMarker"
LSET = LibSets
if LibDebugLogger then
  local logger = LibDebugLogger.Create(BuildMarker.name)
end
local show_log = false
local SDLV = DebugLogViewer

local function is_empty_or_nil(t)
  if t == nil or t == "" then
    return true
  end
  return type(t) == "table" and ZO_IsTableEmpty(t) or false
end

local function is_in(search_value, search_table)
  if is_empty_or_nil(search_value) then
    return false
  end
  for k, v in pairs(search_table) do
    if search_value == v then
      return true
    end
    if type(search_value) == "string" then
      if string.find(string.lower(v), string.lower(search_value)) then
        return true
      end
    end
  end
  return false
end

local function is_meta_set(set_name, set_id)
  local meta_pve_dps = {
    "Arms of Relequen",
    "Deadly Strike",
    "Crushing Wall",
    "Perfected Crushing Wall",
    "Thunderous Volley",
    "Perfected Thunderous Volley",
    "Whorl of the Depths", -- Strong proc set for trials
    "Ansuul’s Torment", -- Hybrid DPS sustain set
  }
  local meta_pve_healer = {
    "Spell Power Cure",
    "Vestment of Olorime",
    "Jorvuld's Guidance",
    "Symphony of Blades",
    "Powerful Assault",
    "Pillager’s Profit", -- Ultimate generation support set
  }
  local meta_pve_tank = {
    "Saxhleel Champion",
    "Claw of Yolnahkriin",
    "Crimson Oath's Rive",
    "Powerful Assault",
    "Turning Tide", -- Major Vulnerability application
    "Lucent Echoes", -- Applies Major Cowardice (strong debuff)
  }
  local meta_pvp_dps = {
    "Plaguebreak",
    "Vicious Death",
    "Deadly Strike",
    "Clever Alchemist",
    "Rallying Cry",       -- Strong group utility set in PvP
    "Dark Convergence",   -- Pull + burst combo set, still used
    "Wretched Vitality",  -- High sustain for PvP builds
  }
  local meta_pvp_healer = {
    "Rallying Cry",
  }
  local meta_pvp_tanky = {
    "Mark of the Pariah",
    "Daedric Trickery",
    "Impregnable Armor",
  }

  local viable_pve_dps = {
    "New Moon Acolyte",
    "Mechanical Acuity",
    "Burning Spellweave",
    "Overwhelming Surge",
    "Powerful Assault",
    "Vestment of Olorime",
    "Pillar of Nirn", -- Bleed proc, strong fallback if no Relequen
    "Tzogvin’s Warband", -- Crit chance stacking, good trial entry set
    "Medusa", -- Minor Force + Major Prophecy
  }
  local viable_pve_healer = {
    "Symphony of Blades",
    "Jorvuld's Guidance",
    "Robes of Transmutation",
  }
  local viable_pve_tank = {
    "Crimson Oath's Rive",
    "Saxhleel Champion", -- though also often meta, keep here as fallback
    "Arkasis’s Genius", -- Group ultimate battery
    "Ebon Armory", -- Group Max Health
    "Leeching Plate", -- Self-heal sustain tanking
  }
  local viable_pvp_dps = {
    "Vicious Death",
    "Clever Alchemist",
    "Deadly Strike",
  }
  local viable_pvp_healer = {
    "Daedric Trickery",
  }
  local viable_pvp_tanky = {
    "Mark of the Pariah",
    "Impregnable Armor",
  }

  local arena_weapon_items = {
    -- Vateshran Hollows
    "Wrath of Elements", "Perfected Wrath of Elements",
    "Force Overflow", "Perfected Force Overflow",
    "Point-Blank Snipe", "Perfected Point-Blank Snipe",
    "Frenzied Momentum", "Perfected Frenzied Momentum",
    "Executioner's Blade", "Perfected Executioner's Blade",
    "Void Bash", "Perfected Void Bash",

    -- Maelstrom Arena
    "Crushing Wall", "Perfected Crushing Wall",
    "Precise Regeneration", "Perfected Precise Regeneration",
    "Thunderous Volley", "Perfected Thunderous Volley",
    "Merciless Charge", "Perfected Merciless Charge",
    "Cruel Flurry", "Perfected Cruel Flurry",
    "Rampaging Slash", "Perfected Rampaging Slash",

    -- Dragonstar Arena (Master)
    "Caustic Arrow", "Perfected Caustic Arrow",
    "Stinging Slashes", "Perfected Stinging Slashes",
    "Puncturing Remedy", "Perfected Puncturing Remedy",
    "Grand Rejuvenation", "Perfected Grand Rejuvenation",
    "Titanic Cleave", "Perfected Titanic Cleave",
    "Destructive Impact", "Perfected Destructive Impact",

    -- Blackrose Prison
    "Wild Impulse", "Perfected Wild Impulse",
    "Mender's Ward", "Perfected Mender's Ward",
    "Virulent Shot", "Perfect Virulent Shot",
    "Radial Uppercut", "Perfect Radial Uppercut",
    "Spectral Cloak", "Perfect Spectral Cloak",
    "Gallant Charge", "Perfect Gallant Charge",

    -- Asylum Sanctorium
    "Concentrated Force", "Perfected Concentrated Force",
    "Timeless Blessing", "Perfected Timeless Blessing",
    "Piercing Spray", "Perfected Piercing Spray",
    "Disciplined Slash", "Perfected Disciplined Slash",
    "Chaotic Whirlwind", "Perfected Chaotic Whirlwind",
    "Defensive Position", "Perfected Defensive Position",
  }
  -- Infinite Archive (Class Sets) — full set names to protect from accidental deconstruct
  local infinite_archive_class_sets = {
    -- U40 wave
    "Basalt-Blooded Warrior",
    "Gardener of Seasons",
    "Monolith of Storms",
    "Nobility in Decay",
    "Reawakened Hierophant",
    "Soulcleaver",

    -- Later additions (U43+)
    "Spattering Disjunction",
    "Pyrebrand",
    "Corpseburster",
    "Umbral Edge",
    "Beacon of Oblivion",
    "Aetheric Lancer",
    "Aerie's Cry",
  }
  local sharlikran_sets = {
    "Mad Tinkerer",
    "Unfathomable Darkness",
    "Flame Blossom",
    "Poisonous Serpent",
    "Venomous Smite",
    "Sheer Venom",
    "Viper's Sting",
    "Wyrd Tree's Blessing",
    "Deadlands Assassin",
    "Dark Convergence",
    "Defiler",
    "Warrior-Poet",
    "Plague Doctor",
  }
  local meta_speed_sets = {
    "Ring of the Wild Hunt",
  }

  local viable_speed_sets = {
    "Skooma Smuggler",
  }
  local niche_speed_sets = {
    "Adept Rider", -- Permanent Major Expedition + Major Gallop
    "Coward's Gear", -- Major Expedition in combat while not blocking
    "Jailbreaker", -- Minor Expedition (constant)
    "Darkstride", -- Reduces sprint/sneak cost by 50%
    "Fiord's Legacy", -- Reduces sprint cost, increases sprint speed
  }
  local niche_thief_sets = {
    "Night's Silence", -- Removes movement penalty while sneaking
    "Night Mother's Embrace", -- Reduces detection range while sneaking
    "f", -- Major Expedition + Sneak bonuses
    "Darkstride", -- Reduces Sprint and Sneak cost
    "Fiord's Legacy", -- Increases sprint speed, reduces sprint cost
    "Shadow Dancer's Raiment", -- Roll dodge + Sneak synergy
    "Armor of the Trainee", -- Popular for one-bar sneaky utility builds
  }
  local monster_sets = {
    "Anthelmir's Construct",
    "Archdruid Devyric",
    "Balorgh",
    "Baron Thirsk",
    "Baron Zaudrus",
    "Bloodspawn",
    "Chokethorn",
    "Domihaus",
    "Earthgore",
    "Encratis's Behemoth",
    "Engine Guardian",
    "Euphotic Gatekeeper",
    "Glorgoloch the Destroyer",
    "Grothdarr",
    "Grundwulf",
    "Iceheart",
    "Ilambris",
    "Immolator Charr",
    "Infernal Guardian",
    "Kargaeda",
    "Kjalnar's Nightmare",
    "Kra'gh",
    "Lady Malygda",
    "Lady Thorn",
    "Lord Warden",
    "Maarselok",
    "Magma Incarnate",
    "Maw of the Infernal",
    "Mighty Chudan",
    "Molag Kena",
    "Mother Ciannait",
    "Nazaray",
    "Nerien'eth",
    "Nightflame",
    "Nunatak",
    "Orpheon the Tactician",
    "Ozezan the Inferno",
    "Pirate Skeleton",
    "Prior Thierric",
    "Roksa the Warped",
    "Scourge Harvester",
    "Selene",
    "Sellistrix",
    "Sentinel of Rkugamz",
    "Shadowrend",
    "Slimecraw",
    "Spawn of Mephala",
    "Squall of Retribution",
    "Stone Husk",
    "Stonekeeper",
    "Stormfist",
    "Swarm Mother",
    "Symphony of Blades",
    "The Blind",
    "The Troll King",
    "Thurvokun",
    "Tremorscale",
    "Valkyn Skoria",
    "Velidreth",
    "Vykosa",
    "Zaan",
    "Zoal the Ever-Wakeful",
  }

  local niche_proc_fun_sets = {
    "Scavenging Demise", -- Spectral bow poison shot on crit
    "Nerien'eth", -- Summons spinning spectral sword AoE
    "Valkyn Skoria", -- Drops flaming meteor on DoT crit
    "Maarselok", -- Poison breath cone (monster set)
    "Sellistrix", -- AoE earthquake proc
    "Grothdarr", -- Flame damage aura
    "Spawn of Mephala", -- Summons spider poison AoE
    "Stormfist", -- Storm atronach fist ground slam
    "Selene", -- Bear spirit slam
    "Glorgoloch the Destroyer", -- Damaging AoE shockwave
    "Encratis's Behemoth", -- Flame damage & resistance aura
    "Euphotic Gatekeeper", -- Tentacle AoE proc
    "Winterborn",
  }

  local beginner_sets = {
    "Agility",
    "Willpower",
    "Endurance",
  }

  if is_in(set_name, meta_pve_dps) then return true end
  if is_in(set_name, meta_pve_healer) then return true end
  if is_in(set_name, meta_pve_tank) then return true end
  if is_in(set_name, meta_pvp_dps) then return true end
  if is_in(set_name, meta_pvp_healer) then return true end
  if is_in(set_name, meta_pvp_tanky) then return true end

  if is_in(set_name, viable_pve_dps) then return true end
  if is_in(set_name, viable_pve_healer) then return true end
  if is_in(set_name, viable_pve_tank) then return true end
  if is_in(set_name, viable_pvp_dps) then return true end
  if is_in(set_name, viable_pvp_healer) then return true end
  if is_in(set_name, viable_pvp_tanky) then return true end

  if is_in(set_name, arena_weapon_items) then return true end
  if is_in(set_name, infinite_archive_class_sets) then return true end
  if is_in(set_name, sharlikran_sets) then return true end
  if is_in(set_name, meta_speed_sets) then return true end
  if is_in(set_name, viable_speed_sets) then return true end
  if is_in(set_name, niche_speed_sets) then return true end
  if is_in(set_name, niche_thief_sets) then return true end

  if is_in(set_name, beginner_sets) then return true end
  if is_in(set_name, monster_sets) then return true end
  if is_in(set_name, niche_proc_fun_sets) then return true end

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
  if not show_log then
    return
  end
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
  if (hasSet and is_meta_set(setName, setId)) then
    isMeta = true
  end
  return isMeta
end

function BuildMarker:ToggleMarker(rowControl, slot)
  local markerControl = rowControl:GetNamedChild(BuildMarker.name)
  local isMeta = BuildMarker:is_marked(slot.bagId, slot.slotIndex)

  if (not markerControl) then
    if not isMeta then
      return
    end
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
    ZO_UniversalDeconstructionTopLevel_KeyboardPanelInventoryBackpack,
  }
  for i = 1, #backpacks do
    local oldCallback = backpacks[i].dataTypes[1].setupCallback

    backpacks[i].dataTypes[1].setupCallback = function(rowControl, slot)
      oldCallback(rowControl, slot)
      BuildMarker:ToggleMarker(rowControl, slot)
    end
  end
end

local function OnAddOnLoaded(eventCode, addonName)
  if (addonName ~= BuildMarker.name) then
    return
  end

  check_inventory()

  EVENT_MANAGER:UnregisterForEvent(BuildMarker.name, EVENT_ADD_ON_LOADED)
end
EVENT_MANAGER:RegisterForEvent(BuildMarker.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
