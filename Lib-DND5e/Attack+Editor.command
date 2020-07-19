[h: log.debug ("Attack Editor: args = " + json.indent (macro.args))]
[h: LAST_ATTACK_SELECTION = "lastAttackSelection"]
[h: lastAttackSelection = getProperty (LAST_ATTACK_SELECTION)]
[r, if (json.length (macro.args) > 0), code: {
	<!-- Called back from the processor, do the thing -->
	[h: retObj = arg (0)]
	[h: action = json.get (retObj, "action")]
	[h: attackObj = json.get (retObj, "attackObj")]
	[h: selectedAttack = json.get (retObj, "selectedAttack")]
	[h: advDisadvantage = json.get (retObj, "advantageDisadvantage")]
	[h: saveAttackAsMacro = json.get (retObj, "saveAttackAsMacro")]
	[h: dnd5e_AttackEditor_setAttackExpression (attackObj)]
	[h: inputObj = json.set ("", "selectedAttack", selectedAttack, 
							"advantageDisadvantage", advDisadvantage)]	
	<!-- dont create duplicates -->
	[h: currentMacros = getMacros()]
	[h, foreach (currentMacro, currentMacros), if (currentMacro == selectedAttack): saveAttackAsMacro = 0]
	[h, if (saveAttackAsMacro), code: {
		[h: macroConfig = json.set ("", "applyToSelected", 1,
								"autoExecute", 1,
								"color", "red",
								"fontSize", "1.05em",
								"fontColor", "white",
								"group", "D&D Beyond - Attacks",
								"playerEditable", 1,
								"minWidth", 170,
								"tooltip", "Make the " + selectedAttack + " attack",
								"sortBy", listCount(currentMacros))]
		<!-- Normal Attack -->
		[h: macroInputs = json.set ("", "selectedAttack", selectedAttack, 
									"advantageDisadvantage", "Normal")]	
		[h: macroCmd = "[r: dnd5e_Macro_rollAttack ('" + macroInputs + "')]"]
		[h: createMacro (selectedAttack, macroCmd, macroConfig)]
		<!-- Advantage Attack -->
		[h: macroConfig = json.set(macroConfig, "minWidth", "",
						"tooltip", "Make the " + selectedAttack + " attack with advantage",
						"sortBy", listCount(currentMacros) + 1)]
		[h: macroInputs = json.set ("", "selectedAttack", selectedAttack, 
									"advantageDisadvantage", "Advantage")]	
		[h: macroCmd = "[r: dnd5e_Macro_rollAttack ('" + macroInputs + "')]"]
		[h: createMacro ("<html>&#x23eb;</html>", macroCmd, macroConfig)]
		<!-- Disadvantage Attack -->
		[h: macroConfig = json.set(macroConfig,
						"tooltip", "Make the " + selectedAttack + " attack with disadvantage",
						"sortBy", listCount(currentMacros) + 2)]
		[h: macroInputs = json.set ("", "selectedAttack", selectedAttack, 
									"advantageDisadvantage", "Disadvantage")]	
		[h: macroCmd = "[r: dnd5e_Macro_rollAttack ('" + macroInputs + "')]"]
		[h: createMacro ("<html>&#x23ec;</html>", macroCmd, macroConfig)]
		<!-- Edit -->
		[h: macroConfig = json.set(macroConfig,
						"tooltip", "Edit the " + selectedAttack + " attack",
						"sortBy", listCount(currentMacros) + 3)]
		[h: macroCmd = "[h: setProperty('" + LAST_ATTACK_SELECTION + "', '" + selectedAttack + "')]"]
		[h: macroCmd = macroCmd + "[r, macro('" + getMacroName() + "@" + getMacroLocation() + "'):'']"]
		[h: createMacro ("<html>&#x270e;</html>", macroCmd, macroConfig)]
	}; {""}]
	[r, if (action == "SaveAttack"), code: {
		[r: "<br>" + dnd5e_Macro_rollAttack (inputObj)]
		[h: setProperty (LAST_ATTACK_SELECTION, selectedAttack)]
	}; {
		[r,s:"Attack Configuration saved!"]
	}]
}; {
	<!-- Called fresh, launch the editor -->
	[h: attackObj = dnd5e_AttackEditor_getAttackExpression()]
	[h: dnd5e_AttackEditor (macroLinkText (getMacroName() + "@" + getMacroLocation(), "all", "", currentToken()), attackobj, lastAttackSelection)]
}]