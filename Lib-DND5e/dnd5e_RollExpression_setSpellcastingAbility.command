[h: re = arg (0)]
[h: ability = arg (1)]
[h: re = json.set (re, "spellcastingAbility", ability)]
[h, if (!dnd5e_RollExpression_hasType (re, "spellcastingAbility")): 
	re = dnd5e_RollExpression_addType (re, dnd5e_Type_SpellcastingAbility()); ""]
[h: macro.return = re]