[h, if (json.length (macro.args) > 0): skipMacro = arg (0); skipMacro = 0]
[h: damageRolls = "[]"]
[h: addAnother = 1]
[h, while (addAnother), code: {
	[h: abort (input ("name | Name | Name | text",
					"diceExpression | 1d6 + 1 | Damage dice expression | text",
					"damageTypes | Slashing | Damage types | text",
					"extraText | | Flavor text, like DC check | text",
					"addAnother | 0 | Add another? | check"))]
	[h: rollExpression = dnd5e_RollExpression_parseRoll (diceExpression)]
	[h: rollExpression = json.set (rollExpression, "name", name, "expressionTypes", "Damage", "damageTypes", json.fromList (damageTypes))]
	[h: rollExpression = dnd5e_RollExpression_addType (rollExpression, dnd5e_Type_Damageable())]
	[h, if (extraText != "" && extraText != 0): 
			rollExpression = dnd5e_RollExpression_setDescription (rollExpression, extraText); ""]
	[h: damageRolls = json.append (damageRolls, rollExpression)]
}]
[h: log.info (json.indent (damageRolls))]
[h, if (!skipMacro): dnd5e_DiceRoller_createMacro (damageRolls)]
[h: macro.return = damageRolls]