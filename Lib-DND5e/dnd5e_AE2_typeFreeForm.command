[h: oldActionType = arg(0)]
[h: exps = arg(1)]
[h: log.debug("dnd5e_AE2_typeFreeForm: oldActionType = " + oldActionType + " exps = " + json.indent(exps))]
[h: json.toVars(dnd5e_AE2_getConstants())]

<!-- Type change?, change existing to have no type -->
[h, if (oldActionType != FREE_FORM_TYPE), code: {
	[h: newExps = "[]"]
	[h, foreach(exp, exps, ""): newExps = json.append(newExps, dnd5e_RollExpression_removeTypedDescriptor(exp, "actionType"))]
	[h: exp = dnd5e_RollExpression_addTypedDescriptor(json.get(newExps, 0), "actionType", FREE_FORM_TYPE)]
	[h: newExps = json.set(newExps, 0, exp)]
	[h: log.debug("dnd5e_AE2_typeFreeForm: fixed expressions = " + json.indent(newExps))]
	[h: input("Bob|1|typeFreeForm|TEXT")]
}; {""}]
[h: return(0, newExps)]