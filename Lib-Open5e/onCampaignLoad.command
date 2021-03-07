<!-- sigh, instead of explicitly defining each one, just inspect the relevant groups and iterate them -->
[h: REQUIRED_DND_LIB_VERSION = 0.15]
<!-- No calling lib functions during onCampaignLoad -->
[h, macro ("dnd5e_Util_assertLibVersion@Lib:DnD5e"): json.append ("", REQUIRED_DND_LIB_VERSION, REQUIRED_DND_LIB_VERSION)]
[h, macro ("dnd5e_Util_displayReleaseNotes@Lib:DnD5e"): json.append ("", token.name)]

[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "o5e_") > -1), code: {
		[h: log.debug ("Registering " + macroName)]
		[h, if (macroName == "o5e_Constants"): newScope = 0; newScope = 1]
		[h: defineFunction (macroName, macroName + "@this", 0, newScope)]
	}]
}]
[h: o5e_Constants()]
[h: client = getInfo ("client")]
[h: libs = json.get (client, "library tokens")]
[h: extDb = json.get (libs, LIB_MONSTER_SUPPL)]
[h, if (extDb == ""): useExtDB = 0; useExtDB = 1]
[h: setLibProperty (PROP_USE_EXT_DB, useExtDB)]
[h:log.info ("Lib:Open5e loaded")]
