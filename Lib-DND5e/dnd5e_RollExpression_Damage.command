[h, if (json.length (macro.args) > 1), code: {
	[rollExpression = dnd5e_RollExpression_parseRoll (arg (1))]
}; {
	[rollExpression = "{}"]
}]
[h: rollExpression = dnd5e_RollExpression_setExpressionType (rollExpression, "Damage")]
[h: rollExpression = dnd5e_RollExpression_setTypes (rollExpression, json.append ("[]",
						dnd5e_Type_Critable(), dnd5e_Type_Damageable()))]
[h, if (json.length (macro.args) > 0): rollExpression = dnd5e_RollExpression_setName (rollExpression, arg (0)); ""]
[h: macro.return = rollExpression]