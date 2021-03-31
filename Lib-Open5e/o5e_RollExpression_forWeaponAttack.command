[h: actionName = arg (0)]
[h: actionObj = arg (1)]
[h, if (json.length (macro.args) > 2): advDisadv = arg (2); advDisadv = "none"]
[h: o5e_Constants (getMacroName())]

[h: weaponType = json.get (actionObj, "weaponType")]
[h: attackBonus = json.get (actionObj, "attackBonus")]
[h: profValue = getProperty ("Proficiency")]

[h: log.debug (CATEGORY + "## attackBonus = " + attackBonus + "; weaponType = " + weaponType)]
[h: attackExpression = dnd5e_RollExpression_WeaponAttack (actionName, 1, attackBonus, weaponType)]
[h: attackExpression = dnd5e_RollExpression_setAdvantageDisadvantage (attackExpression, advDisadv)]
[h: rollExpressions = json.append ("", attackExpression)]
[h: damageExpressions = o5e_RollExpression_forDamageAction (actionObj, attackExpression)]
[h: rollExpressions = json.merge (rollExpressions, damageExpressions)]

[h: extraObjs = json.get (actionObj, "extraDamage")]
[h, foreach (extraObj, extraObjs), code: {
	[extDamageExpressions = o5e_RollExpression_forDamageAction (extraObj)]
	[rollExpressions = json.merge (rollExpressions, extDamageExpressions)]
}]

[h: macro.return = rollExpressions]