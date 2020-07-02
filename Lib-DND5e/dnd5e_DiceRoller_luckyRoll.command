[h: rollExpression = arg (0)]
[h: roll = json.get (rollExpression, "roll")]
[h, if (roll == 1), code: {
	[h: log.debug ("dnd5e_DiceRoller_luckyRoll: Rerolling 1")]
	[h: rollExpression = dnd5e_DiceRoller_basicRoll (rollExpression)]
	[h: output = json.get (rollExpression, "output") + "<br>Lucky! 1 rerolled: " + 
		json.get (rollExpression, "roll") + "<br>New total: " + json.get (rollExpression, "total")]
	[h: rollExpression = json.set (rollExpression, "output", output)]
}]
[h: macro.return = rollExpression]