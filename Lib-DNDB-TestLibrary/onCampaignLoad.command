[h: REQUIRED_DNDBEYOND_LIB_VERSION = 0.15]
<!-- No calling lib functions during onCampaignLoad -->
[h, macro ("dnd5e_Util_assertLibVersion@Lib:DnD5e"): json.append ("", 
		REQUIRED_DNDBEYOND_LIB_VERSION, REQUIRED_DNDBEYOND_LIB_VERSION, "Lib:DnDBeyond")]
[h, macro ("dnd5e_Util_displayReleaseNotes@Lib:DnD5e"): json.append ("", token.name)]
<!-- sigh, instead of explicitly defining each one, just inspect the relevant groups and iterate them -->
[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "dndbt_") > -1), code: {
		[h: log.debug ("Registering " + macroName)]
		[h: defineFunction (macroName, macroName + "@this")]
	}]
}]
[h: defineFunction ("dndbt_CleanToken", "Clean Token@this")]
[h: defineFunction ("dndbt_ResetProperties", "Reset Properties@Campaign")]
[h: defineFunction ("breakpoint", "dndbt_breakpoint@this", 1, 0)]