[h: inputObj = arg (0)]
[h: log.debug (getMacroName() + ": inputObj = " + inputObj)]
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
[h: log.debug ("actionObjType = " + actionObjType)]
[h: output = "Something <i>HAPPENS</i>"]

[h, if (actionObjType == "UNKNOWN"), code: {
	[h: rollExpression = dnd5e_RollExpression_SaveEffect (actionName)]
	[h: rollExpression = dnd5e_RollExpression_setSaveEffect (rollExpression, actionObj)]
	[h: rollExpression = dnd5e_RollExpression_setSaveAbility (rollExpression, "Dunno")]
	[h: rollExpression = dnd5e_RollExpression_setSaveDC (rollExpression, 0)]
	[h: rolled = json.get (dnd5e_DiceRoller_roll (rollExpression), 0)]
	[h: output = dnd5e_RollExpression_getOutput (rolled)]
	[h: log.info ("Weird code block reached: actionObj = " + actionObj)]
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
		[log.debug (getMacroName() + ": extDamageExpression = " + extDamageExpression)]
		[if (encode (extDamageExpression) != ""): attackExpressions = json.append (attackExpressions, extDamageExpression); ""]
	}]
}]
[h: rolledExpressions = dnd5e_DiceRoller_roll (attackExpressions)]

[h: log.debug (getMacroName() + ": rolledExpressions = " + rolledExpressions)]
[h: reLength = json.length (rolledExpressions)]
[h: damageRe = dnd5e_RollExpression_findExpressionByType (rolledExpressions, dnd5e_Type_Damageable())]
[h, if (reLength > 0 && json.type (damageRe) == "OBJECT"), code: {
	[firstExp = dnd5e_RollExpression_addTypedDescriptor(json.get(rolledExpressions, 0), "rollerId", currentToken())]
	[rolledExpressions = json.set(rolledExpressions, 0, firstExp)]
	[rolledExpressions = dnd5e_SavedAttacks_setKey(rolledExpressions)]
	[log.debug(getMacroName() + ": Final attack roll expression: " + json.indent(rolledExpressions))]
	[output = dnd5e_RollExpression_getFormattedOutput (rolledExpressions)]
	[dnd5e_SavedAttacks_push(rolledExpressions)]
}]
[r: output]
