[h: rollExpression = dnd5e_RollExpression_setDiceSize ("", 20)]
[h: rollExpression = dnd5e_RollExpression_setDiceRolled (rollExpression, 1)]
[h: rollExpression = dnd5e_RollExpression_setExpressionType (rollExpression, "Save")]
[h: rollExpression = dnd5e_RollExpression_addType (rollExpression, 
					dnd5e_Type_Basic(),
					dnd5e_Type_Advantagable())]
[h, if (json.length (macro.args) > 0): rollExpression = dnd5e_RollExpression_setName (rollExpression, arg (0)); ""]
[h, if (json.length (macro.args) > 1): rollExpression = dnd5e_RollExpression_setBonus (rollExpression, 
			if(isNumber(arg(1)), arg(1), 0)); ""]
[h: macro.return = rollExpression]
