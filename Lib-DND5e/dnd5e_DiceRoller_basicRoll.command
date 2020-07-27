[h: rollExpression = arg (0)]
[h: diceSize = dnd5e_RollExpression_getDiceSize (rollExpression)]
[h: diceRolled = dnd5e_RollExpression_getDiceRolled (rollExpression)]
[h: bonus = dnd5e_RollExpression_getBonus (rollExpression)]
[h, if(bonus != 0): bonusOutput = if(bonus > 0, " + " + bonus, " - " + (bonus * -1)); bonusOutput = ""]
[h: baseRoll = diceRolled + "d" + diceSize]
[h: tooltipRoll = baseRoll + bonusOutput]

[h: log.debug ("dnd5e_DiceRoller _basicRoll: Rolling " + baseRoll)]
[h: individualRolls = json.rolls("1d" + diceSize, diceRolled)]
[h, if (json.length (individualRolls) == 0): individualRolls = "[0]"; ""]
[h: roll = math.arraySum(individualRolls)]
[h: tooltipDetail = "(" + json.toList(individualRolls, "+") + ")" + bonusOutput]

[h, if (dnd5e_RollExpression_hasType (rollExpression, "staticRoll")), code: {
	[h: staticRoll = dnd5e_RollExpression_getStaticRoll (rollExpression)]
	[h: roll = staticRoll]
	[h: tooltipRoll = roll + bonusOutput]
	[h: tooltipDetail = "Fixed(" + roll + ")" + bonusOutput]
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
[h: rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, "tooltipRoll", tooltipRoll)]												
[h: rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, "tooltipDetail", tooltipDetail)]												
[h: log.debug ("dnd5e_DiceRoller_basicRoll: return = " + rollExpression)]
[h: macro.return = rollExpression]