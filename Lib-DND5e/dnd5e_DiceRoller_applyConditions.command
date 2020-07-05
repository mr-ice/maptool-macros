[h: rollExpression = arg (0)]
[h: isImpersonating = currentToken ()]
[h, if (isImpersonating != ""), code: {
	[h, if (dnd5e_RollExpression_hasType (rollExpression, "Attack")): 
			rollExpression = dnd5e_DiceRoller_applyConditionsToAttack (rollExpression); ""]
	[h, if (dnd5e_RollExpression_hasType (rollExpression, "Save")): 
			rollExpression = dnd5e_DiceRoller_applyConditionsToSave (rollExpression); ""]
	[h, if (dnd5e_RollExpression_hasType (rollExpression, "Ability")): 
			rollExpression = dnd5e_DiceRoller_applyConditionsToAbility (rollExpression); ""]
}]
[h: macro.return = rollExpression]