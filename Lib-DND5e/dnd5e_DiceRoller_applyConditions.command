[h: rollExpression = arg (0)]
[h: isImpersonating = currentToken ()]
[h, if (isImpersonating != ""), code: {
	[h: disableNPCConditions = dnd5e_Preferences_getPreference ("disableNPCRollExpressionConditions")]
	[h, if (disableNPCConditions && isNPC()): return (0, rollExpression); ""]
	[h: disablePlayerConditions = dnd5e_Preferences_getPreference ("disablePCRollExpressionConditions")]
	[h, if (disablePlayerConditions && isPC()): return (0, rollExpression); ""]
	[h, if (dnd5e_RollExpression_hasType (rollExpression, "Attack")): 
			rollExpression = dnd5e_DiceRoller_applyConditionsToAttack (rollExpression); ""]
	[h, if (dnd5e_RollExpression_hasType (rollExpression, "Save")): 
			rollExpression = dnd5e_DiceRoller_applyConditionsToSave (rollExpression); ""]
	[h, if (dnd5e_RollExpression_hasType (rollExpression, "Ability")): 
			rollExpression = dnd5e_DiceRoller_applyConditionsToAbility (rollExpression); ""]
	[h, if (dnd5e_RollExpression_hasType (rollExpression, "Initiative")):
			rollExpression = dnd5e_DiceRoller_applyConditionsToInitiative (rollExpression)]
}]
[h: macro.return = rollExpression]