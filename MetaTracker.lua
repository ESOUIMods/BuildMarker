MetaTracker = {}
MetaTracker.name = "MetaTracker",
LSET = LibSets

function MetaTracker.ToggleMarker( rowControl, slot )
	local isJunk = IsItemJunk(slot.bagId, slot.slotIndex)
	local markerControl = rowControl:GetNamedChild(MetaTracker.name)

	if (not markerControl) then
		-- Be lazy; do nothing if the item is not junk and no marker had been created
		if (not isJunk) then return end

		-- Create and initialize the marker control
		markerControl = WINDOW_MANAGER:CreateControl(rowControl:GetName() .. MetaTracker.name, rowControl, CT_TEXTURE)
		markerControl:SetTexture("/esoui/art/inventory/inventory_tabicon_junk_up.dds")
		markerControl:SetColor(0.9, 0.3, 0.2, 1)
		markerControl:SetDimensions(34, 34)
		markerControl:SetAnchor(LEFT, rowControl, LEFT)
		markerControl:SetDrawTier(DT_HIGH)
	end

	markerControl:SetHidden(not isJunk)
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
