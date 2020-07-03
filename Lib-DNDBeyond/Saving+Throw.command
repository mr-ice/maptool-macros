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

<!-- Determine current state -->
<!-- Fails str and dex -->
[h: fuckedStates = json.append ("", "Paralyzed", "Petrified", "Stunned", "Unconscious")]
[h: isFucked = 0]
[h: fuckedMsg = ""]
[h, foreach (fuckedState, fuckedStates), code: {
	[h: theState = getState (fuckedState)]
	[h, if (theState > 0), code: {
		[h: isFucked = isFucked + 1]
		[h: fuckedMsg = fuckedMsg + "You're <font color='red'><b>" + fuckedState + "</b></font>!<br>"]
	}]
}]
<!-- disadv on dex -->
[h: isRestrained = getState ("Restrained")]

<!-- Auto fails -->
[r, if ( selectedsavingThrowPos <= 1 && isFucked > 0), code: {
	[r: fuckedMsg]
	[r: "<b>You automatically <font color='red'><i>FAIL</i></font>!!<b><br>"]
	[h: rollExpression = json.set (rollExpression, "expressionTypes", "['Save', 'staticRoll']",
													"staticRoll", 1)]

}; {}]


[r, if (selectedsavingThrowPos == 1 && isRestrained > 0), code: {
	[r: "<font color='red'>Applying Restrained effect (Disadvantage)</font><br>"]
	[h: rollExpression = json.set (rollExpression, "hasDisadvantage", 1)]
}; {}]


[h, if (saveAsMacro > 0), code: {
	[h: cmdArg = json.set ("", "selectedsavingThrowPos", selectedsavingThrowPos, 
							"advDisadv", advDisadv)]
	[h, if (advDisadv == 0): advLabel = ""]
	[h, if (advDisadv == 1): advLabel = " (+)"]
	[h, if (advDisadv == 2): advLabel = " (-)"]
	[h: macroName = savingThrowName + advLabel]
	[h: currentMacros = getMacros()]
	[h: cmd = "[macro ('Saving Throw@Lib:DnDBeyond'): '" + cmdArg + "']"]
	<!-- dont create duplicates -->
	[h, foreach (currentMacro, currentMacros), if (currentMacro == macroName): saveAsMacro = 0]
	[h: macroConfig = json.set ("", "applyToSelected", 1,
								"autoExecute", 1,
								"color", "black",
								"sortBy", selectedsavingThrowPos,
								"fontSize", "1.05em",
								"fontColor", "yellow",
								"group", "D&D Beyond - Saves",
								"playerEditable", 1)]
	[h, if (saveAsMacro > 0): createMacro (macroName, cmd, macroConfig)]
}]

[h: check = json.get (dnd5e_DiceRoller_roll (rollExpression), 0)]

[r: json.get (check, "output")]