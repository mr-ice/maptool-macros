[h: tokenId = arg(0)]
[h: dnd5e_CharSheet_Constants (getMacroName())]

[h: currentBonus = getProperty ("bonus.initiative", tokenId)]
[h: currentInitiative = dnd5e_CharSheet_formatBonus (getProperty ("Initiative", tokenId))]
[h: currentInitProficiency = getProperty ("proficiency.initiative")]

[h: log.debug (CATEGORY + "## currentBonus = " + currentBonus)]

[h: inputString = "junk |<html><font style='font-size: 15px'>" + currentInitiative +
	" |<html>" + dnd5e_CharSheet_getInitiativeSpan("Current Initiative") + "</span></html>| Label | span=false"]
[h: inputString = listAppend (inputString, "junk |_____________________________________________||label|span=true", "##")]
[h: bonusInit = "bonus.initiative | " + currentBonus + 
	" | Additional Initiative Bonus | TEXT"]

[h: inputString = listAppend (inputString, bonusInit, "##")]

[h: profString = dnd5e_CharSheet_Util_getProficiencyInput (currentInitProficiency, "initiativeProficiency")]
[h: inputString = listAppend (inputString, profString, "##")]

[h: log.debug (CATEGORY + "## inputString = " + inputString)]
[h: macro.return = inputString]