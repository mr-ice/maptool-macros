[h, if (json.length (macro.args) > 0): inputObj = arg (0); inputObj = ""]
[h: basicToon = getProperty ("dndb_BasicToon")]
[h, if (encode (basicToon) == ""), code: {
	[h: error = "You must initialize with DNDBeyond first"]
	[h: abort (input ( " junk | | " + error + " | LABEL | TEXT=fals"))]
	[h: return (0, error)]
}]

[h: savingThrows = json.get (basicToon, "savingThrows")]
[h: savingThrowNameCsv = ""]
[h, foreach (savingThrow, savingThrows), code: {
	[h: savingThrowNameCsv = savingThrowNameCsv + "," + json.get (savingThrow, "name")]
}]
[h: savingThrowNameCsv = substring (savingThrowNameCsv, 1)]
[h, if (encode (inputObj) == ""): abort (input ( " selectedsavingThrowPos | " + savingThrowNameCsv + " | Select Saving Throw | List ",
					" advDisadv | None, Advantage, Disadvantage | Advantage / Disadvantage | List ",
					" saveAsMacro | 0 | Save as Macro | check "))]
[h, if (encode (inputObj) != ""), code: {
	[h: selectedsavingThrowPos = json.get (inputObj, "selectedsavingThrowPos")]
	[h: advDisadv = json.get (inputObj, "advDisadv")]
	<!-- never let the passed in object allow to save a macro. else a never ending cycle -->
	[h: saveAsMacro = 0]
}]
<!-- selection should correspond to the arry position of the savingThrow object -->
[h: savingThrow = json.get (savingThrows, selectedsavingThrowPos)]
[h: savingThrowName = json.get (savingThrow, "name") + " Save"]
[h: bonus = getProperty (savingThrowName)]

[h: rollExpression = json.set ("", "name", json.get (savingThrow, "name"),
								"diceSize", 20,
								"diceRolled", 1,
								"expressionTypes", "Save",
								"bonus", bonus)]

[h, switch (advDisadv):
	case 1: rollExpression = json.set (rollExpression, "hasAdvantage", 1);
	case 2: rollExpression = json.set (rollExpression, "hasDisadvantage", 1);
	default: ""]



[h, if (saveAsMacro > 0), code: {
	[h: cmdArg = json.set ("", "selectedsavingThrowPos", selectedsavingThrowPos, 
							"advDisadv", 0)]

	[h: macroName = savingThrowName]
	[h: currentMacros = getMacros()]
	[h: cmd = "[macro ('Saving Throw@Lib:DnDBeyond'): '" + cmdArg + "']"]
	[h: macroConfig = json.set ("", "applyToSelected", 1,
								"autoExecute", 1,
								"color", "black",
								"sortBy", selectedsavingThrowPos,
								"fontSize", "1.05em",
								"fontColor", "yellow",
								"group", "D&D Beyond - Saves",
								"minWidth", 170,
								"playerEditable", 1)]
	<!-- dont create duplicates -->
	[h, foreach (currentMacro, currentMacros), if (currentMacro == macroName): saveAsMacro = 0]
	
	[h, if (saveAsMacro > 0), code: {
		[createMacro (macroName, cmd, macroConfig)]
		[macroConfig = json.set (macroConfig, 
						"sortBy", selectedsavingThrowPos + "-1",
						"minWidth", 12)]
		[cmdArg = json.set (cmdArg, "advDisadv", 1)]
		[cmd = "[macro ('Saving Throw@Lib:DnDBeyond'): '" + cmdArg + "']"]
		[label = dnd5e_Macro_getModLabel ("advantage")]
		[createMacro (label, cmd, macroConfig)]
		[macroConfig = json.set (macroConfig, "sortyBy", selectedsavingThrowPos + "-2")]
		[cmdArg = json.set (cmdArg, "advDisadv", 2)]
		[cmd = "[macro ('Saving Throw@Lib:DnDBeyond'): '" + cmdArg + "']"]
		[label = dnd5e_Macro_getModLabel ("disadvantage")]
		[createMacro (label, cmd, macroConfig)]
	}; {""}]
}]

[h: check = json.get (dnd5e_DiceRoller_roll (rollExpression), 0)]

[r: json.get (check, "output")]