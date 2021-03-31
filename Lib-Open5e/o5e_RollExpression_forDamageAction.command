[h: actionObj = arg (0)]

[h: o5e_Constants (getMacroName())]
[h: damageRollObj = json.get (actionObj, "damageRollObj")]
[h: log.debug (CATEGORY + "## damageRollObj = " + damageRollObj)]
[h, if (encode (damageRollObj) == ""): return (0, ""); ""]

[h: damageBonus = json.get (damageRollObj, "bonus")]
[h: damageDiceRolled = json.get (damageRollObj, "diceRolled")]
[h: damageDiceSize = json.get (damageRollObj, "diceSize")]
[h: damageType = json.get (actionObj, "damageType")]

[h: attackClass = json.get (actionObj, "attackClass")]
[h: saveDC = json.get (actionObj, "saveDC")]
[h, if (saveDC == ""): saveDC = 0]
[h: damageExpressions = "[]"]
[h, if (saveDC > 0), code: {
	[saveExpression = o5e_RollExpression_forSave (actionobj)]
	[damageExpressions = json.append (damageExpressions, saveExpression)]
	[damageExpression = dnd5e_RollExpression_SaveDamage ()]
    [damageExpression = dnd5e_RollExpression_setSaveEffect (damageExpression, "none")]
}; {
	[damageExpression = dnd5e_RollExpression_Damage ()]
	[if (attackClass == "Weapon"):
		damageExpression = dnd5e_RollExpression_addType (damageExpression, dnd5e_Type_Weapon())]
}]
[h: damageExpression = dnd5e_RollExpression_setDiceRolled (damageExpression, damageDiceRolled)]
[h: damageExpression = dnd5e_RollExpression_setDiceSize (damageExpression, damageDiceSize)]
[h: damageExpression = dnd5e_RollExpression_setBonus (damageExpression, damageBonus)]
[h: damageExpression = dnd5e_RollExpression_addDamageType (damageExpression, damageType)]
[h: damageExpressions = json.append (damageExpressions, damageExpression)]
[h: macro.return = damageExpressions]