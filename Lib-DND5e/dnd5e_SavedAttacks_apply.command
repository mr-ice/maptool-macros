<!-- Fetch the last attack and make sure one is set -->
[h: log.debug(getMacroName() + ": args=" + json.indent(macro.args))]
[h: index = if(argCount() > 0, arg(0), "")]
[h: rolledExpressions = dnd5e_SavedAttacks_get(index)]
[h, if(json.isEmpty(rolledExpressions)), code: {
	[h: broadcast("Apply Attack; No Saved Attack found", "gm")]
	[h: return(0, "")]
}; {""}]

<!-- Get the selected tokens -->
[h: selected = if(argCount() > 1, arg(1), "")]
[h, if (json.isEmpty(selected)), code: {

	<!-- No options, use the selected IDs -->
	[h: sIds = getSelected("json")]	
};{
	[h: sIds = "[]"]
	[h, foreach(selection, selected), if (json.get(selection, "apply") == 1): sIds = json.append(sIds, json.get(selection, "id"))]
	[h: selectedById = "{}"]
	[h, foreach(selection, selected): selectedById = json.set(selectedById, json.get(selection, "id"), selection)]
}]
[h: log.debug(getMacroName() + ": IDs=" + sIds)]
[h, if(json.isEmpty(sIds)), code: { 
	[h: broadcast("Apply Attack; No selected IDs", "gm")]
	[h: return(0, "")]
}; {""}]

<!-- Get the title -->
[h: titleExp = json.get(rolledExpressions, 0)]
[h: actionName = dnd5e_RollExpression_getTypedDescriptor(titleExp, "actionName")]
[h, if (actionName == ""): action = 0; action = 1]
[h, if (actionName == ""): actionName = dnd5e_RollExpression_getName(titleExp)]
[h: tt = dnd5e_RollExpression_getTypedDescriptor(titleExp, "actionDesc")]
[h, if (tt != "") , code: {
	[h: allOutput = "<b>Applying attack: <span " +  dnd5e_Util_formatTooltip(tt) + "'>" + actionName + "</span></b>"]
}; {
	[h: allOutput = "<b>Applying attack: " + actionName + "</b>"]	
}]

<!-- Modify each selected token -->
[h, foreach(id, sIds), code: {
	[h: log.debug(getMacroName() + ": ID: " + id + " " + getName(id) + " HP/Max/Temp:" + getProperty("HP", id) + "/"
					+ getProperty("MaxHP", id) + "/" + getProperty("TempHP", id) + " selected=" + json.indent(json.get(selectedById, id)))]

	<!-- Starting state for ID, hit/set/check set so that steps are applied that depend on them but none are made yet. Apply each expression -->
	[h: tt = "HP/MaxHP/TempHP:" + getProperty("HP", id) + "/" + getProperty("MaxHP", id) + "/" + getProperty("TempHP", id)]
	[h: state = json.set("{}", "hit", -1, "totalDamage", 0, "save", -1, "check", -1, "action", action,
					"output", "<br><b><span title='" + tt + "'>" + getName(id) + "</span></b>")]
	[h, for(i, 0, json.length(rolledExpressions)): state = dnd5e_SavedAttacks_applyRolledExpression(id, json.get(rolledExpressions, i), 
																	state, json.get(selectedById, id), i)]

	<!-- Remove the damage and update the output -->
	[h: dnd5e_removeDamage(json.set("{}", "id", id, "current", getProperty("HP", id), "temporary", getProperty("TempHP", id),
						"damage", json.get(state, "totalDamage")))]
	[h: tt = "HP/MaxHP/TempHP:" + getProperty("HP", id) + "/" + getProperty("MaxHP", id) + "/" + getProperty("TempHP", id)]
	[h: allOutput = allOutput + json.get(state, "output") + " <span title='" + tt + "'>HP: " + getProperty("HP", id)]
}]
[h: broadcast(allOutput, "gm")]