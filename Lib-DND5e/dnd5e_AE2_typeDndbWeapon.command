[h: list = arg(0)]
[h, if (listCount(list, "-") > 1), code: {
	[h: oldActionType = listGet(list, 0, "-")]
	[h: oldWeaponType = listGet(list, 1, "-")]
}; {
	[h: oldActionType = list]
	[h: oldWeaponType = ""]
}]
[h: exps = arg(1)]
[h: json.toVars(dnd5e_AE2_getConstants())]
[h, if (oldActionType == DNDB_ATTACK_TYPE && !json.isEmpty(exps)): newWeaponType = dnd5e_RollExpression_getName(json.get(exps, 0)); newWeaponType = ""]
[h: log.debug("dnd5e_AE2_typeDndbWeapon: oldActionType = " + oldActionType + " oldWeaponType=" + oldWeaponType 
				+ " newWeaponType=" + newWeaponType + " exps = " + json.indent(exps))]

<!-- If nothing changes we are done -->
[h: return(if(oldActionType == DNDB_ATTACK_TYPE && oldWeaponType == newWeaponType && !json.isEmpty(exps), 0, 1), exps)]

<!-- Find the new weapon expression -->
[h: attacks = json.get(dndb_getBasicToon(), "attacks")]
[h, if (newWeaponType == ""): newWeaponType = listGet(json.fields(attacks), 0); ""]
[h: attackExps = "[]"]
[h: weaponType = replace(newWeaponType, " ", "")]
[h, foreach(attack, attacks, ""), code: {
	[h: atk = replace(attack, " ", "")]
 	[h, if (weaponType == atk): attackExps = json.get(attacks, attack); ""]
}]

<!-- Convert it to our format -->
[h: dndb = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_DnDBeyondAttack(newWeaponType), 0, DNDB_ATTACK_TYPE)]
[h: newExps = json.append("[]", dndb)]
[h: index = 1]
[h, foreach(exp, attackExps, ""), code: {
	[h, if (dnd5e_RollExpression_getExpressionType(exp) == SAVE_DAMAGE_STEP_TYPE), code: {
		[h: save = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Save(), index, DNDB_ATTACK_TYPE)]
		[h: save = dnd5e_RollExpression_addType(save, TARGET_ROLL_TYPE)]
		[h: save = dnd5e_RollExpression_setSaveAbility(save, dnd5e_RollExpression_getSaveAbility(exp))]
		[h: save = dnd5e_RollExpression_setSaveDC(save, dnd5e_RollExpression_getSaveDC(exp))]
		[h: save = dnd5e_RollExpression_setSaveEffect(save, dnd5e_RollExpression_getSaveEffect(exp))]
		[h: exp = json.remove(exp, "saveAbility")]
		[h: exp = json.remove(exp, "saveDC")]
		[h: exp = json.remove(exp, "saveEffectDescription")]
		[h: exp = dnd5e_AE2_decorateNewStep(exp, index + 1, DNDB_ATTACK_TYPE)]
		[h: newExps = json.append(newExps, save, exp)]
		[h: index = index + 2]
	}; {
		[h: exp = dnd5e_AE2_decorateNewStep(exp, index, DNDB_ATTACK_TYPE)]
		[h: newExps = json.append(newExps, exp)]
		[h: index = index + 1]
	}]
}]

[h: exps = dnd5e_AE2_removeOldTypes(oldActionType, exps, DNDB_ATTACK_TYPE, newExps)]
[h: log.debug("dnd5e_AE2_typeDndbWeapon: fixed expressions = " + json.indent(exps))]
[h: return(0, exps)]