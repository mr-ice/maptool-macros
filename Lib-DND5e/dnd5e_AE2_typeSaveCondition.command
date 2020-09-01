[h: oldActionType = arg(0)]
[h: exps = arg(1)]
[h: log.debug("dnd5e_AE2_typeSaveCondition: oldActionType = " + oldActionType + " exps = " + json.indent(exps))]
[h: json.toVars(dnd5e_AE2_getConstants())]

<!-- Type change?, remove old type, make new attack and damage -->
[h, if (oldActionType != SAVE_COND_TYPE || json.isEmpty(exps)), code: {
	[h: save = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Save(), 0, SAVE_COND_TYPE)]
	[h: save = dnd5e_RollExpression_addType(save, TARGET_ROLL_TYPE)]
	[h: cond = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_SaveEffect(), 1, SAVE_COND_TYPE)]
	[h: cond = dnd5e_RollExpression_addType(cond, UNROLLABLE_ROLL_TYPE)]
	[h: newExps = json.append("[]", save, cond)]
	[h: exps = dnd5e_AE2_removeOldTypes(oldActionType, exps, SAVE_DAMAGE_TYPE, newExps)]
	[h: log.debug("dnd5e_AE2_typeSaveCondition: fixed expressions = " + json.indent(exps))]
}; {""}]
[h: return(0, exps)]