[h, if (argCount() > 0): name = arg (0); name = "Spell"]
[h, if (argCount() > 1): ability = arg (1); ability = 5]
[h: re = dnd5e_RollExpression_Attack (name)]
[h: re = dnd5e_RollExpression_setSpellcastingAbility (re, ability)]
[h: macro.return = re]