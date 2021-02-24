[h: oldActionType = arg(0)]
[h: exps = arg(1)]
[h: log.debug("dnd5e_AE2_typeSaveDamage: oldActionType = " + oldActionType + " exps = " + json.indent(exps))]
[h: dnd5e_AE2_getConstants()]

<!-- Type change?, remove old type, make new attack and damage -->
[h, if (oldActionType != SAVE_DAMAGE_TYPE || json.isEmpty(exps)), code: {
	[h: save = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Save(), 0, SAVE_DAMAGE_TYPE)]
	[h: save = dnd5e_RollExpression_addType(save, TARGET_ROLL_TYPE)]
	[h: damage = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_SaveDamage(), 1, SAVE_DAMAGE_TYPE)]
	[h: newExps = json.append("[]", save, damage)]
	[h: exps = dnd5e_AE2_removeOldTypes(oldActionType, exps, SAVE_DAMAGE_TYPE, newExps)]
	[h: log.debug("dnd5e_AE2_typeSaveDamage: fixed expressions = " + json.indent(exps))]
}; {""}]
[h: return(0, exps)]