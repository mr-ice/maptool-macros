[h: rollExpressions = arg (0)]
[h, if (json.length (macro.args) > 1): totalMultiplier = arg (1); totalMultiplier = 1]
[h, if (json.length (macro.args) > 2): targeted = arg (2); targeted = 0]

[h: log.debug (getMacroName() + ": rolling " + rollExpressions)]
<!-- Property contstant -->
[h: LAST_ROLLED_PROPERTY = "_dnd5e_lastRolledExpression"]

<!-- We ambiguously allow a snigle JSON object or an array of objects. This coerces it to an array -->
[h: type = json.type (rollExpressions)]
[h, if (type == "OBJECT"): rollExpressions = json.append ("", rollExpressions)]
[h: rolled = "[]"]
[h, foreach (rollExpression, rollExpressions), code: {
	<!-- The current RollExpression needs to have context of whats been rolled so far -->
	[rollExpression = json.set (rollExpression, "rolledExpressions", rolled)]
	[h: targetRoll = dnd5e_RollExpression_hasType(rollExpression, "target")]
	[h, if (targeted == targetRoll): rollExpression = dnd5e_DiceRoller_rollOneExpression(rollExpression, totalMultiplier, rolled)]
	<!-- prune the rolled list to save unneccessary data build up -->
	[rollExpression = json.remove (rollExpression, "rolledExpressions")]
	[h: rolled = json.append (rolled, rollExpression)]
}]

[h: tokenId = currentToken()]
[h, if (tokenId != ""): setProperty (LAST_ROLLED_PROPERTY, rolled)]

[h: rolled = dnd5e_SavedAttacks_push (rolled)]
[h: macro.return = rolled]