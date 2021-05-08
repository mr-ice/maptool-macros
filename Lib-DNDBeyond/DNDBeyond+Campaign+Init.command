[h: REQUIRED_DND_LIB_VERSION = 0.15]
[h: BASIC_TOON_VERSION = 0.16]
<!-- No calling lib functions during onCampaignLoad -->
[h, macro ("dnd5e_Util_assertLibVersion@Lib:DnD5e"): json.append ("", REQUIRED_DND_LIB_VERSION, REQUIRED_DND_LIB_VERSION)]
[h, macro ("dnd5e_Util_displayReleaseNotes@Lib:DnD5e"): json.append ("", token.name)]
[h: setLibProperty ("dndb.basicToonVersion", BASIC_TOON_VERSION)]

<!-- sigh, instead of explicitly defining each one, just inspect the relevant groups and iterate them -->
[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "dndb_") > -1), code: {
		[h: log.debug ("Registering " + macroName)]
		[h, if (macroName == "dndb_Constants"):
			defineFunction (macroName, macroName + "@this", 0, 0);
			defineFunction (macroName, macroName + "@this")]
	}]
}]
