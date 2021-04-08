local type, pairs, GetShapeshiftFormID, GetShapeshiftForm, GetShapeshiftFormInfo, GetSpecialization, GetItemCount, GetUnitSpeed, IsFalling, InCombatLockdown = type, pairs, GetShapeshiftFormID, GetShapeshiftForm, GetShapeshiftFormInfo, GetSpecialization, GetItemCount, GetUnitSpeed, IsFalling, InCombatLockdown
local macroFrame = CreateFrame("FRAME")


macroFrame:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)
macroFrame:RegisterEvent("PLAYER_LOGIN")


function macroFrame:PLAYER_LOGIN()
	self.mounts = MountsJournal
	self.sFlags = self.mounts.sFlags
	self.macrosConfig = self.mounts.config.macrosConfig
	self.charMacrosConfig = self.mounts.charDB.macrosConfig
	self.class = select(2, UnitClass("player"))

	local magicBroom = Item:CreateFromItemID(37011)
	if magicBroom:IsItemDataCached() then
		self.broomName = magicBroom:GetItemName()
	else
		magicBroom:ContinueOnItemLoad(function()
			self.broomName = magicBroom:GetItemName()
		end)
	end

	local getDefMacro = [[
		return function(self)
			local macro
	]]
	if self.class == "DEATHKNIGHT" then
		getDefMacro = getDefMacro..[[
			if self.classConfig.usePathOfFrost
			and (not self.classConfig.useOnlyInWaterWalkLocation or self.sFlags.waterWalk)
			and not self.sFlags.swimming
			and not self.sFlags.fly then
				macro = self:addLine(macro, "/cast "..self:getSpellName(3714)) -- Path of Frost
			end
		]]
	elseif self.class == "SHAMAN" then
		getDefMacro = getDefMacro..[[
			if self.classConfig.useWaterWalking
			and (not self.classConfig.useOnlyInWaterWalkLocation or self.sFlags.waterWalk)
			and not self.sFlags.swimming
			and not self.sFlags.fly then
				macro = self:addLine(macro, "/cast [@player]"..self:getSpellName(546)) -- Water Walking
			end
		]]
	elseif self.class == "DRUID" then
		getDefMacro = getDefMacro..[[
			local curFormID = GetShapeshiftFormID()
			-- 1:CAT, 3:STAG, 5:BEAR, 36:TREANT
			if curFormID == 1 or curFormID == 3 or curFormID == 5 or curFormID == 36 then
				macro = self:addLine(macro, "/cancelform")
			end
		]]
	end
	getDefMacro = getDefMacro..[[
			if self.magicBroom then
				macro = self:addLine(macro, "/use "..self.broomName) -- MAGIC BROOM
				self.lastUseTime = GetTime()
			else
				macro = self:addLine(macro, "/mount doNotSetFlags")
			end
			return macro
		end
	]]

	local loadedFunc, err = loadstring(getDefMacro)
	if err then
		geterrorhandler()(err)
	else
		local success, func = pcall(loadedFunc)
		if success then
			self.getDefMacro = func
		end
	end

	self:refresh()
	self:getClassMacro(self.class, function() self:refresh() end)
end


function macroFrame:setMacro()
	self.macro = nil
	if self.classConfig.macroEnable then
		self.macro = self.classConfig.macro or self:getClassMacro()
	end
end


function macroFrame:setCombatMacro()
	self.combatMacro = nil
	if self.classConfig.combatMacroEnable then
		self.combatMacro = self.classConfig.combatMacro or self:getClassMacro()
	end
end


function macroFrame:refresh()
	self.classConfig = self.charMacrosConfig.enable and self.charMacrosConfig or self.macrosConfig[self.class]
	self:setMacro()
	self:setCombatMacro()
end


function macroFrame:addLine(text, line)
	if type(text) == "string" and text:len() > 0 then
		return strjoin("\n", text, line)
	else
		return line
	end
end


do
	local spellCache = {}
	function macroFrame:getSpellName(spellID, cb)
		if spellCache[spellID] then
			return spellCache[spellID]
		else
			local name = GetSpellInfo(spellID)
			if C_Spell.IsSpellDataCached(spellID) then
				local subText = GetSpellSubtext(spellID)
				if subText:len() > 0 then
					name = name.."("..subText..")"
				end
				spellCache[spellID] = name
			elseif cb then
				SpellEventListener:AddCallback(spellID, cb)
			end
			return name
		end
	end
end


function macroFrame:getDismountMacro()
	return self:addLine("/leavevehicle [vehicleui]", "/dismount [mounted]")
end


