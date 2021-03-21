[h, if (json.length (macro.args) > 0): inputObj = arg (0); inputObj = ""]
[h: log.debug ("inputObj: " + inputObj)]
[h: skillCheckNameCsv = "Acrobatics,Animal Handling,Arcana,Athletics,Deception,History,Insight,Intimidation,Investigation,Medicine,Nature,Perception,Performance,Persuasion,Religion,Sleight of Hand,Stealth,Survival"]
[h: abilities = "Strength,Dexterity,Constitution,Intelligence,Wisdom,Charisma"]
[h: skillCheckNameCsv = skillCheckNameCsv + "," + abilities]
[h: skillCheckOrder = json.fromList (skillCheckNameCsv)]
[h, if (encode (inputObj) == ""): abort (input ( " skillCheckName | " + skillCheckNameCsv + " | Select Skill / Ability | List | value=string",
					" advDisadv | None, Advantage, Disadvantage, Both | Advantage / Disadvantage | List | value=string",
					" saveAsMacro | 0 | Save as Macro | check "))]
[h, if (encode (inputObj) != ""), code: {
	[h: skillCheckName = json.get (inputObj, "skillCheckName")]
	[h: advDisadv = json.get (inputObj, "advDisadv")]
	<!-- never let the passed in object allow to save a macro. else a never ending cycle -->
	[h: saveAsMacro = 0]
}]

[h: abilityArray = json.fromList (abilities)]
[h, if (json.contains (abilityArray, skillCheckName)): propertyName = skillCheckName + "Ability"; propertyName = skillCheckName]
[h: propertyName = replace (propertyName, " ", "")]
[h: skillAbility = getProperty ("ability." + lower (propertyName))]
[h, if (skillAbility != ""): expressionName = skillCheckName + " (" + skillAbility + ")"; expressionName = propertyName]

[h: rollExpression = dnd5e_RollExpression_Ability (expressionName)]
[h: rollExpression = dnd5e_RollExpression_addPropertyModifiers (rollExpression, propertyName)]
[h: rollExpression = dnd5e_RollExpression_setAdvantageDisadvantage (rollExpression, advDisadv)]

[h: macroGroup = "D&D 5e - Skills"]
[h: macroName = skillCheckName]

[h, if (saveAsMacro > 0), code: {
	[h: dnd5e_Macro_clearMacroFamilyFromGroup (macroName, macroGroup)]
	[h: cmdArg = json.set ("", "skillCheckName", skillCheckName, 
							"advDisadv", "None")]
	
	[h: currentMacros = getMacros()]
	[h: cmd = "Skill Check@Lib:DnD5e"]
	[h: macroConfig = json.set ("", "applyToSelected", 1,
								"autoExecute", 1,
								"color", "blue",
								"sortBy", json.indexOf (skillCheckOrder, skillCheckName),
								"fontSize", "1.05em",
								"fontColor", "white",
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

