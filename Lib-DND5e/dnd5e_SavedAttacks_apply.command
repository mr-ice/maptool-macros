<!-- Fetch the last attack and make sure one is set -->
[h: index = if(json.length(macro.args) > 0, arg(0), "")]
[h: rolledExpressions = dnd5e_SavedAttacks_get(index)]
[h, if(json.isEmpty(rolledExpressions)), code: {
	[h: broadcast("Apply Attack; No Saved Attack found", "gm")]
	[h: return(0, "")]
}; {""}]
[h: log.debug(getMacroName() + ": " + json.indent(rolledExpressions))]

<!-- Get the title -->
[h: titleExp = json.get(rolledExpressions, 0)]
[h: actionName = dnd5e_RollExpression_getTypedDescriptor(titleExp, "actionName")]
[h, if (actionName == ""): action = 0; action = 1]
[h, if (actionName == ""): actionName = dnd5e_RollExpression_getName(titleExp)]
[h: tt = + dnd5e_RollExpression_getTypedDescriptor(titleExp, "actionDesc")]
[h, if (tt != ""): tt = "<span title='" + tt + "'>"]
[h, if (tt != ""): ttEnd = "</span>"; ttEnd = ""]
[h: allOutput = "<b>Applying attack: " + tt + actionName + ttEnd + "</b>"]

<!-- Fetch the selected tokens -->
[h: sIds = getSelected()]
[h: log.debug(getMacroName() + ": IDs:'" + sIds + "' Names:" + getSelectedNames())]
[h, if(listCount(sIds) == 0), code: { 
	[h: broadcast("Apply Attack; No selected IDs", "gm")]
	[h: return(0, "")]
}; {""}]

<!-- Modify each selected token -->
[h, foreach(id, sIds), code: {
	[h: log.debug(getMacroName() + ": ID: " + id + " " + getName(id) + " HP/Max/Temp:" + getProperty("HP", id) + "/"
					+ getProperty("MaxHP", id) + "/" + getProperty("TempHP", id))]

	<!-- Starting state for ID, hit/set/check set so that steps are applied that depend on them but none are made yet. Apply each expression -->
	[h: tt = "HP/MaxHP/TempHP:" + getProperty("HP", id) + "/" + getProperty("MaxHP", id) + "/" + getProperty("TempHP", id)]
	[h: state = json.set("{}", "hit", -1, "totalDamage", 0, "save", -1, "check", -1, "action", action,
					"output", "<br><b><span title='" + tt + "'>" + getName(id) + "</span></b>")]
	[h, foreach(exp, rolledExpressions): state = dnd5e_SavedAttacks_applyRolledExpression(id, exp, state)]

	<!-- Remove the damage and update the output -->
	[h: dnd5e_removeDamage(json.set("{}", "id", id, "current", getProperty("HP", id), "temporary", getProperty("TempHP", id),
						"damage", json.get(state, "totalDamage")))]
	[h: tt = "HP/MaxHP/TempHP:" + getProperty("HP", id) + "/" + getProperty("MaxHP", id) + "/" + getProperty("TempHP", id)]
	[h: allOutput = allOutput + json.get(state, "output") + " <span title='" + tt + "'>HP: " + getProperty("HP", id)]
}]
[h: broadcast(allOutput, "gm")]