[h, if (json.length (macro.args) > 0): name = arg (0); name = ""]
[h: rollExpression = dnd5e_RollExpression_setName ("", name)]
[h: rollExpression = dnd5e_RollExpression_setExpressionType (rollExpression, "Save Effect")]
<!-- Not Unrollable, but not basic, either -->
[h: rollExpression = dnd5e_RollExpression_addType (rollExpression, dnd5e_Type_Saveable())]
[h: macro.return = rollExpression]