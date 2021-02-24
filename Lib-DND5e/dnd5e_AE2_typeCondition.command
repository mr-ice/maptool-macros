[h: oldActionType = arg(0)]
[h: exps = arg(1)]
[h: log.debug("dnd5e_AE2_typeCondition: oldActionType = " + oldActionType + " exps = " + json.indent(exps))]
[h: dnd5e_AE2_getConstants()]

<!-- Type change?, remove old type, make new attack and damage -->
[h, if (oldActionType != COND_TYPE || json.isEmpty(exps)), code: {
	[h: cond = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Condition(), 0, COND_TYPE)]
	[h: newExps = json.append("[]", cond)]
	[h: exps = dnd5e_AE2_removeOldTypes(oldActionType, exps, COND_TYPE, newExps)]
	[h: log.debug("dnd5e_AE2_typeCondition: fixed expressions = " + json.indent(exps))]
}; {""}]
[h: return(0, exps)]