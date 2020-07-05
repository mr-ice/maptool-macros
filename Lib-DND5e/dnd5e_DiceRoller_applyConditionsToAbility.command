[h: rollExpression = arg (0)]
[h: description = ""]
[h, if (getState ("Dead")), code: {
	[h: description = "You're <font color='red'><b>DEAD</b></font>!<br>"]
	[h: rollExpression = dnd5e_RollExpression_setStaticRoll (rollExpression, 1)]
}]
[h, if (getState ("Poisoned")), code: {
	[h: description = description + "<br>You're <font color='red'><b>Poisoned</b></font>! Applying Disadvantage."]
	[h: rollExpression = dnd5e_RollExpression_setDisadvantage (rollExpression, 1)]
}; {""}]

[h, if (getState ("Exhaustion 1")), code: {
	[h: description = description + "<br>You're <font color='red'><b>Exhausted</b></font>! Applying Disadvantage."]
	[h: rollExpression = dnd5e_RollExpression_setDisadvantage (rollExpression, 1)]
}]


[h, if (getState ("Blinded")):  description = description + "<br>You're <font color='red'><b>Blind</b></font>! You fail if check requires sight."; ""]
[h, if (getState ("Deafened")):  description = description + "<br>You're <font color='red'><b>Deaf</b></font>! You fail if check requires hearing."; ""]
[h, if (getState ("Frightened")): description =  description + "<br>You're <font color='red'><b>Frightened</b></font>! You have disadvantage while the source is within line of sight."; ""]
[h: rollExpression = dnd5e_RollExpression_addDescription (rollExpression, description)]