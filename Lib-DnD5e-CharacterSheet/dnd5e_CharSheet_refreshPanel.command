[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: log.debug (CATEGORY + "## currentToken = " + currentToken())]
[h: panelName = strformat (PANEL_CHARACTER_SHEET_NAME)]
[h: log.debug (CATEGORY + "## panelName = " + panelName)]
[h, if (isFrameVisible (panelName)): 
	dnd5e_CharSheet_CharacterSheet();
	log.debug (CATEGORY + "## Frame " + panelName + " not displayed")]
[h, if (isDialogVisible (panelName)):
	dnd5e_CharSheet_CharacterSheet();
	log.debug (CATEGORY + "## Dialog " + panelName + " not displayed")]