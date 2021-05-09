[h: retObj = macro.args]
[h: dnd5e_Constants (getMacroName())]
[h: log.debug (CATEGORY + "## Attack Editor: args = " + retObj)]
[h: LAST_ATTACK_SELECTION = "lastAttackSelection"]
[h: lastAttackSelection = getProperty (LAST_ATTACK_SELECTION)]
[r, if (json.length (retObj) > 0), code: {
	[h: "<!-- Called back from the processor, do the thing -->"]
	[h: action = json.get (retObj, "action")]
	[h: attackObj = json.get (retObj, "attackObj")]
	[h: selectedAttack = json.get (retObj, "selectedAttack")]
	[h: advDisadvantage = json.get (retObj, "advantageDisadvantage")]
	[h: saveAttackAsMacro = json.get (retObj, "saveAttackAsMacro")]
	[h: dnd5e_AttackEditor_setAttackExpression (attackObj)]
	[h: inputObj = json.set ("", "selectedAttack", selectedAttack, 
							"advantageDisadvantage", advDisadvantage)]	
	[h: "<!-- dont create duplicates -->"]
	[h: currentMacros = getMacros()]
	[h, foreach (currentMacro, currentMacros, ""), if (currentMacro == selectedAttack): saveAttackAsMacro = 0]
	[h, if (saveAttackAsMacro), code: {
		[h: fontColor = dnd5e_Preferences_getPreference ("attackEditor_macroFontColor")]
		[h: buttonColor = dnd5e_Preferences_getPreference ("attackEditor_macroButtonColor")]
		[h: sortByBase = listCount(currentMacros)]
		[h: macroConfig = json.set ("", "applyToSelected", 1,
								"autoExecute", 1,
								"color", buttonColor,
								"fontSize", "1.05em",
								"fontColor", fontColor,
								"group", "D&D 5e - Attacks",
								"playerEditable", 1,
								"minWidth", 170,
								"tooltip", "Make the " + selectedAttack + " attack",
								"sortBy", sortByBase)]
		[h: "<!-- Normal Attack -->"]
		[h: macroInputs = json.set ("", "selectedAttack", selectedAttack)]	
		[h: lastSortBy = dnd5e_Macro_createAdvDisadvMacroFamily (selectedAttack, "dnd5e_Macro_rollAttack@Lib:DnD5e", macroInputs, macroConfig)]
		[h: lastSortBy = lastSortBy + 1]
				[h: "<!-- Edit -->"]
		[h: macroConfig = json.set(macroConfig, "minWidth", 12,
						"tooltip", "Edit the " + selectedAttack + " attack",
						"sortBy", sortByBase + "-" + lastSortBy)]
		[h: macroCmd = "[h: setProperty('" + LAST_ATTACK_SELECTION + "', '" + selectedAttack + "')]"]
		[h: macroCmd = macroCmd + "[r, macro('" + getMacroName() + "@" + getMacroLocation() + "'):'']"]
		[h: createMacro ("<html>&#x270e;</html>", macroCmd, macroConfig)]
		[h: "<!-- Remove Macros -->"]
		[h: macroInputs = json.append("[]", selectedAttack, "D&D 5e - Attacks")]
		[h: macroConfig = json.set(macroConfig, "minWidth", 12,
						"tooltip", "Remove the " + selectedAttack + " attack macros. This does not remove the actual action, just the macros",
						"sortBy", sortByBase + "-" + lastSortBy + 1)]
		[h: macroCmd = "[macro('dnd5e_Macro_clearMacroFamilyFromGroup@Lib:DnD5e'): '" + macroInputs + "']"]
		[h: createMacro ("<html>&#128939;</html>", macroCmd, macroConfig)]
	}]
	[r, if (action == "SaveAttack"), code: {
		[r: "<br>" + dnd5e_Macro_rollAttack (inputObj)]
		[h: setProperty (LAST_ATTACK_SELECTION, selectedAttack)]
	}; {
		[r,s:"Attack Configuration saved!"]
	}]
}; {
	[h: "<!-- Called fresh, launch the editor -->"]
	[h: attackObj = dnd5e_AttackEditor_getAttackExpression()]
	[h: dnd5e_AttackEditor (macroLinkText (getMacroName() + "@" + getMacroLocation(), "all", "", currentToken()), attackobj, lastAttackSelection)]
}]