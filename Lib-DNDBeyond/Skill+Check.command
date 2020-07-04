[h, if (json.length (macro.args) > 0): inputObj = arg (0); inputObj = ""]
[h: basicToon = getProperty ("dndb_BasicToon")]
[h, if (encode (basicToon) == ""), code: {
	[h: error = "You must initialize with DNDBeyond first"]
	[h: abort (input ( " junk | | " + error + " | LABEL | TEXT=fals"))]
	[h: return (0, error)]
}]

<!-- if an inputObj was provide, use that instead of the input -->

[h: skills = json.get (basicToon, "skills")]
[h: skillNameCsv = ""]
[h, foreach (skill, skills), code: {
	[h: skillNameCsv = skillNameCsv + "," + json.get (skill, "name")]
}]
[h: skillNameCsv = substring (skillNameCsv, 1)]
[h, if (encode (inputObj) == ""): abort (input ( " selectedSkillPos | " + skillNameCsv + " | Select skill | List ",
					" advDisadv | None, Advantage, Disadvantage | Advantage / Disadvantage | List ",
					" saveAsMacro | 0 | Save as Macro | check "))]
<!-- selection should correspond to the arry position of the skill object -->
[h, if (encode (inputObj) != ""), code: {
	[h: selectedSkillPos = json.get (inputObj, "selectedSkillPos")]
	[h: advDisadv = json.get (inputObj, "advDisadv")]
	<!-- never let the passed in object allow to save a macro. else a never ending cycle -->
	[h: saveAsMacro = 0]
}]

[h, if (advDisadv == 2): hasDisadvantage = 1; hasDisadvantage = 0]
[h, if (advDisadv == 1): hasAdvantage = 1; hasAdvantage = 0]

<!-- Check the state for forced adv/disadv from state -->
[h: isPoisoned = getState ("Poisoned")]
[r, if (isPoisoned > 0), code: {
	[r: "You're <font color='red'><b>Poisoned</b></font>! Applying Disadvantage"]
	[h: hasDisadvantage = 1]
}; {}]

[h: skill = json.get (skills, selectedSkillPos)]
[h: skillName = json.get (skill, "name")]
<!-- if its a 'xxxx Ability' then get the xxxx property instead of the skill -->
[h: abilityIndex = indexOf (skillName, " Ability")]
[h, if (abilityIndex > -1), code: {
	[h: skillName = substring (skillName, 0, abilityIndex)]
	[h: bonus = getProperty (skillName + " Bonus")]
}; {
	[h: bonus = getProperty (skillName)]
}]

[h: skillCheckObj = json.set ("", "checkLabel", json.get (skill, "name") + " Check",
							"bonus", bonus,
							"advDisadv", advDisadv)]

[h: rollExpression = json.set ("", "name", skillName,
								"diceSize", 20,
								"diceRolled", 1,
								"expressionTypes", "Ability",
								"bonus", bonus,
								"hasDisadvantage", hasDisadvantage,
								"hasAdvantage", hasAdvantage)]
[h: rolledExpressions = dnd5e_DiceRoller_roll (rollExpression)]
[h: msg = dnd5e_RollExpression_getCombinedOutput (rolledExpressions)]
[r: msg]

[h, if (saveAsMacro > 0), code: {
	[h: cmdArg = json.set ("", "selectedSkillPos", selectedSkillPos, 
							"advDisadv", advDisadv)]
	[h, if (advDisadv == 0): advLabel = ""]
	[h, if (advDisadv == 1): advLabel = " (+)"]
	[h, if (advDisadv == 2): advLabel = " (-)"]
	[h: macroName = skillName + advLabel + " Check"]
	[h: currentMacros = getMacros()]
	[h: cmd = "[macro ('Skill Check@Lib:DnDBeyond'): '" + cmdArg + "']"]
	<!-- dont create duplicates -->
	[h, foreach (currentMacro, currentMacros), if (currentMacro == macroName): saveAsMacro = 0]
	[h: macroConfig = json.set ("", "applyToSelected", 1,
								"autoExecute", 1,
								"color", "blue",
								"fontSize", "1.05em",
								"sortBy", selectedSkillPos,
								"fontColor", "white",
								"group", "D&D Beyond - Skills",
								"playerEditable", 1)]
	[h, if (saveAsMacro > 0): createMacro (macroName, cmd, macroConfig)]
}]
