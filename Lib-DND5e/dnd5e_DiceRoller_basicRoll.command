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
[h: rollString = dnd5e_RollExpression_getRollString (rollExpression)]

[h: rollExpression = json.set (rollExpression, "rolls", rolls,
												"roll", roll,
												"rollString", rollString,
												"total", total,
												"totals", totals)]
[h: log.debug ("dnd5e_DiceRoller_basicRoll: return = " + rollExpression)]
[h: macro.return = rollExpression]