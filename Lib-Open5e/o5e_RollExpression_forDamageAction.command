[h: actionObj = arg (0)]
[h, if (json.length (macro.args) > 1):  attackExpression = arg (1); attackExpression = "{}"]
[h: o5e_Constants (getMacroName())]
[h: damageRollObj = json.get (actionObj, "damageRollObj")]
[h: log.debug (CATEGORY + "## damageRollObj = " + damageRollObj)]
[h, if (encode (damageRollObj) == ""): return (0, ""); ""]
<!-- 0.16 - Were going to ignore this value right now, because we always have. In a future
	version, well come back and use this as a basis for calculating an actual bonus, should
	a monster actually have one. When we get to that point, hopefully well be at a point
	where we can distinguish a monster toons version and know if the damageBonus is legit, or
	the "0 bug" thats in 0.15 (where monster toons are unversioned) -->
[h: damageBonus = json.get (damageRollObj, "bonus")]
[h: damageDiceRolled = json.get (damageRollObj, "diceRolled")]
[h: damageDiceSize = json.get (damageRollObj, "diceSize")]
[h: damageType = json.get (actionObj, "damageType")]

[h: isWeapon = if (dnd5e_RollExpression_hasType (attackExpression, "weapon"), 1, 0)]
[h, if (isWeapon): weaponType = dnd5e_RollExpression_getWeaponType (attackExpression); weaponType = -1]
[h: log.debug (CATEGORY + "## isWeapon = " + isWeapon + "; weaponType = " + weaponType)]

<!-- someday, use these cases
	case 0: damageBonus = damageBonus - getProperty ("bonus.attack.melee");
	case 1: damageBonus = damageBonus - getProperty ("bonus.attack.ranged");
	case 2: damageBonus = damageBonus - getProperty ("bonus.attack.finesse");
-->
<!-- for now, there is no "bonus" -->
[h: damageBonus = 0]

[h: log.debug (CATEGORY + "## damageBonus = " + damageBonus)]
[h: saveDC = json.get (actionObj, "saveDC")]
[h, if (!isNumber (saveDC)): saveDC = 0; ""]
[h: damageExpressions = "[]"]
[h, if (saveDC > 0), code: {
	[saveExpression = o5e_RollExpression_forSave (actionobj)]
	[damageExpressions = json.append (damageExpressions, saveExpression)]
	[damageExpression = dnd5e_RollExpression_SaveDamage ()]
    [damageExpression = dnd5e_RollExpression_setSaveEffect (damageExpression, "none")]

}; {
	[damageExpression = dnd5e_RollExpression_Damage ()]
	[if (isWeapon):
		damageExpression = dnd5e_RollExpression_addType (damageExpression, dnd5e_Type_Weapon())]
}]
[h: damageExpression = dnd5e_RollExpression_setDiceRolled (damageExpression, damageDiceRolled)]
[h: damageExpression = dnd5e_RollExpression_setDiceSize (damageExpression, damageDiceSize)]
[h: damageExpression = dnd5e_RollExpression_setBonus (damageExpression, damageBonus)]
[h: damageExpression = dnd5e_RollExpression_addDamageType (damageExpression, damageType)]
[h: damageExpressions = json.append (damageExpressions, damageExpression)]
[h: macro.return = damageExpressions]