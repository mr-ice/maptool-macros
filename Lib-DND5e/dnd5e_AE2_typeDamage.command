[h: oldActionType = arg(0)]
[h: exps = arg(1)]
[h: log.debug("dnd5e_AE2_typeDamage: oldActionType = " + oldActionType + " exps = " + json.indent(exps))]
[h: json.toVars(dnd5e_AE2_getConstants())]

<!-- Type change?, remove old type, make new attack and damage -->
[h, if (oldActionType != DAMAGE_TYPE || json.isEmpty(exps)), code: {
	[h: damage = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Damage(), 0, DAMAGE_TYPE)]
	[h: newExps = json.append("[]", damage)]
	[h: exps = dnd5e_AE2_removeOldTypes(oldActionType, exps, DAMAGE_TYPE, newExps)]
	[h: log.debug("dnd5e_AE2_typeDamage: fixed expressions = " + json.indent(exps))]
}; {""}]
[h: return(0, exps)]