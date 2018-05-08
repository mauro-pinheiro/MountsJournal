local mounts = MountsJournal
local journal = CreateFrame("Frame", "MountsJounralFrames")


journal.colors = {
	function() return 0.2, 0.1843137254901961, 0.01568627450980392, 1 end,
	-- function() return 0.8941176470588236, 0.7176470588235294, 0.11372549019607843, 1 end,
	function() return 0.6823529411764706, 0.6431372549019608, 0.20392156862745098, 1 end,
}


journal:SetScript("OnEvent", function(self, event, ...)
	if journal[event] then
		journal[event](self, ...)
	end
end)
journal:RegisterEvent("ADDON_LOADED")


function journal:ADDON_LOADED(addonName)
	if addonName == "Blizzard_Collections" or addonName == "MountsJournal" and IsAddOnLoaded("Blizzard_Collections") then
		self:UnregisterEvent("ADDON_LOADED")
		self:Blizzard_Collections()
	end
end


function journal:Blizzard_Collections()
	MountJournal:HookScript("OnShow", journal.configureJournal)
	MountJournalListScrollFrame:HookScript("OnUpdate", journal.configureJournal)

	journal.buttons = {MountJournalListScrollFrameScrollChild:GetChildren()}

	local function CreateButton(name, parent, pointX, pointY, bgTex, OnClick)
		local btnFrame = CreateFrame("button", nil, parent)
		btnFrame:SetNormalTexture(bgTex)
		local btnTex = btnFrame:CreateTexture(nil, "BACKGROUND")
		btnFrame.background = btnTex
		btnTex:SetAllPoints()
		btnFrame:SetPoint("TOPRIGHT", pointX, pointY)
		btnFrame:SetSize(24, 12)
		btnFrame:SetScript("OnClick", OnClick)
		parent[name] = btnFrame
	end

	local texPath = "Interface\\AddOns\\MountsJournal\\textures\\"
	for _,child in pairs(journal.buttons) do
		child:SetWidth(child:GetWidth() - 25)
		child.name:SetWidth(child.name:GetWidth() - 18)

		CreateButton("fly", child, 25, -3, texPath.."fly.blp", function(self)
			journal:mountToggle(mounts.list.fly, self, self.mountID)
		end)
		CreateButton("ground", child, 25, -17, texPath.."ground.blp", function(self)
			journal:mountToggle(mounts.list.ground, self, self.mountID)
		end)
		CreateButton("swimming", child, 25, -31, texPath.."swimming.blp", function(self)
			journal:mountToggle(mounts.list.swimming, self, self.mountID)
		end)
	end
end


function journal:configureJournal()
	local function setColor(btn, mountsTbl)
		if mounts:inTable(mountsTbl, btn.mountID) then
			btn.background:SetColorTexture(journal.colors[2]())
		else
			btn.background:SetColorTexture(journal.colors[1]())
		end
	end

	for _,btn in pairs(journal.buttons) do
		if btn.index then
			if not btn.fly:IsShown() then
				btn.fly:Show()
				btn.ground:Show()
				btn.swimming:Show()
			end
			btn.fly.mountID = select(12, C_MountJournal.GetDisplayedMountInfo(btn.index))
			btn.ground.mountID = btn.fly.mountID
			btn.swimming.mountID = btn.fly.mountID
			setColor(btn.fly, mounts.list.fly)
			setColor(btn.ground, mounts.list.ground)
			setColor(btn.swimming, mounts.list.swimming)
		else
			if btn.fly:IsShown() then
				btn.fly:Hide()
				btn.ground:Hide()
				btn.swimming:Hide()
			end
		end
	end
end


function journal:mountToggle(tbl, button, mountID)
	local pos = mounts:inTable(tbl, mountID)
	if pos then
		tremove(tbl, pos)
		button.background:SetColorTexture(journal.colors[1]())
	else
		tinsert(tbl, mountID)
		button.background:SetColorTexture(journal.colors[2]())
	end
end