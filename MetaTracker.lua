MetaTracker = {}
MetaTracker.name = "MetaTracker"
LSET = LibSets
local logger = LibDebugLogger.Create(MetaTracker.name)
local show_log = true
local SDLV = DebugLogViewer

local function is_in(search_value, search_table)
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
        "Armor of the Trainee",
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
    if(text == "") then
        text = "[Empty String]"
    end
    create_log(log_type, text)
end

local function emit_table(log_type, t, indent, table_history)
    indent          = indent or "."
    table_history    = table_history or {}

    for k, v in pairs(t) do
        local vType = type(v)

        emit_message(log_type, indent.."("..vType.."): "..tostring(k).." = "..tostring(v))

        if(vType == "table") then
            if(table_history[v]) then
                emit_message(log_type, indent.."Avoiding cycle on table...")
            else
                table_history[v] = true
                emit_table(log_type, v, indent.."  ", table_history)
            end
        end
    end
end

function MetaTracker.dm(log_type, ...)
    --if not show_log then return end
    for i = 1, select("#", ...) do
        local value = select(i, ...)
        if(type(value) == "table") then
            emit_table(log_type, value)
        else
            emit_message(log_type, tostring(value))
        end
    end
end

function MetaTracker:ToggleMarker( rowControl, slot )
    local markerControl = rowControl:GetNamedChild(MetaTracker.name)
    
    local item_link = GetItemLink(slot.bagId, slot.slotIndex)
    local hasSet, setName, _, _, _, setId = GetItemLinkSetInfo(item_link)
    if not hasSet then return end

    if (not markerControl) then
        if (not is_meta_set(setName, setId)) then return end
		-- Create and initialize the marker control
        MetaTracker.dm("Debug", "Meta Set")
        MetaTracker.dm("Debug", rowControl:GetName() .. MetaTracker.name)
		markerControl = WINDOW_MANAGER:CreateControl(rowControl:GetName() .. MetaTracker.name, rowControl, CT_TEXTURE)
		markerControl:SetTexture("/esoui/art/inventory/inventory_tabicon_junk_up.dds")
		--markerControl:SetColor(0.9, 0.3, 0.2, 1)
		--markerControl:SetDimensions(34, 34)
		--markerControl:SetAnchor(LEFT, rowControl, LEFT)
		--markerControl:SetDrawTier(DT_HIGH)
	end

	--markerControl:SetHidden(true)
end

local function check_inventory()
    MetaTracker.dm("Debug", "check_inventory")
	for _,v in pairs(PLAYER_INVENTORY.inventories) do
        local listView = v.listView
        if (listView and listView.dataTypes and listView.dataTypes[1]) then
            local hookedFunctions = listView.dataTypes[1].setupCallback

            listView.dataTypes[1].setupCallback =
            function( rowControl, slot )
                hookedFunctions(rowControl, slot)
                MetaTracker:ToggleMarker(rowControl, slot)
            end
        end
	end
end

local function OnAddOnLoaded( eventCode, addonName )
	if (addonName ~= MetaTracker.name) then return end

	check_inventory()

	EVENT_MANAGER:UnregisterForEvent(MetaTracker.name, EVENT_ADD_ON_LOADED)
end
EVENT_MANAGER:RegisterForEvent(MetaTracker.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
