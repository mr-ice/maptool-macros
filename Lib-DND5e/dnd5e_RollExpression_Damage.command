[h: rollExpression = dnd5e_RollExpression_setDiceSize ("", 6)]
[h: rollExpression = dnd5e_RollExpression_setDiceRolled (rollExpression, 1)]
[h: rollExpression = dnd5e_RollExpression_setExpressionType (rollExpression, "Damage")]
[h, if (json.length (macro.args) > 0): rollExpression = dnd5e_RollExpression_setName (rollExpression, arg (0)); ""]
[h: macro.return = rollExpression]