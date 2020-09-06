<!-- Read arguments -->
[h: id = arg(0)]
[h: exp = arg(1)]
[h: state = arg(2)]
[h: log.debug(getMacroName() + ": args=" + json.indent(macro.args))]
[h: json.toVars(dnd5e_AE2_getConstants())]

<!-- Current state -->
[h: hit = json.get(state, "hit")]
[h: check = json.get(state, "check")]
[h: hitCheck = if(hit && check, 1, 0)]
[h: save = json.get(state, "save")]

<!-- Determine if we hit for all later damage rolls -->
[h: type = dnd5e_RollExpression_getExpressionType(exp)]
[h, if(type == ATTACK_STEP_TYPE && check), code: {
	[h: ac = getProperty("AC", id)]
	[h: ac = if(isNumber(ac), number(ac), 0)]
	[h: hit = if(ac >= dnd5e_RollExpression_getTotal(exp), false, true)]
	[h: tt = dnd5e_RollExpression_getTypedDescriptor(exp, "tooltipRoll") + " = " 
			+ dnd5e_RollExpression_getTypedDescriptor(exp, "tooltipDetail") + " = " + dnd5e_RollExpression_getTotal(exp)]
	[h: tt = tt + if(hit, " >=", " <") + " AC(" + ac + ") = " + if(hit, "HIT", "MISS")]
	[h: output = json.get(state, "output") + " <span title='" + tt + "'>Attack " + if(hit, "HIT", "MISS") + ";</span>"]
	[h: state = json.set(state, "hit", hit, "output", output)]
}]

<!-- On a hit/check apply calculated damage -->
[h, if(type == DAMAGE_STEP_TYPE && hitCheck), code: {
	[h: damageOutput = dnd5e_SavedAttacks_calculateDamage(id,  dnd5e_RollExpression_getTotal(exp),
		dnd5e_RollExpression_getDamageTypes(exp))]
	[h: state = dnd5e_SavedAttacks_updateState(state, damageOutput, exp)]
}]

<!-- On a hit/check make a save -->
[h, if(type == SAVE_STEP_TYPE && hitCheck), code: {
	[h: exp = dnd5e_SavedAttacks_makeSave(id, exp)]
	[h: state = json.set(state, "save", exp)]
}]

<!-- On a hit & check apply saving throw results for an action -->
[h, if(type == SAVE_DAMAGE_STEP_TYPE && hitCheck && json.get(state, "action")), code: {
	[h: damageOutput = dnd5e_SavedAttacks_calculateDamage(id,  dnd5e_RollExpression_getTotal(exp),
		dnd5e_RollExpression_getDamageTypes(exp), save, dnd5e_RollExpression_getSaveEffect(exp))]
	[h: state = dnd5e_SavedAttacks_updateState(state, damageOutput, exp)]
}]

<!-- On a hit for an attack, make saving throw, then apply calculated damage -->
[h, if(type == SAVE_DAMAGE_STEP_TYPE && hitCheck && !json.get(state, "action")), code: {
	[h: ability = dnd5e_RollExpression_getSaveAbility(exp)]
	[h, if (ability != "None"), code: {
		[h: save = dnd5e_RollExpression_Save()]
		[h: save = dnd5e_RollExpression_setSaveAbility(save, dnd5e_RollExpression_getSaveAbility(exp))]
		[h: save = dnd5e_RollExpression_setSaveDC(save, dnd5e_RollExpression_getSaveDC(exp, 1))]
		[h: save = dnd5e_RollExpression_addType(save, "target")]
		[h: save = dnd5e_SavedAttacks_makeSave(id, save)]
	};{
		[h: save = ""]
	}]
	[h: damageOutput = dnd5e_SavedAttacks_calculateDamage(id,  dnd5e_RollExpression_getTotal(exp),
		dnd5e_RollExpression_getDamageTypes(exp), save, dnd5e_RollExpression_getSaveEffect(exp))]
	[h: state = dnd5e_SavedAttacks_updateState(state, damageOutput, exp)]
}]

<!-- On a hit & check apply states -->
[h, if(type == CONDITION_STEP_TYPE && hitCheck), code: {
	[h: state = dnd5e_SavedAttacks_enforceConditions(id, exp, state)]
}]

<!-- On a hit & check apply conditions based on saving throw results -->
[h, if(type == SAVE_CONDITION_STEP_TYPE && hitCheck), code: {
	[h: state = dnd5e_SavedAttacks_enforceConditions(id, exp, state, save)]
}]

<!-- Make a check against the target values -->
[h, if(type == TARGET_CHECK_STEP_TYPE && hit), code: {
	[h: state = dnd5e_SavedAttacks_evaluateCheckExpression(id, exp, state)]
}]
[h: log.debug(getMacroName() + ": done: " + json.indent(state))]
[h: macro.return = state]