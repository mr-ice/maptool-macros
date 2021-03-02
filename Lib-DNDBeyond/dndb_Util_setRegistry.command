[h: DATA_MACRO = arg (0)]
[h: registry = arg (1)]
[h, token ("lib:DnDBeyond"): tokenId = currentToken()]
[h: macroIndexes = getMacroIndexes (DATA_MACRO, "json", tokenId)]
[h, if (json.length (macroIndexes) > 1): log.warn (getMacroName() + ": More than one Data Macro found for " + DATA_MACRO)]
[h: encoded = encode (registry)]
[h, if (json.length (macroIndexes) == 0), code: {
	<!-- Create it -->
	[props = json.set ("", "group", "Data - Registry",
						"label", DATA_MACRO,
						"playerEditable", 0,
						"autoExecute", 0,
						"command", encoded)]
	[createMacro (props)]
}; {
	<!-- Update it -->
	[macroIndex = json.get (macroIndexes, 0)]
	[setMacroCommand (macroIndex, encoded, tokenId)]
}]