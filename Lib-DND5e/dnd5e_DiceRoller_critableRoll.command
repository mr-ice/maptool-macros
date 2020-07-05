[h: rollExpression = arg (0)]
[h: fromCritCandidateExpressions = arg (1)]

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
	[h: originalDiceRolled = dnd5e_RollExpression_getDiceRolled (rollExpression)]
	[h: critRoll = dnd5e_RollExpression_setDiceRolled (rollExpression, onCritAdd + originalDiceRolled)]
	[h: critRoll = dnd5e_DiceRoller_basicRoll (critRoll)]
	<!-- Just replace whats currently on output. We have better information -->
	[h: damageString = dnd5e_RollExpression_getDamageTypes (critRoll)]
	[h: name = dnd5e_RollExpression_getName (critRoll)]
	[h: description = "<font color='red'><b><i>CRITICAL </i></b></font> "]
	[h: rollExpression = dnd5e_RollExpression_addDescription (critRoll, description)] 
}]
[h: macro.return = rollExpression]