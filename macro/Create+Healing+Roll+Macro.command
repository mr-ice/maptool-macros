[h, if (json.length (macro.args) > 0): skipMacro = arg (0); skipMacro = 0]
[h: healingRolls = "[]"]
[h: addAnother = 1]
[h, while (addAnother), code: {
	[h: abort (input ("name | Name | Name | text",
					"diceExpression | 2d4 + 8 | Healing dice expression | text",
					"addAnother | 0 | Add another? | check"))]
	[h: rollExpression = dnd5e_RollExpression_parseRoll (diceExpression)]
	[h: rollExpression = json.set (rollExpression, "expressionTypes", "Healing",
									"name", name)]
	[h: healingRolls = json.append (healingRolls, rollExpression)]
}]
[h: log.info (json.indent (healingRolls))]
[h, if (!skipMacro): dnd5e_DiceRoller_createMacro (healingRolls)]
[h: macro.return = healingRolls]