[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: abort (input (dnd5e_CharSheet_Util_getInitiativeInput (currentToken ())))]
[h: log.debug (CATEGORY + "## bonus.initiative = " + bonus.initiative +
	"; initiativeProficiency = " + initiativeProficiency)]
[h: setProperty ("proficiency.initiative", json.get (ARRY_PROF_VALUES, initiativeProficiency))]
[h: dnd5e_CharSheet_refreshPanel ()]