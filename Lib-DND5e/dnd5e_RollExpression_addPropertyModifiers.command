[h: re = arg(0)]
[h: currentMods = dnd5e_RollExpression_getPropertyModifiers (re)]
[h: currentMods = json.append (currentMods, arg (1))]
[h: macro.return = dnd5e_RollExpression_setPropertyModifiers (re, currentMods)]