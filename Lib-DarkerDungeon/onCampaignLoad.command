<!-- Assert Campaign Version -->
[h: REQUIRED_CAMPAIGN_PROP_VERSION = "0.15"]
[h, macro ("dnd5e_Util_assertCampaignPropertiesVersion@Lib:DnD5e"): json.append ("", REQUIRED_CAMPAIGN_PROP_VERSION)]
<!-- sigh, instead of explicitly defining each one, just inspect the relevant groups and iterate them -->
[h: macros = getMacros()]
[h: log.info(getMacroName() + ": macros=" + macros)]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "ggdd_") > -1): defineFunction (macroName, macroName + "@this", 0)]
	[h, if (lastIndexOf (macroName, "ggddH_") > -1): defineFunction (macroName, macroName + "@this", 1)]
}]