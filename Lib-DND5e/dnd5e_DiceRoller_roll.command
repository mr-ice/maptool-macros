[h: rollExpressions = arg (0)]
[h: type = json.type (rollExpressions)]
[h, if (type == "OBJECT"): rollExpressions = json.append ("", rollExpressions);""]
<!-- Process each roll and tack on the result of the roll to the expression as:
	"rolls": bracket5,2,1bracket,
	"totals": bracket9,6,5bracket
	-->

[h: rolled = "[]"]

[h, foreach (rollExpression, rollExpressions), code: {

	[h: totalRolls = json.get (rollExpression, "totalRolls")]
	[h, if (totalRolls == ""): totalRolls = 1; ""]
	[h: rolls =  "[]"]
	[h: subtotals = "[]"]
	[h: total = ""]
	[h, for (i, 0, totalRolls), code: {
		[h: rollExpression = dnd5e_DiceRoller_basicRoll (rollExpression)]
		[h, if (dnd5e_DiceRoller_hasType (rollExpression, "advantagable")): rollExpression = dnd5e_DiceRoller_advantageRoll (rollExpression)]
		[h, if (dnd5e_DiceRoller_hasType (rollExpression, "lucky")): rollExpression = dnd5e_DiceRoller_luckyRoll (rollExpression)]
		[h, if (dnd5e_DiceRoller_hasType (rollExpression, "critable")): rollExpression = dnd5e_DiceRoller_critableRoll (rollExpression, rolled)]
	}]

	
	[h: rolled = json.append (rolled, rollExpression)]
}]

[h: macro.return = rolled]