[h: rollExpressions = arg (0)]
[h, if (json.length (macro.args) > 1): totalMultiplier = arg (1); totalMultiplier = 1]

<!-- Property contstant -->
[h: LAST_ROLLED_PROPERTY = "_dnd5e_lastRolledExpression"]

[h: type = json.type (rollExpressions)]
[h, if (type == "OBJECT"): rollExpressions = json.append ("", rollExpressions);""]
[h: log.debug ("rollExpressions: " + json.indent (rollExpressions))]
[h: rolled = "[]"]
[h, foreach (rollExpression, rollExpressions), code: {
	[h: log.debug ("rollExpression: " + rollExpression)]
	<!-- Check conditions -->
	[h: rollExpression = dnd5e_DiceRoller_applyConditions (rollExpression)]
	<!-- Static roll check, for broadcast only. Basic roll will take care of bidness -->
	[h, if (dnd5e_RollExpression_hasType (rollExpression, "staticRoll")), code: {
		[h: staticRoll = dnd5e_RollExpression_getStaticRoll (rollExpression)]
		[h: broadcast ("<font color='red'><b>A roll of " + staticRoll + " has been forced!</b></font> <br>")]
	}]

	[h: totalRolls = json.get (rollExpression, "totalRolls")]
	[h, if (totalRolls == ""): totalRolls = totalMultiplier; totalRolls = totalRolls * totalMultiplier]
	[h: rolls =  "[]"]
	[h: totals = "[]"]
	[h: outputs = "[]"]
	[h: allTotal = 0]

	[h: children = dnd5e_RollExpression_getExpressions (rollExpression)]
	[h, if (!json.isEmpty (children)), code: {
		<!-- We have to roll the children in multiples of the parents totalRolls -->
		[children = dnd5e_DiceRoller_roll (children, totalRolls)]
		[rollExpression = dnd5e_RollExpression_setExpressions (rollExpression, children)]
	}; {""}]
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
		[h, if (json.length (children) > 0): rollExpression = dnd5e_RollExpression_mergeChildren (rollExpression); ""]
		[h: rollExpression = dnd5e_DiceRoller_saveDamageRoll (rollExpression)]
		[h: rollExpression = dnd5e_DiceRoller_saveEffectRoll (rollExpression)]
		[h: rollExpression = dnd5e_RollExpression_buildOutput (rollExpression)]
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
[h, if (dnd5e_Preferences_getPreference ("showRollExpressions")): broadcast ("<pre>" + json.indent (rolled) + "</pre>", "self"); ""]
[h: tokenId = currentToken()]
[h, if (tokenId != ""): setProperty (LAST_ROLLED_PROPERTY, rolled); ""]
[h: macro.return = rolled]