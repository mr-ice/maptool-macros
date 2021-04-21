[h: dnd5e_CharSheet_Constants (getMacroName())]

[h: inputStr = ""]

[h: saveLabelTemplate = "junk | <html><b>%{abilityName}</b> Save:&nbsp;&nbsp;&nbsp;<b>%{currentBonus}</b></html> |" +
			"<html>%{abilityName} Save</html> | label | span=true"]

[h: saveAdditionalBonusTemplate = "%{additionalBonusVar} | %{additionalBonusValue} | <html>%{abilityName} " +
	"(%{abilityBonus})&nbsp;&nbsp; + added bonus</html>| TEXT | width=3"]

[h: abilityNames = json.append (ARRY_ABILITIES_NAMES, "Death")]
[h: sep = "_____________________________________________"]
[h: sepCount = 1]
[h: sepLength = json.length (abilityNames)]
[h, foreach (abilityName, abilityNames), code: {

	[if (abilityName == "Death"): abbrevAbility = abilityName; abbrevAbility = substring (abilityName, 0, 3)]
	[currentBonus = dnd5e_CharSheet_formatBonus (getProperty (abilityName + "Save"))]

	[saveProficiencyProperty = "proficiency." + abbrevAbility + "Save"]
	[saveProficiency = getProperty (saveProficiencyProperty)]

	[abilityBonus = dnd5e_CharSheet_formatBonus (getProperty (abilityName + "Bonus"))]

	[additionalBonusVar = "bonus." + abbrevAbility + "Save"]
	[additionalBonusValue = getProperty (additionalBonusVar)]
	
	[inputStr = listAppend (inputStr, strformat (saveLabelTemplate), "##")]	

	[inputStr = listAppend (inputStr, strformat (saveAdditionalBonusTemplate), "##")]
	[inputStr = listAppend (inputStr, dnd5e_CharSheet_Util_getProficiencyInput (saveProficiency, abilityName +
		"ProfSelectIdx", "Proficiency", 0, "span=false"), "##")]

	[if (sepCount < sepLength): inputStr = listAppend (inputStr, "sep | " + sep + "|| label| span=true", "##")]
	[sepCount = sepCount + 1]
}]
[h: log.trace (CATEGORY + "## inputStr = " + inputStr)]
[h: abort (input (inputStr))]

<!-- vars are:
bonus.StrSave - autoboxed for us
StrengthProfSelectIdx - We gotta dig this up
	-->
[h, foreach (abilityName, abilityNames), code: {
	[if (abilityName == "Death"): abbrevAbility = abilityName; abbrevAbility = substring (abilityName, 0, 3)]
	[selectedProf = json.get (ARRY_PROF_VALUES, eval (abilityName + "ProfSelectIdx"))]
	[setProperty ("proficiency." + abbrevAbility + "Save", selectedProf)]
}]
[h: dnd5e_CharSheet_refreshPanel ()]