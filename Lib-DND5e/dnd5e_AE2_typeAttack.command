[h: oldActionType = arg(0)]
[h: exps = arg(1)]
[h: log.debug("dnd5e_AE2_typeAttack: oldActionType = " + oldActionType + " exps = " + json.indent(exps))]
[h: dnd5e_AE2_getConstants()]

<!-- Type change?, remove old type, make new attack and damage -->
[h, if (oldActionType != ATTACK_TYPE || json.isEmpty(exps)), code: {
	[h: attack = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Attack(), 0, ATTACK_TYPE)]
	[h: damage = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Damage(), 1, ATTACK_TYPE)]
	[h: newExps = json.append("[]", attack, damage)]
	[h: exps = dnd5e_AE2_removeOldTypes(oldActionType, exps, ATTACK_TYPE, newExps)]
	[h: log.debug("dnd5e_AE2_typeAttack: fixed expressions = " + json.indent(exps))]
}; {""}]
[h: return(0, exps)]