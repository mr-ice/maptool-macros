[h: profProperty = arg (0)]
[h, if (argCount () > 1): profDisplay = arg (1); profDisplay = profProperty]
[h: dnd5e_CharSheet_Constants (getMacroName())]

[h: currentProficiency = getProperty (profProperty)]
[h: profValues = json.append ("", 0, 0.5, 1, 2)]
[h: abort (input (dnd5e_CharSheet_Util_getProficiencyInput (currentProficiency, 
		"newProficiencySelect", profDisplay)))]
[h: selectedProfValue = json.get (profValues, newProficiencySelect)]
[h: setProperty (profProperty, selectedProfValue)]
[h: dnd5e_CharSheet_refreshPanel ()]