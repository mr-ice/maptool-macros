[h: reportResults = "{}"]
[h, for (i, 1, 10), code: {
	[re = dnd5e_RollExpression_setAdvantage (dnd5e_RollExpression_Attack(), 1)]
	[rolled = json.get (dnd5e_DiceRoller_roll(re), 0)]
	[rollFinal = json.get (rolled, "roll")]
	[rolls = json.get (rolled, "rolls")]
	[if (json.length (rolls) != 2): reportResults = json.set (reportResults, "Advantage Roll - rolls size " + i, "Did not get two rolls: " + rolls)]
	[reportResults = json.merge (reportResults, dnd5et_Util_assertEqual (math.arrayMax (rolls), rollFinal, "Advantage Roll " + i))]
}]

[h, for (i, 1, 10), code: {
	[re = dnd5e_RollExpression_setDisadvantage (dnd5e_RollExpression_Attack(), 1)]
	[rolled = json.get (dnd5e_DiceRoller_roll(re), 0)]
	[rollFinal = json.get (rolled, "roll")]
	[rolls = json.get (rolled, "rolls")]
	[if (json.length (rolls) != 2): reportResults = json.set (reportResults, "Disadvantage Roll - rolls size " + i, "Did not get two rolls: " + rolls)]
	[reportResults = json.merge (reportResults, dnd5et_Util_assertEqual (math.arrayMin (rolls), rollFinal, "Disadvantage Roll " + i))]
}]
[h: macro.return = reportResults]