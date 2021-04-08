[h, if (argCount() > 0): abilityName = arg(0); abilityName = ""]
[h, if (argCount() > 1): bonus = arg(1); bonus= 0]
[h: rollExpression = dnd5e_RollExpression_setDiceSize ("", 20)]
[h: rollExpression = dnd5e_RollExpression_setDiceRolled (rollExpression, 1)]
[h: rollExpression = dnd5e_RollExpression_setExpressionType (rollExpression, "Save")]
[h: rollExpression = dnd5e_RollExpression_addType (rollExpression, 
					dnd5e_Type_Basic(),
					dnd5e_Type_Advantagable())]

[h: rollExpression = dnd5e_RollExpression_setName (rollExpression, abilityName)]
[h: rollExpression = dnd5e_RollExpression_setBonus (rollExpression, bonus)]
[h: macro.return = rollExpression]
