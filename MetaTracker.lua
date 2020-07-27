MetaTracker = {}
MetaTracker.name = "MetaTracker"
LSET = LibSets

function MetaTracker.ToggleMarker( rowControl, slot )
	local marker_control = Zos_Function()
	local set_control = LSET:Function()

	if set_control(set_name, set_trait) then
        d("the item in a meta set item mark it")
	else
        -- could be ore, wood, event item, quest item
        d("the item not a meta set item")
        return
    end

	if marker_control then
		-- Create and initialize the marker control
		markerControl = WINDOW_MANAGER:CreateControl(rowControl:GetName() .. MetaTracker.name, rowControl, CT_TEXTURE)
		markerControl:SetTexture("/esoui/art/inventory/inventory_tabicon_junk_up.dds")
		markerControl:SetColor(0.9, 0.3, 0.2, 1)
		markerControl:SetDimensions(34, 34)
		markerControl:SetAnchor(LEFT, rowControl, LEFT)
		markerControl:SetDrawTier(DT_HIGH)
	end

end

local function OnAddOnLoaded( eventCode, addonName )
	if (addonName ~= MetaTracker.name) then return end

	EVENT_MANAGER:UnregisterForEvent(MetaTracker.name, EVENT_ADD_ON_LOADED)

	local backpacks = {
		ZO_SmithingTopLevelDeconstructionPanelInventoryBackpack,
		ZO_EnchantingTopLevelInventoryBackpack,
	}

	for i = 1, #backpacks do
		local oldCallback = backpacks[i].dataTypes[1].setupCallback

		backpacks[i].dataTypes[1].setupCallback = function( rowControl, slot )
			oldCallback(rowControl, slot)
			MetaTracker.ToggleMarker(rowControl, slot)
		end
	end
end
EVENT_MANAGER:RegisterForEvent(MetaTracker.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
