[h: inputArgs = macro.args]
[h, if (json.type (inputArgs) == "UNKNOWN"): inputArgs = "[]"]
[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: log.debug (CATEGORY + "## inputArgs = " + inputArgs)]
[r, if (json.isEmpty (inputArgs)), code: {
	[h: attacksJSON = dnd5e_AttackEditor_getAttackExpression()]
	[h: log.debug (CATEGORY + "## attacksJSON = " + attacksJSON)]
	[h, if (json.type (attacksJSON) != "OBJECT"): attacksJSON = "{}"]
	[h: handler = macroLinkText (getMacroName() + "@" + LIB_TOKEN, 
		"all", "", currentToken())]
	[h: dnd5e_AttackEditor (handler, attacksJSON)]
}; {
	<!-- We are the handler for the sole purpose of refreshing after return -->
	[r, macro ("Attack Editor@Lib:DnD5e"): inputArgs]
	[h: dnd5e_CharSheet_refreshPanel ()]
}]
