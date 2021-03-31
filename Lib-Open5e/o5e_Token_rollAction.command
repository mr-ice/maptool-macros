[h: inputObj = arg (0)]
[h: o5e_Constants(getMacroName())]
[h: isOldVersion = dnd5e_Util_checkVersion (getProperty (PROP_MONSTER_TOON_VERSION), "0.16")]

[h, if (!isOldVersion): o5e_Monster_refreshMonster_v15()]

[h: actionName = json.get (inputObj, "actionName")]
[h: advDisadv = json.get (inputObj, "advDisadv")]
[h: monsterActions = getProperty ("_o5e_MonsterActions")]
[h, if (encode (monsterActions) == ""), code: {
	[broadcast ("No Monser Actions object", "self")]
	[return (0)]
}; {""}]
[h: actionObj = json.get (monsterActions, actionName)]
[h, if (encode (actionObj) == ""), code: {
	[broadcast ("Action " + actionName + " not found")]
}; {""}]
[h: actionObjType = json.type (actionObj)]
[h: log.debug (CATEGORY + "## actionObjType = " + actionObjType)]
[h: output = "Something <i>HAPPENS</i>"]

[h, if (actionObjType == "UNKNOWN"), code: {
	[h: rollExpression = dnd5e_RollExpression_SaveEffect (actionName)]
	[h: rollExpression = dnd5e_RollExpression_setSaveEffect (rollExpression, actionObj)]
	[h: rollExpression = dnd5e_RollExpression_setSaveAbility (rollExpression, "Dunno")]
	[h: rollExpression = dnd5e_RollExpression_setSaveDC (rollExpression, 0)]
	[h: rolled = json.get (dnd5e_DiceRoller_roll (rollExpression), 0)]
	[h: output = dnd5e_RollExpression_getOutput (rolled)]
	[h: log.warn (CATEGORY + "## Weird code block reached: actionObj = " + actionObj)]
	[h: return (0, output)]
}; {""}]

[h: attackType = json.get (actionObj, "attackType")]
[h: attackExpressions = "[]"]
[h, if (attackType != ""), code: {
	[attackExpressions = o5e_RollExpression_forAttackAction (actionName, actionObj, advDisadv)]
}; {
	[extraObjs = json.get (actionObj, "extraDamage")]
	[foreach (extraObj, extraObjs), code: {
		[extDamageExpression = o5e_RollExpression_forDamageAction (extraObj)]
		[if (encode(extDamageExpression) == ""): extDamageExpression = o5e_RollExpression_forSaveAction (extraObj); ""]
		[log.debug (CATEGORY + "## extDamageExpression = " + extDamageExpression)]
		[if (json.type (extDamageExpression) == "ARRAY"):
			attackExpressions = json.merge (attackExpressions, extDamageExpression)]
		[if (json.type (extDamageExpression) == "OBJECT"):
			attackExpressions = json.append (attackExpressions, extDamageExpression)]
	}]
}]
[h: rolledExpressions = dnd5e_DiceRoller_roll (attackExpressions)]

[h: log.debug (CATEGORY + "## rolledExpressions = " + rolledExpressions)]
[h: reLength = json.length (rolledExpressions)]
[h: damageRe = dnd5e_RollExpression_findExpressionByType (rolledExpressions, dnd5e_Type_Damageable())]
[h, if (reLength > 0 && json.type (damageRe) == "OBJECT"), code: {
	[output = dnd5e_RollExpression_getFormattedOutput (rolledExpressions)]
}]
[r: output]