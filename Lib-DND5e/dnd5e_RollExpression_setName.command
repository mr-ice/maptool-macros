[h: re = arg (0)]
[h: name = arg(1)]
[h: re = json.set (re, "name", encode (name)))]
[h: re = dnd5e_RollExpression_addTypedDescriptor (re, "actionName", name)]
[h: macro.return = re]