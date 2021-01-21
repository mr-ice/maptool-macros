<!-- Assert Campaign Version -->
[h: REQUIRED_CAMPAIGN_PROP_VERSION = "0.15"]
[h, macro ("dnd5e_Util_assertCampaignPropertiesVersion@Lib:DnD5e"): json.append ("", REQUIRED_CAMPAIGN_PROP_VERSION)]
<!-- sigh, instead of explicitly defining each one, just inspect the relevant groups and iterate them -->
[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "dnd5e_") > -1), code: {
		[h: log.debug ("Registering " + macroName)]
		[h: defineFunction (macroName, macroName + "@this")]
	}]
}]

[h, if (!isGM ()), code: {
	[landingMapName = dnd5e_Preferences_getPreference("landingMapName")]
	[mapNames = getAllMapNames ("json")]
	[if (json.contains (mapNames, landingMapName)): setCurrentMap (landingMapName); ""]
}; {}]
[h: log.debug (json.indent (getInfo ("client"), 3))]