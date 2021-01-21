<!-- Assert Campaign Version -->
[h: REQUIRED_CAMPAIGN_PROP_VERSION = "0.15"]
[h, macro ("dnd5e_Util_assertCampaignPropertiesVersion@Lib:DnD5e"): json.append ("", REQUIRED_CAMPAIGN_PROP_VERSION)]
<!-- Assert Campaign Preferences token exists -->
<!-- There really is no version requirement, this just simply asserts the campaign preferences -->
<!-- token actually exists. Unfortunately, when its missing we only get an NPE with no particular -->
<!-- details of the problem. But its better than a kick in the nuts -->
[h, macro ("dnd5e_Util_assertLibVersion@Lib:DnD5e"): json.append ("", 
		0.0, -1, "Lib:CampaignPreferences")]
[h, macro ("dnd5e_Util_displayReleaseNotes@Lib:DnD5e"): json.append ("", token.name)]
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