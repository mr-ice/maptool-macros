[h: actionName = arg (0)]
[h: actionObj = arg (1)]
[h, if (json.length (macro.args) > 2): advDisadv = arg (2); advDisadv = "none"]
[h: o5e_Constants (getMacroName())]

[h: attackClass = json.get (actionObj, "attackClass")]

[h, if (attackClass == "Weapon"): 
	attackExpression = o5e_RollExpression_forWeaponAttack (actionName, actionObj, advDisadv);
	attackExpression = o5e_RollExpression_forSpellAttack (actionName, actionObj, advDisadv)]
[h: macro.return = attackExpression]