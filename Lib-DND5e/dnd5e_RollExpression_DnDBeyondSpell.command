[h, if (json.length (macro.args) > 0): name = arg (0); name = ""]
[h: rollExpression = dnd5e_RollExpression_setName ("", name)]
[h: rollExpression = dnd5e_RollExpression_setExpressionType (rollExpression, "DnDBeyond Spell")]
[h: macro.return = rollExpression]