[h: dnd5e_CharSheet_Constants (getMacroName())]
<!-- Displays an Input to update toon abilities -->
[h: abort (input (dnd5e_CharSheet_Util_getAbilitiesInput (currentToken())))]
[h, foreach (abilityName, ARRY_ABILITIES_NAMES), code: {
	[setProperty (abilityName, eval ("input" + abilityName))]
}]
[h: dnd5e_CharSheet_refreshPanel()]