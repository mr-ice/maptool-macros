[h: rollExpression = arg (0)]
[h: fromCritCandidateExpressions = arg (1)]

<!-- all incoming rollExpressions are assumed to already have been rolled. Only roll rollExpression again 
     if its onCritFrom expression was a natural 20 -->

[h: critCandidate = ""]
[h, foreach (candidate, fromCritCandidateExpressions), code: {
	[h, if (dnd5e_DiceRoller_hasType (candidate, "Attack")): critCandidate = candidate; ""]
}]
[h, if (json.type (critCandidate) == "OBJECT"): roll = json.get (critCandidate, "roll"); roll = 0]

[h, if (roll == 20), code: {
	<!-- critical! -->
	<!-- Sniff onCritAdd property to determine addtional dice. If not found, assume the same amount
	     as currently set for diceRolled -->
	[h: onCritAdd = json.get (rollExpression, "onCritAdd")]
	[h: originalDiceRolled = json.get (rollExpression, "diceRolled")]
	[h, if (onCritAdd == ""): onCritAdd = originalDiceRolled; ""]
	[h: critRoll = json.set (rollExpression, "diceRolled", onCritAdd)]
	[h: critRoll = dnd5e_DiceRoller_basicRoll (critRoll)]
	<!-- critRoll has the totals ledger, so use that and just add the totals together -->
	[h: total = 0]
	[h, foreach (subTotal, json.get (critRoll, "totals")): total = total + subTotal]
	<!-- Just replace whats currently on output. We have better information -->
	[h: damageTypes = json.get (critRoll, "damageTypes")]
	[h: damageString = json.toList (damageTypes)]
	[h: name = json.get (critRoll, "name")]
	[h: description = json.get (critRoll, "description")]
	[h: output = description + "<br><font color='red'><b>CRITICAL </b></font> " + name + " Roll: " + total + " " + damageString] 
	[h: rollExpression = json.set (critRoll, "total", total, "output", output)]
}]
[h: macro.return = rollExpression]