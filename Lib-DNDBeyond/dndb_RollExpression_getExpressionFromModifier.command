[h: grantedModifier = arg (0)]
[h: dice = json.get (grantedModifier, "dice")]
[h: rollExpression = "{}"]
[h, if (!json.isEmpty (dice)), code: {
	[rollExpression = dnd5e_RollExpression_setDiceRolled (rollExpression, json.get (dice, "diceCount"))]
	[rollExpression = dnd5e_RollExpression_setDiceSize (rollExpression, json.get (dice, "diceValue"))]
}; {""}]
[h: rollExpression = dnd5e_RollExpression_setBonus (rollExpression, json.get (grantedModifier, "value"))]
[h: type = json.get (grantedModifier, "type")]
[h, switch (type), code: 
	case "damage": {
		[rollExpression = json.merge (dnd5e_RollExpression_Damage(), rollExpression)]
		[rollExpression = dnd5e_RollExpression_addDamageType (rollExpression, json.get (grantedModifier, "subType"))]
	};
	default: {
		rollExpression = dnd5e_RollExpression_setExpressionType (rollExpression, "None")
	}
]

[h: macro.return = rollExpression]