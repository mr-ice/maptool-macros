<!-- Assert Campaign Version -->
[h: REQUIRED_CAMPAIGN_PROP_VERSION = "0.15"]
[h, macro ("dnd5e_Util_assertCampaignPropertiesVersion@Lib:DnD5e"): 
		json.append ("", REQUIRED_CAMPAIGN_PROP_VERSION)]
[h, macro ("dnd5e_Util_displayReleaseNotes@Lib:DnD5e"): json.append ("", token.name)]
[h, macro ("dnd5e_PartyPanel_UDF_getRegistry@this"): ""]
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
[h: setLibProperty ("dnd5e.pp.defaultConfig", dnd5e_PartyPanel_DefaultConfiguration())]