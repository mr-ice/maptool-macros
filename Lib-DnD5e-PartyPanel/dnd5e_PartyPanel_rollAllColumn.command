[h: property = arg(0)]
[h: rollMacro = arg(1)]
[h: dnd5e_PartyPanel_Constants (getMacroName())]
[h: log.debug (CATEGORY + "## property = " + property + "; rollMacro = " + rollMacro)]
[h: pcTokens = dnd5e_PartyPanel_getPCTokens()]
[r, foreach (pcToken, pcTokens, ""), code: {
	[r, macro (rollMacro + "@" + LIB_TOKEN): json.append ("", property, pcToken)]
}]