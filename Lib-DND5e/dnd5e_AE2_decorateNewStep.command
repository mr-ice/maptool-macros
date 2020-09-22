[h: exp = arg(0)]
[h: exp = dnd5e_RollExpression_addTypedDescriptor(exp, "rowId", "row-" + arg(1))]
[h, if (json.length(macro.args) > 2): exp = dnd5e_RollExpression_addTypedDescriptor(exp, "actionType", arg(2)); ""]
[h: macro.return = exp]