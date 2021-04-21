[h: tokenId = arg(0)]
[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: inputStr = ""]
[h, foreach (abilityName, ARRY_ABILITIES_NAMES), code: {
	[log.debug (CATEGORY + "## abilityName = " + abilityName)]
	[abilityInput = "input" + abilityName + " | " + 
		getProperty (abilityName, tokenId) + " | " + abilityName + 
		" | TEXT | width=3"]
	[log.debug (CATEGORY + "## abilityInput = " + abilityInput)]
	[inputStr = listAppend (inputStr, abilityInput, "##")]
}]
[h: log.debug (CATEGORY + "## inputStr = " + inputStr)]
[h: macro.return = inputStr)]