[h: property = arg(0)]
[h: tokenId = arg(1)]
[h: linkText = arg(2)]
[h: dnd5e_PartyPanel_Constants (getMacroName())]
[h: cfg  = dnd5e_PartyPanel_getConfig()]
[h: selectedProperties = json.get (cfg, CONFIGURATION_SELECTED_PROPERTIES_KEY)]
[h: propertyCfg = json.get (selectedProperties, property)]
[h: log.debug (CATEGORY + "## property = " + property + "; propertyCfg = " + propertyCfg)]
[h: roller = json.get (propertyCfg, CONFIGURATION_ROLLER_KEY)]
[h: macroLinkHtml = linkText]
[h, if (roller != "" && tokenId != ""), code: {
	[macroLinkHtml = macroLink (linkText, roller + "@" + LIB_TOKEN, "gm", 
		json.append ("", property, tokenId))]
}]
[h, if (roller != "" && tokenId == ""), code: {
	[macroLinkHtml = macroLink (linkText, "dnd5e_PartyPanel_rollAllColumn@" + LIB_TOKEN, "gm",
		json.append ("", property, roller))]
}]
[h: macro.return = macroLinkHtml]