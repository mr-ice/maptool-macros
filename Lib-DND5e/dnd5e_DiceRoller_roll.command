[h: rollExpressions = arg (0)]
[h, if (json.length (macro.args) > 1): totalMultiplier = arg (1); totalMultiplier = 1]
[h, if (json.length (macro.args) > 2): targeted = arg (2); targeted = 0]

<!-- Property contstant -->
[h: LAST_ROLLED_PROPERTY = "_dnd5e_lastRolledExpression"]

[h: type = json.type (rollExpressions)]
[h, if (type == "OBJECT"): rollExpressions = json.append ("", rollExpressions);""]
[h: log.debug ("rollExpressions: " + json.indent (rollExpressions))]
[h: rolled = "[]"]
[h, foreach (rollExpression, rollExpressions), code: {
	[h: unrollable = dnd5e_RollExpression_hasType(rollExpression, "unrollable")]
	[h: targetRoll = dnd5e_RollExpression_hasType(rollExpression, "target")]
	[h, if (!unrollable && targeted == targetRoll): rollExpression = dnd5e_DiceRoller_rollOneExpression(rollExpression, totalMultiplier, rolled)]
	[h: rolled = json.append (rolled, rollExpression)]
}]
[h, if (dnd5e_Preferences_getPreference ("showRollExpressions")): broadcast ("<pre>" + json.indent (rolled) + "</pre>", "self"); ""]
[h: tokenId = currentToken()]
[h, if (tokenId != ""): setProperty (LAST_ROLLED_PROPERTY, rolled); ""]
[h: macro.return = rolled]