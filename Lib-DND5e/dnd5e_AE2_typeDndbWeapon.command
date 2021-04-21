[h: list = arg(0)]
[h, if (listCount(list, "-") > 1), code: {
	[h: oldActionType = listGet(list, 0, "-")]
	[h: oldWeaponType = listGet(list, 1, "-")]
}; {
	[h: oldActionType = list]
	[h: oldWeaponType = ""]
}]
[h: exps = arg(1)]
[h: dnd5e_AE2_getConstants()]
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
[h, if (oldActionType != DNDB_ATTACK_TYPE || oldWeaponType != newWeaponType), code: {
	[h: dndb = dnd5e_RollExpression_addTypedDescriptor(dndb, ACTION_NAME_TD, dnd5e_RollExpression_getName(json.get(attackExps, 0)))]
	[h: dndb = dnd5e_RollExpression_addTypedDescriptor(dndb, ACTION_DESC_TD, dnd5e_RollExpression_getDescription(json.get(attackExps, 0)))]
}]
[h: log.debug("dnd5e_AE2_typeDndbWeapon: dndb = " + json.indent(dndb))]

[h: newExps = json.append("[]", dndb)]
[h: index = 1]
[h: saveDamageAbility = 6]
[h, foreach(exp, attackExps, ""), code: {
	[h: expType = dnd5e_RollExpression_getExpressionType(exp)]

	<!-- A combined save damag must be split into a single save and an AE2 save damage step. This creates the new save step -->
	[h, if (expType == SAVE_DAMAGE_STEP_TYPE), code: {
		[h: save = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_Save(), index, DNDB_ATTACK_TYPE)]
		[h: save = dnd5e_RollExpression_addType(save, TARGET_ROLL_TYPE)]
		[h: save = dnd5e_RollExpression_setSaveAbility(save, dnd5e_RollExpression_getSaveAbility(exp))]
		[h: save = dnd5e_RollExpression_setSaveDC(save, dnd5e_RollExpression_getSaveDC(exp, 1))]
		[h: save = dnd5e_RollExpression_setSaveEffect(save, dnd5e_RollExpression_getSaveEffect(exp))]
		[h: exp = json.remove(exp, "saveAbility")]
		[h: exp = json.remove(exp, "saveDC")]
		[h: exp = json.remove(exp, "saveEffectDescription")]
		[h: log.debug("dnd5e_AE2_typeDndbWeapon: save = " + json.indent(save))]
		[h: newExps = json.append(newExps, save)]
		[h: index = index + 1]
	}]
	
	<!-- Convert the weapon type, if it exists, to an ability mofidifier for an attack -->
	[h, if (expType == ATTACK_STEP_TYPE && json.contains(exp, "weaponType")), code: {
		[h: weaponType = dnd5e_RollExpression_getWeaponType(exp)]
		[h, switch(weaponType):
		case 0: saveDamageAbility = 0; 
		case 1: saveDamageAbility = 1;
		case 2: saveDamageAbility = 1;
		default: log.error (getMacroName() + ": Invalid weapon attack type: " + weaponType)
		]
		[h: exp = dnd5e_RollExpression_setSpellcastingAbility(exp, saveDamageAbility)]
		[h: exp = dnd5e_RollExpression_removeType(exp, "weapon")]
	}; {
		[h, if (expType == ATTACK_STEP_TYPE): saveDamageAbility = 6]
	}]

	<!-- Is there a damage ability available for damage types -->
	[h, if (dnd5e_RollExpression_getExpressionType(exp) == DAMAGE_STEP_TYPE), code: {

		<!-- Only the first damage after an attack picks up that attacks damage ability -->
		[h: exp = dnd5e_RollExpression_setSpellcastingAbility(exp, saveDamageAbility)]		
		[h: saveDamageAbility = 6]

		<!-- Wierd edge case where there are 2 damage types for a single damage type value -->
		[h: types = dnd5e_RollExpression_getDamageTypes(exp)]
		[h, if (json.length(types) > 0): types = json.get(types, 0)]
		[h, if (listCount(types) > 1): types = listGet(types, 0)]		
		[h: exp = dnd5e_RollExpression_setDamageTypes(exp, types)]
		[h: exp = dnd5e_RollExpression_removeType(exp, "weapon")]
	}]

	<!-- Decorate and copy the step to the new list -->
	[h: exp = dnd5e_AE2_decorateNewStep(exp, index, DNDB_ATTACK_TYPE)]
	[h: newExps = json.append(newExps, exp)]
	[h: index = index + 1]
	[h: log.debug("dnd5e_AE2_typeDndbWeapon: exp = " + json.indent(exp))]
}]

[h: log.debug("dnd5e_AE2_typeDndbWeapon: fixed expressions = " + json.indent(newExps))]
[h: exps = dnd5e_AE2_removeOldTypes(oldActionType, exps, DNDB_ATTACK_TYPE, newExps)]
[h: return(0, exps)]
