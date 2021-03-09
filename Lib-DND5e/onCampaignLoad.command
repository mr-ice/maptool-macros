<!-- Get ye ole Campaign Preferences rockin -->
[h, macro ("dnd5e_Preferences_createCampaignPrefToken@this"): ""]
<!-- Assert Campaign Version -->
[h: REQUIRED_CAMPAIGN_PROP_VERSION = "0.15"]
[h, macro ("dnd5e_Util_assertCampaignPropertiesVersion@this"): json.append ("", REQUIRED_CAMPAIGN_PROP_VERSION)]
<!-- Assert Campaign Preferences token exists -->
<!-- There really is no version requirement, this just simply asserts the campaign preferences -->
<!-- token actually exists. Unfortunately, when its missing we only get an NPE with no particular -->
<!-- details of the problem. But its better than a kick in the nuts -->
[h, macro ("dnd5e_Util_assertLibVersion@this"): json.append ("", 
		0.0, -1, "Lib:CampaignPreferences")]
[h, macro ("dnd5e_Util_displayReleaseNotes@this"): json.append ("", token.name)]
[h, macro ("dnd5e_Macro_UDF_getRegistry@this"): ""]
[h: udfRegistry = macro.return]
[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "dnd5e_") > -1), code: {
		[h: log.debug ("Registering " + macroName)]
		[h: registered = json.get (udfRegistry, macroName)]
		[h: ignoreOutput = 0]
		[h: newScope = 1]
		[h, if (registered != ""): varsFromStrProp (registered); ""]
		[h: defineFunction (macroName, macroName + "@this", ignoreOutput, newScope)]
	}]
}]

[h, if (!isGM ()), code: {
	[landingMapName = dnd5e_Preferences_getPreference("landingMapName")]
	[mapNames = getAllMapNames ("json")]
	[if (json.contains (mapNames, landingMapName)): setCurrentMap (landingMapName); ""]
}; {}]
[h: log.debug (json.indent (getInfo ("client"), 3))]