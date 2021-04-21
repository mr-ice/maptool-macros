[h: log.warn (argCount())]
[h, if (argCount() > 0): skillName = arg (0); skillName = ""]
[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: log.debug (CATEGORY + "## skillName = " + skillName)]
[h, if (skillName == ""), code: {
	[abilitiesProperties = ""]
	[foreach (abilityName, ARRY_ABILITIES_NAMES):
		abilitiesProperties = json.append (abilitiesProperties,
			abilityName + "Ability")]
	[skillArry = json.merge (ARRY_SKILLS_NAMES, abilitiesProperties)]
}; {
	[skillArry = json.append ("", skillName)]
}]
[h: log.debug (CATEGORY + "## skillArry = " + skillArry)]
[h: inputStr = ""]

<!-- this is gonna look a lot like Saves -->
[h: skillLabelTemplate = "junk | <html><b>%{skillName}</b>:&nbsp;&nbsp;&nbsp;<b>%{currentBonus}</b></html> |" +
			"<html>%{skillName} Ability</html> | label | span=true"]

[h: skillAdditionalBonusTemplate = "%{additionalBonusVar} | %{additionalBonusValue} | <html>%{skillAbility} " +
	"(%{abilityBonus})&nbsp;&nbsp; + added bonus</html>| TEXT | width=3"]

[h: sep = "sep | _____________________________________________ ||label|span=true"]
[h: sepCount = 1]
[h: sepLength = (json.length (skillArry))]
[h, foreach (skillName, skillArry), code: {

	[if (json.contains (ARRY_ABILITIES_NAMES, skillName)), code: {
		[propertyName = skillName + "Ability"]
		[proficiencyProperty = "proficiency." + substring (skillName, 0, 3) + "Ability"]
		[additionalBonusVar = "bonus." + substring (skillName, 0, 3) + "Ability"]
		[skillAbility = skillName]
	}; {
		[propertyName = replace (skillName, " ", "")]
		[proficiencyProperty = "proficiency." + propertyName]
		[additionalBonusVar = "bonus." + propertyName]
		[skillAbility = getProperty ("ability." + propertyName)]
	}]
	[currentBonus = dnd5e_CharSheet_formatBonus (getProperty (propertyName))]
	[log.debug (CATEGORY + "## propertyName = " + propertyName + 
			"; currentBonus = " + currentBonus)]
	[skillProficiency = getProperty (proficiencyProperty)]

	[abilityBonus = dnd5e_CharSheet_formatBonus (getProperty (skillAbility + "Bonus"))]
	[additionalBonusValue = getProperty (additionalBonusVar)]

	[inputStr = listAppend (inputStr, strformat (skillLabelTemplate), "##")]
	[inputStr = listAppend (inputStr, strformat (skillAdditionalBonusTemplate), "##")]
	[inputStr = listAppend (inputStr, dnd5e_CharSheet_Util_getProficiencyInput 
		(skillProficiency, propertyName + "ProfSelectIdx", "Proficiency",
		0, "span=false"), "##")]

	[if (sepCount < sepLength): inputStr = listAppend (inputStr, sep, "##")]
	[sepCount = sepCount + 1]	

}]
[h: log.trace (CATEGORY + "## inputStr = " + inputStr)]
[h: abort (input( inputStr))]

[h, foreach (skillName, skillArry), code: {
	[if (json.contains (ARRY_ABILITIES_NAMES, skillName)), code: {
		[propertyName = skillName + "Ability"]
		[proficiencyProperty = "proficiency." + substring (skillName, 0, 3) + "Ability"]
	}; {
		[propertyName = replace (skillName, " ", "")]
		[proficiencyProperty = "proficiency." + propertyName]
	}]
	
	[selectedProf = json.get (ARRY_PROF_VALUES, eval (propertyName + "ProfSelectIdx"))]
	[setProperty (proficiencyProperty, selectedProf)]
}]
[h: dnd5e_CharSheet_refreshPanel ()]