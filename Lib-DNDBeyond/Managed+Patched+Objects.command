[h: DATA_MACRO = "Data_Macro_Patched_Objects_Registry"]
[h: tokenId = currentToken()]
[h: log.debug (getMacroName() + ": macro.args = " + macro.args)]
[r, if (json.length (macro.args) > 0), code: {
	<!-- called back -->
	[h: params = arg (0)]
	[h: encodedRegistry = json.get (params, "object")]
	[h: action = json.get (params, "action")]
	[h: registry = decode (encodedRegistry)]
	[h, if (action == "save"): dndb_Util_setRegistry (DATA_MACRO, registry)]
}; {
	[h: registry = dndb_Util_getRegistry (DATA_MACRO)]
	[h: source = json.get (getMacroContext(), "source")]
	[h: params = json.set ("", "object", registry, "macroLinkText", macroLinkText (getMacroName() + '@' + source, "none", "", tokenId))]
	[r: jse.mainDialog.editJSON (params)]
}]