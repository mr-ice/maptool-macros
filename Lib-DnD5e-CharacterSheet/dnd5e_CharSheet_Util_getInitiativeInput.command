[h: dnd5e_CharSheet_Constants (getMacroName())]

[h: currentBonus = getProperty ("bonus.initiative")]
[h: currentInitiative = dnd5e_CharSheet_formatBonus (getProperty ("Initiative"))]
[h: currentInitProficiency = getProperty ("proficiency.initiative")]
[h: profBonus = currentInitProficiency * getProperty ("Proficiency")]
[h: initAbility = dnd5e_Property_getInitAbility()]
[h: abilityBonus = dnd5e_CharSheet_formatBonus (getProperty (initAbility + "Bonus"))]
[h: fullBonusString = abilityBonus + " (" + initAbility + ")"]
[h, if (currentBonus > 0):
	fullBonusString = fullBonusString + " + " + currentBonus + " (Bonus)"]
[h, if (currentInitProficiency > 0): 
	fullBonusString = fullBonusString + " + " + profBonus + " (Proficiency)"]

[h: log.debug (CATEGORY + "## currentBonus = " + currentBonus)]
[h: log.debug (CATEGORY + "## fullBonusString = " + fullBonusString)]

[h: inputString = "junk |<html><font style='font-size: 15px'>" + currentInitiative +
	" |<html>" + dnd5e_CharSheet_getInitiativeSpan("Current Initiative") + "</html>| Label | span=false"]
[h: inputString = listAppend (inputString, 
	"junk | <html>" + fullBonusString + "</html>| | LABEL |span=true", "##")]
[h: inputString = listAppend (inputString, "junk |_____________________________________________||label|span=true", "##")]
[h: bonusInit = "bonus.initiative | " + currentBonus + 
	" | Additional Initiative Bonus | TEXT"]

[h: inputString = listAppend (inputString, bonusInit, "##")]

[h: profString = dnd5e_CharSheet_Util_getProficiencyInput (currentInitProficiency, "initiativeProficiency")]
[h: inputString = listAppend (inputString, profString, "##")]

[h: log.debug (CATEGORY + "## inputString = " + inputString)]
[h: macro.return = inputString]
