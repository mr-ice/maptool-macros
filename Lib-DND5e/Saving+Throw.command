[h, if (json.length (macro.args) > 0): inputObj = arg (0); inputObj = ""]
[h: log.debug ("inputObj: " + inputObj)]
[h: savingThrowNameCsv = "Strength,Dexterity,Constitution,Intelligence,Wisdom,Charisma,Death"]
[h: savingThrowOrder = json.fromList (savingThrowNameCsv)]
[h, if (encode (inputObj) == ""): abort (input ( " savingThrowAbility | " + savingThrowNameCsv + " | Select Saving Throw | List | value=string",
					" advDisadv | None, Advantage, Disadvantage, Both | Advantage / Disadvantage | List | value=string",
					" saveAsMacro | 0 | Save as Macro | check "))]
[h, if (encode (inputObj) != ""), code: {
	[h: savingThrowAbility = json.get (inputObj, "savingThrowAbility")]
	[h: advDisadv = json.get (inputObj, "advDisadv")]
	<!-- never let the passed in object allow to save a macro. else a never ending cycle -->
	[h: saveAsMacro = 0]
}]
<!-- selection should correspond to the arry position of the savingThrow object -->
[h: savingThrowName = savingThrowAbility  + "Save"]
[h: bonus = getProperty (savingThrowName)]

[h: rollExpression = dnd5e_RollExpression_Save (savingThrowAbility)]
[h: rollExpression = dnd5e_RollExpression_setBonus (rollExpression, bonus)]
[h: rollExpression = dnd5e_RollExpression_setAdvantageDisadvantage (rollExpression, advDisadv)]

[h: macroGroup = "D&D 5e - Saves"]
[h: macroName = savingThrowAbility + " Save"]

[h, if (saveAsMacro > 0), code: {
	[h: dnd5e_Macro_clearMacroFamilyFromGroup (macroName, macroGroup)]
	[h: cmdArg = json.set ("", "savingThrowAbility", savingThrowAbility, 
							"advDisadv", "None")]

	
	[h: currentMacros = getMacros()]

	[h: cmd = "Saving Throw@Lib:DnD5e"]
	[h: macroConfig = json.set ("", "applyToSelected", 1,
								"autoExecute", 1,
								"color", "black",
								"sortBy", json.indexOf (savingThrowOrder, savingThrowAbility),
								"fontSize", "1.05em",
								"fontColor", "yellow",
								"group", macroGroup,
								"minWidth", 170,
								"playerEditable", 1)]
	<!-- dont create duplicates -->
	[h, foreach (currentMacro, currentMacros), if (currentMacro == macroName): saveAsMacro = 0]
	
	[h, if (saveAsMacro > 0), code: {
		[dnd5e_Macro_createAdvDisadvMacroFamily (macroName, cmd, cmdArg, macroConfig)]
	}; {""}]
}]

[h: check = json.get (dnd5e_DiceRoller_roll (rollExpression), 0)]

[r: json.get (check, "output")]