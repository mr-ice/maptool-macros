[h: rollExpression = arg (0)]
[h: description = ""]

[h, if (getState ("Dead")), code: {
	[h: description = description + "<br><br>You're <font color='red'><b>DEAD</b></font>!"]
	[h: rollExpression = dnd5e_RollExpression_setStaticRoll (rollExpression, 1)]
}]

[h: saveName = dnd5e_RollExpression_getName (rollExpression)]

<!-- Fails str and dex -->
[h: fuckedStates = json.append ("", "Paralyzed", "Petrified", "Stunned", "Unconscious")]
[h: isFucked = 0]
[h: fuckedMsg = ""]
[h, foreach (fuckedState, fuckedStates), code: {
	[h: theState = getState (fuckedState)]
	[h, if (theState > 0), code: {
		[h: isFucked = isFucked + 1]
		[h: fuckedMsg = fuckedMsg + "You're <font color='red'><b>" + fuckedState + "</b></font>!<br>"]
	}]
}]
<!-- disadv on dex -->
[h: isRestrained = getState ("Restrained")]

<!-- Auto fails -->
[h, if ( (saveName == "Strength" || saveName == "Dexterity") && isFucked > 0), code: {
	[h: description = description + "<br>" + fuckedMsg +
			"<b>You automatically <font color='red'><i>FAIL</i></font>!!<b><br>"]
	[h: rollExpression = dnd5e_RollExpression_setStaticRoll (rollExpression, 1)]
}; {}]

[h, if (saveName == "Dexterity" && isRestrained > 0), code: {
	[h: description = description + "<br>You're <font color='red'><b>Restrained</b></font>! Applying Disadvantage."]
	[h: rollExpression = dnd5e_RollExpression_setDisadvantage (rollExpression, 1)]
}; {}]

[h, if (getState ("Exhaustion 3")), code: {
	[h: description = description + "<br>You're <font color='red'><b>Exhaustion 3</b></font>! Applying Disadvantage."]
	[h: rollExpression = dnd5e_RollExpression_setDisadvantage (rollExpression, 1)]
}]

[h, if (getState ("Blessed")), code: {
	[h: blessed = dnd5e_RollExpression_BuildBless ()]
	[h: rollExpression = dnd5e_RollExpression_addExpression (rollExpression, blessed)]
}]

[h: rollExpression = dnd5e_RollExpression_addDescription (rollExpression, description)]
[h: macro.return = rollExpression]