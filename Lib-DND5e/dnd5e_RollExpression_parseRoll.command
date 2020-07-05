[h: rollString = arg (0)]
[h: dIndex = indexOf (rollString, "d")]
[h: diceRolled = substring (rollString, 0, dIndex)]
[h: rollString = substring (rollString, dIndex + 1)]
[h: opIndex = indexOf (rollString, "+")]
[h: bonusIsNeg = 0]
[h, if (opIndex == "-1"), code: {
	[h: opIndex = indexOf (rollString, "-")]
	[h, if (opIndex != "-1"): bonusIsNeg = 1; ""]
}; {""}]
[h, if (opIndex == "-1"), code: {
	[h: diceSize = rollString]
	[h: opIndex = length (rollString) - 1]
}; {
	[h: diceSize = substring (rollString, 0, opIndex)]
}]
[h: diceSize = trim (diceSize)]
[h: rollString = trim (substring (rollString, opIndex + 1))]
[h, if (rollString != ""): bonus = rollString; bonus = 0]
[h, if (bonusIsNeg): bonus = -1 * bonus; ""]
[h: rollExpression = json.set ("", "diceSize", diceSize,
								"diceRolled", diceRolled,
								"bonus", bonus)]
[h: macro.return = rollExpression]