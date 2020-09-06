[h: list = arg(0)]
[h, if (listCount(list, "-") > 1), code: {
	[h: oldActionType = listGet(list, 0, "-")]
	[h: oldSpell = listGet(list, 1, "-")]
	[h, if (listCount(list, "-") > 2): oldSpellLevel = listGet(list, 2, "-"); oldSpellLevel = ""]
}; {
	[h: oldActionType = list]
	[h: oldSpell = ""]
	[h: oldSpellLevel = ""]
}]
[h: exps = arg(1)]
[h: json.toVars(dnd5e_AE2_getConstants())]
[h, if (oldActionType == DNDB_SPELL_TYPE && !json.isEmpty(exps)), code: {
	[h: firstExp = json.get(exps, 0)]
	[h: newSpell = dnd5e_RollExpression_getName(firstExp)]
	[h: newSpellLevel = json.get(firstExp, "spellLevel")]
};{
	[h: newSpell = ""]
	[h: newSpellLevel = ""]
}]
[h: log.debug("dnd5e_AE2_typeDndbSpell: oldActionType = " + oldActionType + " oldSpell=" + oldSpell + " oldSpellLevel=" + oldSpellLevel
				+ " newSpell=" + newSpell + " newSpellLevel=" + newSpellLevel + " exps = " + json.indent(exps))]

<!-- If nothing changed we are done -->
[h: return(if(oldActionType == DNDB_SPELL_TYPE && oldSpell == newSpell && oldSpellLevel == newSpellLevel && !json.isEmpty(exps), 0, 1), exps)]

<!-- Find the new spell definition -->
<!-- [h: spells = json.get(dndb_getBasicToon(), "spells")] -->
[h: spells = json.path.read(dndb_getBasicToon(), ".spells[?(@.modifiers[0].friendlyTypeName=='Damage')]")]
[h: spellNames = "[]"]
[h, foreach(spell, spells, ""): spellNames = json.append(spellNames, json.get(spell, "name"))]
[h, if (newSpell == ""): newSpell = json.get(spellNames, 0); ""]
[h: log.debug("dnd5e_AE2_typeDndbSpell: newSpell=" + newSpell + " spellNames = " + json.indent(spellNames))]
[h: spellSquashed = replace(newSpell, " ", "")]
[h, foreach(spellName, spellNames, ""), code: {
	[h: spellNameSquashed = replace(spellName, " ", "")]
 	[h, if (spellSquashed == spellNameSquashed): selectedSpell = json.get(spells, json.indexOf(spellNames, newSpell)); ""]
}]
[h, if (newSpellLevel == ""): newSpellLevel = json.get(selectedSpell, "level"); ""]

<!--Check for Save -->
[h: saveDCAbilityId = json.get(selectedSpell, "saveDCAbilityId")]
[h, if (isNumber(saveDCAbilityId)), code: {
	[h: save = dnd5e_RollExpression_Save()]
	[h: save = dnd5e_RollExpression_addType(save, TARGET_ROLL_TYPE)]
	[h: save = dnd5e_RollExpression_setSaveAbility(save, json.get(CHAR_ABILITIES, saveDCAbilityId))]
	[h: save = dnd5e_RollExpression_setSaveDC(save, json.get(selectedSpell, "saveDC"))]
}]

<!-- Create roll header -->
[h: dndb = dnd5e_AE2_decorateNewStep(dnd5e_RollExpression_DnDBeyondSpell(newSpell), 0, DNDB_SPELL_TYPE)]
[h: dndb = json.set(dndb, "spellLevel", newSpellLevel)]
[h, if (oldActionType != DNDB_SPELL_TYPE || oldSpell != newSpell), code: {
	[h: dndb = dnd5e_RollExpression_addTypedDescriptor(dndb, "actionName", json.get(selectedSpell, "name"))]
	[h: dndb = dnd5e_RollExpression_addTypedDescriptor(dndb, "actionDesc", json.get(selectedSpell, "description"))]
}]
[h: newExps = json.append("[]", dndb)]

<!-- Get spell roll and convert it to our format -->
[h: spellExps = dndb_RollExpression_buildSpellRoll(selectedSpell, newSpellLevel)]
[h: index = 1]
[h, foreach(exp, spellExps, ""), code: {
	[h: exp = json.remove(exp, "name")]
	[h, if (dnd5e_RollExpression_getExpressionType(exp) == DAMAGE_STEP_TYPE && isNumber(saveDCAbilityId)), code: {
		[h: save = dnd5e_AE2_decorateNewStep(save, index, DNDB_SPELL_TYPE)]
		[h: exp = dnd5e_AE2_decorateNewStep(exp, index + 1, DNDB_SPELL_TYPE)]
		[h: exp = dnd5e_RollExpression_setExpressionType(exp, SAVE_DAMAGE_STEP_TYPE)]
		[h: newExps = json.append(newExps, save, exp)]
		[h: index = index + 2]
	}; {
		[h: exp = dnd5e_AE2_decorateNewStep(exp, index, DNDB_SPELL_TYPE)]
		[h: newExps = json.append(newExps, exp)]
		[h: index = index + 1]
	}]
}]

[h: exps = dnd5e_AE2_removeOldTypes(oldActionType, exps, DNDB_SPELL_TYPE, newExps)]
[h: log.debug("dnd5e_AE2_typeDndbSpell: fixed expressions = " + json.indent(exps))]
[h: return(0, exps)]