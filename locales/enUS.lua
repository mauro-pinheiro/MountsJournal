local _, L = ...

L["author"] = "Author"
L["%s Configuration"] = "%s Configuration"
L["ConfigPanelTitle"] = "Global settings"
L["Class settings"] = "Class settings"
L["Modifier"] = "Modifier"
L["SecondMountTooltipTitle"] = "If the modifier is hold or “%s 2” is used:"
L["SecondMountTooltipDescription"] = "\nIf you are in water then will be summoned non-waterfowl mount.\n\nIf you are on land and you can fly then will be summoned ground mount."
L["ZoneSettingsTooltip"] = "Zone settings features"
L["ZoneSettingsTooltipDescription"] = "\nCreating a list of mounts for the zone.\n\nConfiguring zone flags.\n\nSetting up relations to use one list of mounts in different zones."
L["Handle a jump in water"] = "Handle a jump in water"
L["WaterJumpDescription"] = "After you jump in water will be summoned non underwater mount."
L["UseHerbMounts"] = "Use Mount for Herbalism"
L["UseHerbMountsDescription"] = "If Herbalism is learned, then the \"Sky Golem\" is used, if available."
L["UseHerbMountsOnZones"] = "Only in Herb Gathering Zones"
L["Herb Gathering"] = "Herb Gathering"
L["HerbGatheringFlagDescription"] = "Used to configure use of Mount to Herbalism."
L["UseMagicBroom"] = "Use %s"
L["UseMagicBroomTitle"] = "Use Magic Broom"
L["UseMagicBroomDescription"] = "When \"Hallow's End\" event is active, if you have a \"Magic Broom\", it is used."
L["CreateMacro"] = "Create Macro"
L["CreateMacroTooltip"] = "The created macro is used to summon the selected mounts."
L["or key bind"] = "or key bind"
L["Collected:"] = "Collected"
L["Settings"] = "Settings"
L["Shown:"] = "Shown:"
L["hidden for character"] = "Hidden For Character"
L["types"] = "Types"
L["selected"] = "Selected"
L["MOUNT_TYPE_1"] = "Flying"
L["MOUNT_TYPE_2"] = "Ground"
L["MOUNT_TYPE_3"] = "Underwater"
L["factions"] = "Factions"
L["MOUNT_FACTION_1"] = "Horde"
L["MOUNT_FACTION_2"] = "Alliance"
L["MOUNT_FACTION_3"] = "Both"
L["PET_1"] = "With Random Favorite Pet"
L["PET_2"] = "With Random Pet"
L["PET_3"] = "With Pet"
L["PET_4"] = "Without Pet"
L["expansions"] = "Expansions"
L["sorting"] = "Sorting"
L["Reverse Sort"] = "Reverse Sort"
L["Favorites First"] = "Favorites First"
L["Map / Model"] = "Map / Model"
L["Dungeons and Raids"] = "Dungeons and Raids"
L["Current Location"] = "Current Location"
L["Ground Mounts Only"] = "Ground Mounts Only"
L["Water Walking"] = "Water Walking"
L["WaterWalkFlagDescription"] = "Used to configure some classes."
L["ListMountsFromZone"] = "Use list of mounts from zone"
L["No relation"] = "No relation"
L["Zones with list"] = "Zones with list"
L["Zones with relation"] = "Zones with relation"
L["Zones with flags"] = "Zones with flags"
L["CHARACTER_CLASS_DESCRIPTION"] = "(character settings override class settings)"
L["HELP_MACRO_MOVE_FALL"] = "This macro will be run, if you are indoors or are moving, and you do not have a magic broom or it is turned off."
L["HELP_MACRO_COMBAT"] = "This macro will be run, if you are in combat."
L["DEATHKNIGHT_USEPATHOFFROST"] = "Use the %s when summoning ground mount"
L["DEATHKNIGHT_USEONLYINWATERWALKLOCATION"] = "Use only in water walk zones"
L["SHAMAN_USEWATERWALKING"] = "Use the %s when summoning ground mount"
L["SHAMAN_USEONLYINWATERWALKLOCATION"] = "Use only in water walk zones"
L["DRUID_USELASTDRUIDFORM"] = "Return last form when dismounting"
L["DRUID_USEDRUIDFORMSPECIALIZATION"] = "Return a specialization form"
L["DRUID_USEMACROALWAYS"] = "Use this macros instead of mounts"
L["Summonable Battle Pet"] = "Summonable Battle Pet"
L["Summon Random Battle Pet"] = "Summon Random Battle Pet"
L["No Battle Pet"] = "No Battle Pet"
L["NoPetInRaid"] = "Do not summon battle pet in raid group"
L["NoPetInGroup"] = "Do not summon battle pet in group"
L["DisableAutoScroll"] = "Disable auto-scrolling in the mount menu"
-- ANIMATIONS
L["Default"] = "Default"
L["Mount special"] = "Mount special"
L["Walk"] = "Walk"
L["Walk backwards"] = "Walk backwards"
L["Run"] = "Run"
L["Swim idle"] = "Swim idle"
L["Swim"] = "Swim"
L["Swim backwards"] = "Swim backwards"
L["Fly stand"] = "Fly stand"
L["Fly"] = "Fly"
L["Fly backwards"] = "Fly backwards"
L["Loop"] = "Loop"
L["Are you sure you want to delete animation %s?"] = "Are you sure you want to delete animation \"%s\"?"
-- PROFILES
L["Profiles"] = "Profiles"
L["New profile"] = "New profile"
L["Create"] = "Create"
L["Copy current"] = "Copy current"
L["A profile with the same name exists."] = "A profile with the same name exists."
L["By Specialization"] = "By Specialization"
L["Profile settings"] = "Profile settings"
L["Pet binding from default profile"] = "Pet binding from default profile"
L["Zones settings from default profile"] = "Zones settings from default profile"
L["Select all mounts by type in selected zone"] = "Select all mounts by type in selected zone"
L["Unselect all mounts in selected zone"] = "Unselect all mounts in selected zone"
L["Are you sure you want to delete profile %s?"] = "Are you sure you want to delete profile \"%s\"?"
L["Are you sure you want %s?"] = "Are you sure you want \"%s\"?"
-- TAGS
L["tags"] = "Tags"
L["No tag"] = "No Tag"
L["With all tags"] = "With All Tags"
L["Add tag"] = "Add Tag"
L["Tag already exists."] = "Tag already exists."
L["Are you sure you want to delete tag %s?"] = "Are you sure you want to delete tag \"%s\"?"

setmetatable(L, {__index = function(self, key)
	self[key] = key or ""
	return key
end})