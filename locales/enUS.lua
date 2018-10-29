local _, L = ...

L["%s Configuration"] = "%s Configuration"
L["ConfigPanelTitle %s."] = "This panel can be used to configure %s."
L["Modifier"] = "Modifier"
L["ModifierDescription"] = "If the modifier hold and you are in water then will be summoned non-waterfowl mount. If you are on land and you can fly then will be summoned ground mount."
L["Handle a jump in water"] = "Handle a jump in water"
L["WaterJumpDescription"] = "After you jump in water will be summoned non underwater mount."
L["Water Walking in dungeons"] = "Water Walking in dungeons"
L["Eye of Azchara (Legion)"] = "Eye of Azchara (Legion)"
L["Tol Dagor (BFA)"] = "Tol Dagor (BFA)"
L["Water Walking"] = "Water Walking"
L["WaterWalkingDescription"] = "Instead of the selected land mounts, the \"Water Strider\" is used, if available."
L["Water Walking Always"] = "Water Walker Always"
L["UseHerbMounts"] = "Use Mount for Herbalism"
L["UseHerbMountsDescription"] = "If Herbalism is learned, then the \"Sky Golem\" is used, if available."
L["UseMagicBroom"] = "Use Magic Broom"
L["UseMagicBroomDescription"] = "When \"Hallow's End\" event is active, if you have a \"Magic Broom\", it is used."
L["CreateMacroBtn"] = "Create Macro: \"/mount\""
L["CreateMacro"] = "Create Macro"
L["CreateMacroTooltip"] = "The created macro is used to summon the selected mounts."
L["NeedRecreateMacro"] = "!!!Need to re-create macro!!!"
L["or key bind"] = "or key bind"
L["Collected:"] = "Collected:"
L["Settings"] = "Settings"
L["Character Specific Mount List"] = "Character Specific Mount List"
L["Shown:"] = "Shown:"
L["types"] = "Types"
L["selected"] = "Selected"
L["sources"] = "Sources"
L["MOUNT_TYPE_1"] = "Flying"
L["MOUNT_TYPE_2"] = "Ground"
L["MOUNT_TYPE_3"] = "Underwater"
L["expansions"] = "Expansions"
L["EXPANSION_1"] = "Classic"
L["EXPANSION_2"] = "Burning Crusade"
L["EXPANSION_3"] = "Wrath of the Lich King"
L["EXPANSION_4"] = "Cataclysm"
L["EXPANSION_5"] = "Mists of Pandaria"
L["EXPANSION_6"] = "Warlords of Draenor"
L["EXPANSION_7"] = "Legion"
L["EXPANSION_8"] = "Battle for Azeroth"

setmetatable(L, {__index = function(self, key)
	self[key] = key or ""
	return key
end})