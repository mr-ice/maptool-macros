[h: rollExpression = arg(0)]
[h: rollExpression = dnd5e_RollExpression_addType (rollExpression, dnd5e_Type_Children())]
[h: macro.return = json.set (rollExpression, "expressions", arg (1))]