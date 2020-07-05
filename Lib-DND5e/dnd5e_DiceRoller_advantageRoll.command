[h: rollExpression = arg (0)]
[h: advantage = dnd5e_RollExpression_hasAdvantage (rollExpression)]
[h: disadvantage = dnd5e_RollExpression_hasDisadvantage (rollExpression)]
[h: roll1 = rollExpression]
[h: roll1Val = json.get (roll1, "roll")]
[h: roll2 = dnd5e_DiceRoller_basicRoll (rollExpression)]
[h: roll2Val = json.get (roll2, "roll")]
[h: rolls = json.get (roll2, "rolls")]
[h: log.debug ("dnd5e_DiceRoller_advantageRoll: roll1 = " + roll1 + "; roll2 = " + roll2)]
[h: description = ""]
<!-- Default value is roll1Value -->
[h: roll = roll1Val]
[h, if (advantage && !disadvantage), code: {
	[h: roll = round (math.max (roll1Val, roll2Val))]
	[h, if (roll2Val > roll1Val): output = dnd5e_RollExpression_getOutput (roll2); ""]
	[h: description = "<b>Advantage:</b> " + rolls + ", Actual: " + roll]
	[h: rollExpression = roll2]
	[h: rollExpression = json.set (rollExpression, "rolls", rolls)]
}]
[h, if (!advantage && disadvantage), code: {
	[h: roll = round (math.min (roll1Val, roll2Val))]
	[h, if (roll2Val < roll1Val): output = dnd5e_RollExpression_getOutput (roll2); ""]
	[h: description = "<b>Disadvantage:</b> " + rolls + ", Actual: " + roll]
	[h: rollExpression = roll2]
	[h: rollExpression = json.set (rollExpression, "rolls", rolls)]
}]
<!-- roll1 has no extra roll attached in rolls, so return it representing no second roll -->
[h, if (advantage && disadvantage), code: {
	[h: description = "Advantage and Disadvantage cancel"]
}]

[h, if (description != ""): rollExpression = dnd5e_RollExpression_addDescription (rollExpression, description); ""]
[h: rollExpression = json.set (rollExpression, "roll", roll)]

<!-- roll is set correctly, but total may not overwrite it -->
[h: roll = dnd5e_RollExpression_getRoll (rollExpression)]
[h: bonus = dnd5e_RollExpression_getBonus (rollExpression)]
[h: rollExpression = json.set (rollExpression, "total", roll + bonus)]
[h: log.debug ("dnd5e_DiceRoller_advantageRoll: return = " + rollExpression)]
[h: macro.return = rollExpression]