[h: rollExpression = arg (0)]
[h: target = "all"]
[h, if (json.length (macro.args) > 1): target = arg (1)]
[h: inputType = json.type (rollExpression)]
[h, if (inputType == "ARRAY"): rollExpressions = rollExpression; rollExpressions = json.append ("", rollExpression)]
[h: log.debug ("dndb_DiceRoller_roll: rollExpressions = " + rollExpressions)]

<!-- Were a wrapper to the 5e roller. Were just here for the output facet of dice rolling -->
[h: rollExpressions = dnd5e_DiceRoller_roll (rollExpressions)]

<!-- the dice roller has pretty much built the message. Today, this macro doesnt have much
	 to do. Later, we can revisit with the preferences object to better display the messages -->
[h, foreach (rollExpression, rollExpression), code: {
	[h: broadcast (rollExpression, target)]
}]
