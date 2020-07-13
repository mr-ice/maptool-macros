[h: rollString = arg (0)]
[h, if (json.length (macro.args) > 1): rollExpression = arg (1); rollExpression = "{}"]
[h: dIndex = indexOf (rollString, "d")]
[h, if (dIndex > -1), code: {
	[h: diceRolled = substring (rollString, 0, dIndex)]
}; {
	[h: diceRolled = 0]
}]
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
[h, if (diceSize == ""): diceSize = 0; ""]

[h: rollString = trim (substring (rollString, opIndex + 1))]
[h, if (rollString != ""): bonus = rollString; bonus = 0]
[h, if (bonusIsNeg): bonus = -1 * bonus; ""]

[h, if (diceRolled == 0), code: {
	<!-- in this situation, the only thing that was passed in was the bonus, if anything at all -->
	[h: bonus = diceSize]
	[h: diceSize = 0]
}; {""}]
[h: rollExpression = json.set (rollExpression, "diceSize", diceSize,
								"diceRolled", diceRolled,
								"bonus", bonus)]
[h: macro.return = rollExpression]