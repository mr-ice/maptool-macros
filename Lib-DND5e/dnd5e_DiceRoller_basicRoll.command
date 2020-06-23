[h: rollExpression = arg (0)]
[h: diceSize = json.get (rollExpression, "diceSize")]
[h: diceRolled = json.get (rollExpression, "diceRolled")]
[h: bonus = json.get (rollExpression, "bonus")]
[h: baseRoll = diceRolled + "d" + diceSize]

[h: log.debug ("dnd5e_DiceRoller _basicRoll: Rolling " + baseRoll)]
[h: roll = eval (baseRoll)]

[h, if (dnd5e_DiceRoller_hasType (rollExpression, "staticRoll")), code: {
	[h: staticRoll = json.get (rollExpression, "staticRoll")]
	[h: broadcast ("<font color='red'><b>A staticRoll has been requested! This is a test feature ONLY.</b></font> <br><pre>" + json.indent(rollExpression) + "</pre>", "all")]

	[h: roll = staticRoll]
}]

[h: total = roll + bonus]
[h: totals = json.get (rollExpression, "totals")]
[h: totals = json.append (totals, total)]
[h: rolls = json.get (rollExpression, "rolls")]
[h: rolls = json.append (rolls, roll)]

<!-- Build the output message -->
<!-- Simple for now -->
[h: descriptor = "Roll"]
[h: output = json.get (rollExpression, "output")]
[h, if (output == ""), code: {
	[h: description = json.get (rollExpression, "description")]
	[h, if (description != ""): description = description + "<br>"; ""]
	[h: damageTypes = json.merge ("[]", json.get (rollExpression, "damageTypes"))]
	[h: damageTypeStr = ""]
	[h, foreach (damageType, damageTypes): damageTypeStr = ", " + damageTypeStr + damageType]
	[h, if (json.length (damageTypes) > 0): damageTypeStr = substring (damageTypeStr, 2); ""]
	[h: name = json.get (rollExpression, "name")]
	[h: log.debug ("dnd5e_DiceRoller_basicRoll: damagetTypes = " + damageTypes + "; name = " + name)]
	[h: output = description + name + " " + descriptor + ": " + total + " " + damageTypeStr]
}]

[h: rollExpression = json.set (rollExpression, "rolls", rolls,
												"roll", roll,
												"totals", totals,
												"total", total,
												"output", output)]
[h: log.debug ("dnd5e_DiceRoller_basicRoll: return = " + rollExpression)]
[h: macro.return = rollExpression]