[h: rollExpression = arg (0)]
[h: log.debug (getMacroName() + ": rolling " + rollExpression)]
[h: fromCritCandidateExpressions = json.get (rollExpression, "rolledExpressions")]

<!-- all incoming rollExpressions are assumed to already have been rolled. Only roll rollExpression again 
     if its onCritFrom expression was a natural 20 -->

[h: critCandidate = ""]
[h, foreach (candidate, fromCritCandidateExpressions), code: {
	[h, if (dnd5e_RollExpression_hasType (candidate, "Attack")): critCandidate = candidate; ""]
}]
[h, if (json.type (critCandidate) == "OBJECT"): roll = dnd5e_RollExpression_getRoll (critCandidate); roll = 0]

[h, if (roll == 20), code: {
	<!-- critical! -->
	<!-- Sniff onCritAdd property to determine addtional dice. If not found, assume the same amount
	     as currently set for diceRolled -->
	[h: onCritAdd = dnd5e_RollExpression_getOnCritAdd (rollExpression)]
	[h, if (onCritAdd == ""): onCritAdd = dnd5e_RollExpression_getDiceRolled (rollExpression)]
	[h: diceSize = dnd5e_RollExpression_getDiceSize (rollExpression)]
	[h: critRoll = dnd5e_RollExpression_Damage("Critical Damage", 
						onCritAdd + "d" + diceSize)]
	[h: critRoll = dnd5e_RollExpression_setExpressionType (critRoll, "Critical Damage")]

	[h: critRoll = dnd5e_RollExpression_setDiceRolled (critRoll, onCritAdd)]
	[h: critRoll = json.get (dnd5e_DiceRoller_roll (critRoll), 0)]
	[h: rollExpression = dnd5e_RollExpression_addExpression (rollExpression, critRoll)]
	[h: rollExpression = dnd5e_RollExpression_mergeChildren (rollExpression)]
	<!-- Just replace whats currently on output. We have better information -->

	[h: rollExpression = dnd5e_RollExpression_addDescription (rollExpression, "<font color='red'><b><i>CRITICAL </i></b></font> ")] 
	[h: rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, "critable", 1)] 
}]
[h: macro.return = rollExpression]
