[h: rollExpression = arg (0)]
[h: diceSize = json.get (rollExpression, "diceSize")]
[h: diceRolled = json.get (rollExpression, "diceRolled")]
[h: bonus = json.get (rollExpression, "bonus")]
[h, if (bonus == ""): bonus = 0; ""]
[h: baseRoll = diceRolled + "d" + diceSize]

[h: log.debug ("dnd5e_DiceRoller _basicRoll: Rolling " + baseRoll)]
[h: roll = eval (baseRoll)]

[h, if (dnd5e_DiceRoller_hasType (rollExpression, "staticRoll")), code: {
	[h: staticRoll = json.get (rollExpression, "staticRoll")]
	[h: roll = staticRoll]
}]

[h: totals = json.get (rollExpression, "totals")]
[h: total = roll + bonus]
[h: totals = json.append (totals, total)]
[h: rolls = json.get (rollExpression, "rolls")]
[h: rolls = json.append (rolls, roll)]
[h: rollString = baseRoll + " + " + bonus]

<!-- Build the output message -->
<!-- Simple for now -->
[h: expressionTypes = json.get (rollExpression, "expressionTypes")]
[h, if (json.type (expressionTypes) == "ARRAY"): expressionTypes = json.toList (expressionTypes); ""]
[h: descriptor = expressionTypes + " Roll"]
[h: output = json.get (rollExpression, "output")]
<!-- stub this out and lets see how it works if we just write a new output everytime -->
[h: output = ""]
[h, if (output == ""), code: {
	[h: description = json.get (rollExpression, "description")]
	[h, if (description != ""): description = description + "<br>"; ""]
	[h: damageTypes = json.merge ("[]", json.get (rollExpression, "damageTypes"))]
	[h: damageTypeStr = ""]
	[h, foreach (damageType, damageTypes): damageTypeStr = ", " + damageTypeStr + damageType]
	[h, if (json.length (damageTypes) > 0): damageTypeStr = substring (damageTypeStr, 2); ""]
	[h: name = json.get (rollExpression, "name")]
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