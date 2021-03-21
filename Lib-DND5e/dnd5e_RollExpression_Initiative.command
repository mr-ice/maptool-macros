[h: rollExpression = dnd5e_RollExpression_setDiceSize ("", 20)]
[h, if (argCount() > 0): name = arg(0); name = "Initiative Roll"]
[h: rollExpression = dnd5e_RollExpression_setName (rollExpression, name)]
[h: rollExpression = dnd5e_RollExpression_setDiceRolled (rollExpression, 1)]
[h: rollExpression = dnd5e_RollExpression_setExpressionType (rollExpression, "Initiative")]
[h: rollExpression = dnd5e_RollExpression_addType (rollExpression, 
			dnd5e_Type_Basic(),
			dnd5e_Type_Advantagable())]
[h: rollExpression = json.set (rollExpression, "propertyModifiers", json.append ("", "Initiative"))]
[h, if (argCount() > 1): rollExpression = dnd5e_RollExpression_setBonus (rollExpression, arg(1))]
[h: macro.return = rollExpression]