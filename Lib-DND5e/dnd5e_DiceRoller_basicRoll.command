[h: rollExpression = arg (0)]
[h: diceSize = dnd5e_RollExpression_getDiceSize (rollExpression)]
[h: diceRolled = dnd5e_RollExpression_getDiceRolled (rollExpression)]
[h: bonus = dnd5e_RollExpression_getBonus (rollExpression)]
[h, if (bonus == ""): bonus = 0; ""]
[h: baseRoll = diceRolled + "d" + diceSize]

[h: log.debug ("dnd5e_DiceRoller _basicRoll: Rolling " + baseRoll)]
[h: roll = eval (baseRoll)]

[h, if (dnd5e_RollExpression_hasType (rollExpression, "staticRoll")), code: {
	[h: staticRoll = dnd5e_RollExpression_getStaticRoll (rollExpression)]
	[h: roll = staticRoll]
}]

[h: totals = dnd5e_RollExpression_getTotals (rollExpression)]
[h: total = roll + bonus]
[h: totals = json.append (totals, total)]
[h: rolls = dnd5e_RollExpression_getRolls (rollExpression)]
[h: rolls = json.append (rolls, roll)]
[h: rollString = baseRoll + " + " + bonus]

<!-- Build the output message -->
<!-- Simple for now -->
[h: expressionTypes = dnd5e_RollExpression_getExpressionType (rollExpression)]
[h, if (json.type (expressionTypes) == "ARRAY"): expressionTypes = json.toList (expressionTypes); ""]
[h: descriptor = expressionTypes + " Roll"]
[h: output = dnd5e_RollExpression_getOutput (rollExpression)]
<!-- stub this out and lets see how it works if we just write a new output everytime -->
[h: output = ""]
[h, if (output == ""), code: {
	[h: description = dnd5e_RollExpression_getDescription (rollExpression)]
	[h, if (description != ""): description = description + "<br>"; ""]
	[h: damageTypes = dnd5e_RollExpression_getDamageTypes (rollExpression)]
	[h: damageTypeStr = json.toList (damageTypes)]
	[h: name = dnd5e_RollExpression_getName (rollExpression)]
	[h: log.debug ("dnd5e_DiceRoller_basicRoll: damagetTypes = " + damageTypes + "; name = " + name)]
	[h: output = description + name + " " + descriptor + ": " + rollString + " = " + total + " " + damageTypeStr]
}]

[h: rollExpression = json.set (rollExpression, "rolls", rolls,
												"roll", roll,
												"rollString", rollString,
												"total", total,
												"totals", totals,
												"output", output)]
[h: log.debug ("dnd5e_DiceRoller_basicRoll: return = " + rollExpression)]
[h: macro.return = rollExpression]