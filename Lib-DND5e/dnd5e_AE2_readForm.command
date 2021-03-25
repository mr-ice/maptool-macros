[h, if (argCount() > 0): exps = arg(0); exps = "[]"]
[h: return(!json.isEmpty(exps), exps)]
[h, if (argCount() > 1): form = arg(1); form = "{}"]
[h: return(!json.isEmpty(form), exps)]
[h, if (argCount() > 2): metaData = arg(2); metaData = "{}"]
[h: dnd5e_AE2_getConstants()]

<!-- fill in the expressions from the form -->
[h: newExps = "[]"]
[h, foreach(exp, exps, ""), code: {

	<!-- Get the list of fields for the expression type -->
	[h: type = dnd5e_RollExpression_getExpressionType(exp)]
	[h: fieldList = json.get(FIELDS_BY_STEP_TYPE, type)]

	<!-- Add the extended fields to the list if needed -->
	[h: extended = dnd5e_RollExpression_getTypedDescriptor(exp, "extendedValues")]
	[h, if (extended == "-"): fieldList = json.append(fieldList, NAME_FIELD)]
	[h, if (extended == "-" && dnd5e_RollExpression_hasType(exp, "critable")): fieldList = json.append(fieldList, ON_CRITICAL_FIELD)]

	<!-- Readall of the field values from the form) -->
	[h, foreach(field, fieldList, ""): exp = dnd5e_AE2_readFormValue())]
	[h: newExps = json.append(newExps, exp)]
}]

<!-- Add the header info to the first expression -->
[h, if (json.length(newExps) > 0), code: {
	[h: exp = json.get(newExps, 0)]
	[h: newExps = json.remove(newExps, 0)]
};{
	[h: exp = "{}"]
}]
[h: exp = dnd5e_RollExpression_addTypedDescriptor(exp, "actionName", trim(json.get(form, "actionName")))]
[h: exp = dnd5e_RollExpression_addTypedDescriptor(exp, "actionDesc", trim(json.get(form, "actionDesc")))]

<!-- Fill in the meta data from the form -->
[h, if (json.contains(form, "macro-font-color")): metaData = json.set(metaData, "macroFontColor", json.get(form, "macro-font-color"))]
[h, if (json.contains(form, "macro-bg-color")): metaData = json.set(metaData, "macroBgColor", json.get(form, "macro-bg-color"))]

[h: newActionType = json.get(form, "actionType")]
[h: macro.return = json.set("{}", "newActionType", newActionType, "exps", json.merge(json.append("[]", exp), newExps), "metaData", metaData)]