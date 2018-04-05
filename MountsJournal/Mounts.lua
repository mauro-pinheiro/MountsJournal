local mounts = CreateFrame("Frame", "MountsJournal")


mounts:SetScript("OnEvent", function(self, event, ...)
	if mounts[event] then
		mounts[event](self, ...)
	end
end)
mounts:RegisterEvent("ADDON_LOADED")


function mounts:ADDON_LOADED(addon)
	if addon == "MountsJournal" then
		self:UnregisterEvent("ADDON_LOADED")

		MountsJournalDB = MountsJournalDB or {}
		MountsJournalDB.fly = MountsJournalDB.fly or {}
		MountsJournalDB.ground = MountsJournalDB.ground or {}
		MountsJournalDB.swimming = MountsJournalDB.swimming or {}

		mounts.fly = MountsJournalDB.fly
		mounts.ground = MountsJournalDB.ground
		mounts.swimming = MountsJournalDB.swimming
		mounts.swimmingVashjir = {
			373, -- Вайш'ирский морской конек
		}

		mounts.continensGround = {
			1463, -- Внешняя область Хельхейма
			1514, -- Скитающийся остров
		}

		mounts:init()
	end
end


function mounts:inTable(table, item)
	for key, value in pairs(table) do
		if value == item then
			return key
		end
	end
	return false
end


function mounts:summon(ids)
	local usableIDs = {}
	for index, mountID in pairs(ids) do
		if select(5, C_MountJournal.GetMountInfoByID(mountID)) then
			tinsert(usableIDs, mountID)
		end
	end
	if #usableIDs ~= 0 then
		C_MountJournal.SummonByID(usableIDs[random(#usableIDs)])
		return true
	else
		return false
	end
end


function mounts:getSpellKnown()
	local continent = select(8, GetInstanceInfo())
	if mounts:inTable(mounts.continensGround, continent) then
		return false
	end

	if IsSpellKnown(34090) --Верховая езда (умелец)
	or IsSpellKnown(34091) --Верховая езда (искусник)
	or IsSpellKnown(90265) --Мастер верховой езды
	then
		return true
	else
		return false
	end
end


function mounts:init()
	SLASH_MOUNTSJOURNAL1 = "/mount"
	SlashCmdList["MOUNTSJOURNAL"] = function()
		if IsMounted() then
			Dismount()
		else
			if IsSwimming() and not IsAltKeyDown() then
				if not mounts:summon(mounts.swimmingVashjir) and not mounts:summon(mounts.swimming) then
					C_MountJournal.SummonByID(0)
				end
			elseif IsFlyableArea() and (IsSwimming() or not IsAltKeyDown()) and mounts:getSpellKnown() then
				if not mounts:summon(mounts.fly) then C_MountJournal.SummonByID(0) end
			else
				if not mounts:summon(mounts.ground) then C_MountJournal.SummonByID(0) end
			end
		end
	end
end