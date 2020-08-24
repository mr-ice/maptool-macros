[h: rollExpression = arg (0)]
[h: roll = json.get (rollExpression, "roll")]
[h, if (roll == 1), code: {
	[h: log.debug ("dnd5e_DiceRoller_luckyRoll: Rerolling 1")]
	[h: rollExpression = dnd5e_DiceRoller_basicRoll (rollExpression)]
	[h: description = "<b>Lucky!</b> 1 rerolled: " + 
		json.get (rollExpression, "roll") + "<br>New total: " + json.get (rollExpression, "total")]
	[h: rollExpression = dnd5e_RollExpression_addDescription (rollExpression, description)]
	[h: rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, "lucky", "(lucky reroll)")]
}]
[h: macro.return = rollExpression]