[h: rollExpression = arg (0)]
[h, if (!dnd5e_RollExpression_hasType (rollExpression, "staticRoll")): rollExpression = dnd5e_RollExpression_addType (rollExpression, "staticRoll"); ""]
[h: rollExpression = json.set (rollExpression, "staticRoll", arg (1))]
[h: macro.return = rollExpression]