[h: rollExpression = arg (0)]
[h: description = ""]

[h, if (getState ("Dead")), code: {
	[h: description = description + "<br><br>You're <font color='red'><b>DEAD</b></font>!<br><br>"]
	[h: rollExpression = dnd5e_RollExpression_setStaticRoll (rollExpression, 1)]
}]

[h: disadvantageStates = json.append ("", "Blinded", "Poisoned", "Prone", "Restrained", "Exhaustion 3")]

[h, foreach (state, disadvantageStates), code: {
	[h, if (getState (state)), code: {
		[h: description = description + "<br>You're <font color='red'><b>" + state + "</b></font>! Applying Disadvantage."]
		[h: rollExpression = dnd5e_RollExpression_setDisadvantage (rollExpression, 1)]
	}; {""}]
}]

[h, if (getState ("Charmed")): description + "<br>You're <font color='red'><b>Charmed</b></font>! You cannot attack or target the charmer with harmful effects."; ""]
[h, if (getState ("Frightened")): description =  description + "<br>You're <font color='red'><b>Frightened</b></font>! You have disadvantage while the source is within line of sight."; ""]
[h, if (getState ("Invisible")), code: {
	[h: description =  description + "<br>You're <font color='blue'><b>Invisible</b></font>! Applying Advantage."]
	[h: rollExpression = dnd5e_RollExpression_setAdvantage (rollExpression, 1)]
}; {""}]
[h, if (getState ("Blessed")), code: {
	[h: blessed = dnd5e_RollExpression_BuildBless ()]
	[h: rollExpression = dnd5e_RollExpression_addExpression (rollExpression, blessed)]
}]

[h: rollExpression = dnd5e_RollExpression_addDescription (rollExpression, description)]
[h: macro.return = rollExpression]