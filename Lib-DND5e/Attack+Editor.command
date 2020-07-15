[h: log.debug ("Attack Editor: args = " + json.indent (macro.args))]
[h: ATTACK_JSON = "attackExpressionJSON"]
[h: LAST_ATTACK_SELECTION = "lastAttackSelection"]
[h: lastAttackSelection = getProperty (LAST_ATTACK_SELECTION)]
[r, if (json.length (macro.args) > 0), code: {
	<!-- Called back from the editor, do the thing -->
	[h: retObj = arg (0)]
	[h: action = json.get (retObj, "action")]
	[h: attackObj = json.get (retObj, "attackObj")]
	[h: selectedAttack = json.get (retObj, "selectedAttack")]
	[h: advDisadvantage = json.get (retObj, "advantageDisadvantage")]
	[h: saveAttackAsMacro = json.get (retObj, "saveAttackAsMacro")]
	[h: dndb_BasicToon_setAttackExpression (attackObj)]
	[h: inputObj = json.set ("", "selectedAttack", selectedAttack, 
							"advantageDisadvantage", advDisadvantage)]	
	[h, if (saveAttackAsMacro), code: {
			[h: advLabel = ""]
			[h, if (advDisadvantage == "Advantage"): advLabel = " (+)"]
			[h, if (advDisadvantage == "Disadvantage"): advLabel = " (-)"]
			[h: macroName = selectedAttack + advLabel + " Attack"]
			[h: currentMacros = getMacros()]
			[h: cmd = "[r: dnd5e_Macro_rollAttack ('" + inputObj + "')]"]
			<!-- dont create duplicates -->
			[h, foreach (currentMacro, currentMacros), if (currentMacro == macroName): saveAttackAsMacro = 0]
			[h: macroConfig = json.set ("", "applyToSelected", 1,
								"autoExecute", 1,
								"color", "red",
								"fontSize", "1.05em",
								"fontColor", "black",
								"group", "D&D Beyond - Attacks",
								"playerEditable", 1)]
			[h, if (saveAttackAsMacro > 0): createMacro (macroName, cmd, macroConfig)]

	}; {""}]
	[r, if (action == "SaveAttack"), code: {
		[r: "<br>" + dnd5e_Macro_rollAttack (inputObj)]
		[h: setProperty (LAST_ATTACK_SELECTION, selectedAttack)]
	}; {[r,s:"Attack Configuration saved!"]}]
}; {
	<!-- Called fresh, launch the editor -->
	[h: attackObj = dndb_BasicToon_getAttackExpression()]
	[h: dnd5e_AttackEditor (macroLinkText (getMacroName() + "@" + getMacroLocation(), "all", "", currentToken()), attackobj, lastAttackSelection)]
}]
