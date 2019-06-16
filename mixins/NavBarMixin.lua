local mapValidTypes = {
	[Enum.UIMapType.World] = true,
	[Enum.UIMapType.Continent] = true,
	[Enum.UIMapType.Zone] = true,
}
local function isMapValidForNavBarDropDown(mapInfo)
	if mapValidTypes[mapInfo.mapType] then
		local children = C_Map.GetMapChildrenInfo(mapInfo.parentMapID)
		return type(children) == "table" and #children > 1
	end
end


MJNavBarMixin = CreateFromMixins(MountsJournalEventsMixin)


function MJNavBarMixin:onLoad()
	self:init()
	self.defMapID = MountsJournal.defMountsListID
	self.journal = MountsJournalFrame
	local homeData = {
		name = WORLD,
		OnClick = function() self:setDefMap() end,
	}
	NavBar_Initialize(self, "MJNavButtonTemplate", homeData, self.home, self.overflow)
	self:setDefMap()
end


function MJNavBarMixin:refresh()
	local hierarchy = {}
	local mapInfo = C_Map.GetMapInfo(self.mapID)
	while mapInfo and mapInfo.mapID ~= self.defMapID do
		local btnData = {
			name = mapInfo.name,
			id = mapInfo.mapID,
			OnClick = function(self) self:GetParent():setMapID(self.data.id) end,
		}
		if isMapValidForNavBarDropDown(mapInfo) then
			btnData.listFunc = self.getDropDownList
		end
		tinsert(hierarchy, 1, btnData)
		mapInfo = C_Map.GetMapInfo(mapInfo.parentMapID)
	end

	NavBar_Reset(self)
	for _,btnData in ipairs(hierarchy) do
		NavBar_AddButton(self, btnData)
	end
end


function MJNavBarMixin:getDropDownList()
	local list = {}
	local mapInfo = C_Map.GetMapInfo(self.data.id)
	if mapInfo then
		local children = C_Map.GetMapChildrenInfo(mapInfo.parentMapID)
		if children then
			for i, childInfo in ipairs(children) do
				if isMapValidForNavBarDropDown(childInfo) then
					local data = {
						text = childInfo.name,
						id = childInfo.mapID,
						func = function(btn, mapID) self:GetParent():setMapID(mapID) end,
					}
					tinsert(list, data)
				end
			end
			sort(list, function(a, b) return a.text < b.text end)
		end
	end
	return list
end


function MJNavBarMixin:setMapID(mapID)
	if mapID == self.mapID then return end
	self.mapID = mapID
	self:refresh()
	self:event("MAP_CHANGE")
end


function MJNavBarMixin:setDefMap()
	self:setMapID(self.defMapID)
end


function MJNavBarMixin:setCurrentMap()
	self:setMapID(MapUtil.GetDisplayableMapForPlayer())
end