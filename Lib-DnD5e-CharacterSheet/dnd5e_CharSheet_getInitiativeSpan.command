[h: displayText = arg(0)]

[h, if (displayText == ""): 
	displayText = dnd5e_CharSheet_formatBonus (getProperty ("Initiative"))]
[h: initAbility = dnd5e_Property_getInitAbility()]
[h: abilityBonus = getProperty (initAbility + "Bonus")]
[h: initBonus = getProperty ("bonus.initiative")]
[h, if (initBonus == ""): initBonus = 0]
[h: initProficiency = getProperty ("proficiency.initiative")]
[h, if (initProficiency == ""): initProficiency = 0]
[h: profValue = getProperty ("Proficiency")]
[h, if (initProficiency > 0): 
	initProficiencyValue = floor (initProficiency * profValue);
	initProficiencyValue = 0]

[h: title = dnd5e_CharSheet_formatBonus (abilityBonus) + " (" + 
	substring (initAbility, 0, 3) + ")"]

[h, if (initBonus != 0): title = concat (title, " + " + initBonus + " (Bonus)")]

[h, if (initProficiency > 0): title = concat (title, " + " + initProficiencyValue + 
	" (Proficiency)")]

[h: html = '<span title="' + title + '">' + displayText + '</span>']

[h: macro.return = html]
