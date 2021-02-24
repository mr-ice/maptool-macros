[h: oldActionType = arg(0)]
[h: exps = arg(1)]
[h: log.debug(getMacroname() + ": args" + json.indent(macro.args))]
[h: dnd5e_AE2_getConstants()]

<!-- Empty lists are bad -->
[h, if (json.isEmpty(exps)): exps = dnd5e_AE2_typeAttack("WRONG", "[]")]

<!-- Type change?, change existing to have no type -->
[h, if (oldActionType != FREE_FORM_TYPE), code: {	
	[h: newExps = "[]"]
	[h, if (json.isEmpty(exps)): oldType = ""; oldType = dnd5e_RollExpression_getTypedDescriptor(json.get(exps, 0), "actionType")]
	[h, foreach(exp, exps, ""): newExps = json.append(newExps, dnd5e_RollExpression_removeTypedDescriptor(exp, "actionType"))]
	[h: firstExp = json.get(newExps, 0)]
	[h, if (oldType == DNDB_ATTACK_TYPE || oldType == DNDB_SPELL_TYPE), code: {
		[h: newExps = json.remove(newExps, 0)]
		[h: newFirstExp = json.get(newExps, 0)]
		[h: newFirstExp = dnd5e_RollExpression_addTypedDescriptor(newFirstExp, "actionName", dnd5e_RollExpression_getTypedDescriptor(firstExp, "actionName"))]
		[h: newFirstExp = dnd5e_RollExpression_addTypedDescriptor(newFirstExp, "actionDesc", dnd5e_RollExpression_getTypedDescriptor(firstExp, "actionDesc"))]
		[h: firstExp = newFirstExp]
	}]
	[h: firstExp = dnd5e_RollExpression_addTypedDescriptor(firstExp, "actionType", FREE_FORM_TYPE)]
	[h: name = dnd5e_RollExpression_getTypedDescriptor(firstExp, "actionName")]
	[h, if (name == ""): name = "New Action"]
	[h: firstExp = dnd5e_RollExpression_addTypedDescriptor(firstExp, "actionName", name)]
	[h: newExps = json.set(newExps, 0, firstExp)]
	[h: log.debug("dnd5e_AE2_typeFreeForm: fixed expressions = " + json.indent(newExps))]
	[h: exps = newExps]
}; {""}]
[h: return(0, exps)]