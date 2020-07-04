[h: rollExpressions = arg (0)]

<!-- Property contstant -->
[h: LAST_ROLLED_PROPERTY = "_dnd5e_lastRolledExpression"]

[h: type = json.type (rollExpressions)]
[h, if (type == "OBJECT"): rollExpressions = json.append ("", rollExpressions);""]
<!-- Process each roll and tack on the result of the roll to the expression as:
	"rolls": bracket5,2,1bracket,
	"totals": bracket9,6,5bracket
	-->

[h: rolled = "[]"]

[h, foreach (rollExpression, rollExpressions), code: {
	<!-- Static roll check, for broadcast only. Basic roll will take care of bidness -->
	[h, if (dnd5e_RollExpression_hasType (rollExpression, "staticRoll")), code: {
		[h: staticRoll = dnd5e_RollExpression_getStaticRoll (rollExpression)]
		[h: broadcast ("<font color='red'><b>A roll of " + staticRoll + " has been forced!</b></font> <br>")]
	}]

	[h: totalRolls = json.get (rollExpression, "totalRolls")]
	[h, if (totalRolls == ""): totalRolls = 1; ""]
	[h: rolls =  "[]"]
	[h: totals = "[]"]
	[h: outputs = "[]"]
	[h: allTotal = 0]
	[h, for (i, 0, totalRolls), code: {
		<!-- clear the output, we capture multiple outputs in an array -->
		[h: rollExpression = json.set (rollExpression, "output", "")]
		[h: rollExpression = dnd5e_DiceRoller_basicRoll (rollExpression)]
		[h, if (dnd5e_RollExpression_hasType (rollExpression, "advantagable")): 
				rollExpression = dnd5e_DiceRoller_advantageRoll (rollExpression)]
		[h, if (dnd5e_RollExpression_hasType (rollExpression, "lucky")): 
				rollExpression = dnd5e_DiceRoller_luckyRoll (rollExpression)]
		[h, if (dnd5e_RollExpression_hasType (rollExpression, "critable")): 
				rollExpression = dnd5e_DiceRoller_critableRoll (rollExpression, rolled)]
		[h: output = dnd5e_RollExpression_getOutput (rollExpression)]
		[h: outputs = json.append (outputs, output)]
	}]
	[h: rollExpression = json.set (rollExpression, "outputs", outputs)]
	[h: totals = json.get (rollExpression, "totals")]
	[h: allTotal = 0]
	[h, foreach (totalVal, totals): allTotal = allTotal + totalVal]
	[h: rollExpression = json.set (rollExpression, "allTotal", allTotal)]

	[h: rolled = json.append (rolled, rollExpression)]
}]
[h: tokenId = currentToken()]
[h, if (tokenId != ""): setProperty (LAST_ROLLED_PROPERTY, rolled); ""]
[h: macro.return = rolled]