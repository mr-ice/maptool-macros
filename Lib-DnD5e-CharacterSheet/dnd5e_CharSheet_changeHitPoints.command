[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: currentHitPoints = getProperty ("HP")]
[h: currentMaxHitPoints = getProperty ("MaxHP")]
[h: currentTempHitPoints = getProperty ("TempHP")]

[h: inputStr = "junk | Hit Points | You're gonna die | LABEL | span=true"]
[h: maxInput = "newMaxHP | " + currentMaxHitPoints + " | Maximum Hit Points | TEXT"]
[h: inputStr = listAppend (inputStr, maxInput, "##")]

[h: currentInput = "newCurrentHP | " + currentHitPoints + " | Current Hit Points | TEXT"]
[h: inputStr = listAppend (inputStr, currentInput, "##")]

[h: tempInput = "newTempHP | " + currentTempHitPoints + " | Temp Hit Points | TEXT"]
[h: inputStr = listAppend (inputStr, tempInput, "##")]

[h: abort (input (inputStr))]

[h: healthObject = json.set ("", "id", currentToken(), "current", newCurrentHP,
		"temporary", newTempHP, "maximum", newMaxHP)]

[h: dnd5e_applyHealth (healthObject)]
[h: dnd5e_CharSheet_refreshPanel ()]