do
	local function getClassDefFunc(spellID)
		return function(self, ...)
			local spellName = self:getSpellName(spellID, ...)
			if spellName then
				return "/cast "..spellName
			end
		end
	end


	local classFunc = {
		PALADIN = getClassDefFunc(190784), -- Devine Steed,
		PRIEST = getClassDefFunc(1706), -- Levitation
		SHAMAN = getClassDefFunc(2645), -- Ghost Wolf
		MAGE = getClassDefFunc(130), -- Slow Fall
		MONK = getClassDefFunc(125883), --Zen Flight
		DRUID = function(self, ...)
			local catForm = self:getSpellName(768, ...)
			local travelForm = self:getSpellName(783, ...)

			if catForm and travelForm then
				return "/cast [indoors,noswimming]"..catForm..";"..travelForm
			end
		end,
	}


	function macroFrame:getClassMacro(class, ...)
		local macro = self:getDismountMacro()

		local classFunc = classFunc[class or self.class]
		if type(classFunc) == "function" then
			local text = classFunc(self, ...)
			if type(text) == "string" and text:len() > 0 then
				macro = self:addLine(macro, text)
			end
		end

		return macro
	end
end


do
	local function getFormSpellID()
		local shapeshiftIndex = GetShapeshiftForm()
		if shapeshiftIndex > 0 then
			local _,_,_, spellID = GetShapeshiftFormInfo(shapeshiftIndex)
			return spellID
		end
	end


	local specializationSpellIDs = {
		24858, -- moonkin
		768, -- cat
		5487, -- bear
	}


	function macroFrame:getMacro()
		self.mounts:setFlags()
		local macro

		-- DRUID LAST FORM
		-- 768 - cat form
		-- 783 - travel form
		-- 24858 - moonkin form
		if self.class == "DRUID" and self.classConfig.useLastDruidForm then
			local spellID = getFormSpellID()

			if self.classConfig.useDruidFormSpecialization then
				self.lastDruidFormSpellID = specializationSpellIDs[GetSpecialization()]
			end

			if self.lastDruidFormSpellID
			and spellID ~= 24858
			and (self.sFlags.isMounted
				  or self.sFlags.inVehicle
				  or spellID == 783
				  or self.sFlags.isIndoors and spellID == 768) then
				macro = self:addLine(self:getDismountMacro(), "/cast "..self:getSpellName(self.lastDruidFormSpellID))
				return macro or ""
			end

			if not self.classConfig.useDruidFormSpecialization then
				if spellID and spellID ~= 783 then
					self.lastDruidFormSpellID = spellID
					self.lastDruidFormTime = GetTime()
				elseif not spellID and GetTime() - (self.lastDruidFormTime or 0) > 1 then
					self.lastDruidFormSpellID = nil
				end
			end
		end

		-- MAGIC BROOM IS USABLE
		self.magicBroom = self.mounts.config.useMagicBroom
								and GetItemCount(37011) > 0
								and self.sFlags.groundSpellKnown
								and not self.sFlags.isIndoors
								and not self.sFlags.herb
								and not self.sFlags.swimming
								and self.broomName

		-- EXIT VEHICLE
		if self.sFlags.inVehicle then
			macro = "/leavevehicle"
		-- DISMOUNT
		elseif self.sFlags.isMounted then
			if not self.lastUseTime or GetTime() - self.lastUseTime > .5 then
				macro = "/dismount"
			end
		-- CLASSMACRO
		elseif self.macro
			and (self.class == "DRUID" and self.classConfig.useMacroAlways
				  or not self.magicBroom and (self.sFlags.isIndoors or GetUnitSpeed("player") > 0 or IsFalling())) then
			macro = self.macro
		-- MOUNT
		else
			macro = self:getDefMacro()
		end

		return macro or ""
	end
end


function macroFrame:getCombatMacro()
	local macro

	if self.combatMacro then
		macro = self.combatMacro
	elseif self.macro and self.class == "DRUID" and self.classConfig.useMacroAlways then
		macro = self.macro
	end

	return macro or "/mount"
end


function MountsJournalUtil.getClassMacro(...)
	return macroFrame:getClassMacro(...)
end


function MountsJournalUtil.refreshMacro()
	macroFrame:refresh()
end


MJMacroMixin = {}


function MJMacroMixin:onEvent(event, ...)
	self[event](self, ...)
end


function MJMacroMixin:onLoad()
	self.mounts = MountsJournal
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
end


function MJMacroMixin:preClick()
	self.mounts.sFlags.forceModifier = self.forceModifier
	if InCombatLockdown() then return end
	self:SetAttribute("macrotext", macroFrame:getMacro())
end


function MJMacroMixin:PLAYER_REGEN_DISABLED()
	self:SetAttribute("macrotext", macroFrame:getCombatMacro())
end