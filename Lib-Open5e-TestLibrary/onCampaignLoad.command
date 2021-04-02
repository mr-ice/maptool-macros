[h: REQUIRED_DND_LIB_VERSION = 0.15]
<!-- No calling lib functions during onCampaignLoad -->
[h, macro ("dnd5e_Util_assertLibVersion@Lib:DnD5e"): json.append ("", REQUIRED_DND_LIB_VERSION)]

[h: MACRO_PREFIX = "o5et_"]
[h: defineFunction (MACRO_PREFIX + "Constants", "Constants@this", 0, 0)]
<!-- sigh, instead of explicitly defining each one, just inspect the relevant groups and iterate them -->
[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, MACRO_PREFIX) > -1), code: {
		[h: log.debug ("Registering " + macroName)]
		[h: defineFunction (macroName, macroName + "@this")]
	}]
}]
