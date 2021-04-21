<!-- Read arguments -->
[h: exp = json.get(rolledExpressions, i)]
[h: selected = json.get(selectedById, id)]
[h: log.debug(getMacroName() + ": selected=" + selected + " exp=" + json.indent(exp))]

<!-- Current state -->
[h: hit = json.get(state, "hit")]
[h: check = json.get(state, "check")]
[h: hitCheck = if(hit && check, 1, 0)]
[h: save = json.get(state, "save")]

<!-- Selected options key -->
[h: expKey = "exp-" + i]
[h: playerTextColumn = '{"text":"%s"}']
[h, if (!json.isEmpty(selected) && json.contains(selected, expKey)): optValue = json.get(selected, expKey); optValue = ""]

<!-- Determine if we hit for all later damage rolls -->
[h: type = dnd5e_RollExpression_getExpressionType(exp)]
[h, if(type == ATTACK_STEP_TYPE && check), code: {
	[h: ac = getProperty("AC", id)]
	[h: ac = if(isNumber(ac), number(ac), 0)]
	[h, if (optValue == "half"): cover = 2; cover = 0]
	[h, if (optValue == "threeQuarters"): cover = 5]
	[h: hit = if(ac + cover > dnd5e_RollExpression_getTotal(exp), 0, 1)]
	[h: hitText = if(hit, "HIT", "MISS")]
	[h, if (dnd5e_RollExpression_getRoll(exp) == 20), code: {
		[h: hit = 1]
		[h: hitText = "<font color='red' size='4'><b><i>HIT</i></b></font>"]
	}]
	[h, if (dnd5e_RollExpression_getRoll(exp) == 1), code: {
		[h: hit = 0]
		[h: hitText = "<font color='red' size='4'><b><i>MISS</i></b></font>"]
	}]
	[h: tt = dnd5e_RollExpression_getTypedDescriptor(exp, TOOLTIP_ROLL_TD) + " = " 
			+ dnd5e_RollExpression_getTypedDescriptor(exp, TOOLTIP_DETAIL_TD) + " = " + dnd5e_RollExpression_getTotal(exp)]
	[h: tt = tt + if(hit, " >=", " <") + " AC(" + ac + ")" + if(cover > 0, " + Cover(" + cover + ")", "") + " = " + if (hit, "HIT", "MISS")]
	[h: output = json.get(state, "output") + " <span title='" + tt + "'>Attack " + hitText + ";</span>"]
	[h: player = json.append(json.get(state, "player"), strformat(playerTextColumn, "Attack " + hitText))]
	[h: state = json.set(state, "hit", hit, "output", output, "player", player)]
}]

<!-- On a hit/check apply calculated damage -->
[h, if(type == DAMAGE_STEP_TYPE && hitCheck), code: {
	[h: damageOutput = dnd5e_SavedAttacks_calculateDamage(id,  dnd5e_RollExpression_getTotal(exp),
		dnd5e_RollExpression_getDamageTypes(exp), optValue)]
	[h: state = dnd5e_SavedAttacks_updateState(state, damageOutput, exp)]
}]

<!-- On a hit/check make a save -->
[h, if(type == SAVE_STEP_TYPE && hitCheck), code: {
	[h: exp = dnd5e_SavedAttacks_makeSave(id, exp, optValue)]
	[h: state = json.set(state, "save", exp)]
}]

<!-- On a hit & check apply saving throw results for an action -->
[h, if(type == SAVE_DAMAGE_STEP_TYPE && hitCheck && json.get(state, "action")), code: {
	[h: damageOutput = dnd5e_SavedAttacks_calculateDamage(id,  dnd5e_RollExpression_getTotal(exp),
		dnd5e_RollExpression_getDamageTypes(exp), optValue, save, dnd5e_RollExpression_getSaveEffect(exp))]
	[h: state = dnd5e_SavedAttacks_updateState(state, damageOutput, exp)]
}]

<!-- On a hit for an attack, make saving throw, then apply calculated damage -->
[h, if(type == SAVE_DAMAGE_STEP_TYPE && hitCheck && !json.get(state, "action")), code: {
	[h: ability = dnd5e_RollExpression_getSaveAbility(exp)]
	[h, if (ability != "None"), code: {
		[h: save = dnd5e_RollExpression_Save()]
		[h: save = dnd5e_RollExpression_setSaveAbility(save, dnd5e_RollExpression_getSaveAbility(exp))]
		[h: save = dnd5e_RollExpression_setSaveDC(save, dnd5e_RollExpression_getSaveDC(exp, 1))]
		[h: save = dnd5e_RollExpression_addType(save, dnd5e_Type_Targeted())]
		[h: save = dnd5e_SavedAttacks_makeSave(id, save, optValue)]
	};{
		[h: save = ""]
	}]
	[h: damageOutput = dnd5e_SavedAttacks_calculateDamage(id,  dnd5e_RollExpression_getTotal(exp),
		dnd5e_RollExpression_getDamageTypes(exp), optValue, save, dnd5e_RollExpression_getSaveEffect(exp))]
	[h: state = dnd5e_SavedAttacks_updateState(state, damageOutput, exp)]
}]

<!-- On a hit & check apply states -->
[h, if(type == CONDITION_STEP_TYPE && hitCheck), code: {
	[h: state = dnd5e_SavedAttacks_enforceConditions(id, exp, state, optValue)]
}]

<!-- On a hit & check apply conditions based on saving throw results -->
[h, if(type == SAVE_CONDITION_STEP_TYPE && hitCheck), code: {
	[h: state = dnd5e_SavedAttacks_enforceConditions(id, exp, state, optValue, save)]
}]

<!-- Make a check against the target values -->
[h, if(type == TARGET_CHECK_STEP_TYPE && hit), code: {
	[h: state = dnd5e_SavedAttacks_evaluateCheckExpression(id, exp, state)]
}]

<!-- Drain the target of an ability score -->
[h, if(type == DRAIN_STEP_TYPE && hit), code: {
	[h: state = dnd5e_SavedAttacks_enforceDrain(id, exp, state)]
}]

<!-- Drain the target of an ability score after applying a save -->
[h, if(type == SAVE_DRAIN_STEP_TYPE && hit), code: {
	[h: state = dnd5e_SavedAttacks_enforceDrain(id, exp, state, save)]
}]
[h: log.debug(getMacroName() + ": done: " + json.indent(state))]
[h: macro.return = state]