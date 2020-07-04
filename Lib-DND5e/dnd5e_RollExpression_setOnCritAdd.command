[h: rollExpression = arg (0)]
[h, if (!dnd5e_RollExpression_hasType (rollExpression, "critable")): rollExpression = dnd5e_RollExpression_addType (rollExpression, "critable"); ""]
[h: macro.return = json.set (rollExpression, "onCritAdd", arg (1))]