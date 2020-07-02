[h: rollExpression = arg (0)]
[h: advantage = json.get (rollExpression, "hasAdvantage")]
[h, if (advantage == ""): advantage = 0;""]
[h: disadvantage = json.get (rollExpression, "hasDisadvantage")]
[h, if (disadvantage == ""): disadvantage = 0; ""]
[h: roll1 = rollExpression]
[h: roll1Val = json.get (roll1, "roll")]
[h: roll2 = dnd5e_DiceRoller_basicRoll (rollExpression)]
[h: roll2Val = json.get (roll2, "roll")]
[h: rolls = json.get (roll2, "rolls")]
[h: log.debug ("dnd5e_DiceRoller_advantageRoll: roll1 = " + roll1 + "; roll2 = " + roll2)]
[h: output = json.get (rollExpression, "output")]
<!-- Default value is roll1Value -->
[h: roll = roll1Val]
[h, if (advantage && !disadvantage), code: {
	[h: roll = round (math.max (roll1Val, roll2Val))]
	[h, if (roll2Val > roll1Val): output = json.get (roll2, "output"); ""]
	[h: output = output + "<br>Advantage: " + rolls + ", Actual: " + roll]
	[h: rollExpression = roll2]
	[h: rollExpression = json.set (rollExpression, "rolls", rolls)]
}]
[h, if (!advantage && disadvantage), code: {
	[h: roll = round (math.min (roll1Val, roll2Val))]
	[h, if (roll2Val < roll1Val): output = json.get (roll2, "output"); ""]
	[h: output = output + "<br>Disadvantage: " + rolls + ", Actual: " + roll]
	[h: rollExpression = roll2]
	[h: rollExpression = json.set (rollExpression, "rolls", rolls)]
}]
<!-- roll1 has no extra roll attached in rolls, so return it representing no second roll -->
[h, if (advantage && disadvantage), code: {
	[h: output = output + "<br> Advantage and Disadvantage cancel"]
}]

[h: rollExpression = json.set (rollExpression, "roll", roll, "output", output)]

<!-- roll is set correctly, but total may not overwrite it -->
[h: roll = json.get (rollExpression, "roll")]
[h: bonus = json.get (rollExpression, "bonus")]
[h: rollExpression = json.set (rollExpression, "total", roll + bonus)]
[h: log.debug ("dnd5e_DiceRoller_advantageRoll: return = " + rollExpression)]
[h: macro.return = rollExpression]