<!-- Fetch the last attack and make sure one is set -->
[h: index = if(json.length(macro.args) > 0, arg(0), "")]
[h: rolledExpressions = dnd5e_SavedAttacks_get(index)]
[h, if(json.isEmpty(rolledExpressions)), code: {
	[h: broadcast("Apply Attack; No Saved Attack found")]
	[h: return(0, "")]
}; {""}]
[h: log.debug("dnd5e_SavedAttacks_apply: " + json.indent(rolledExpressions))]

<!-- Get the title -->
[h: allOutput = "<b>Applying attack: " + dnd5e_RollExpression_getName(json.get(rolledExpressions, 0)) + "</b>"]

<!-- Fetch the selected tokens -->
[h: sIds = getSelected()]
[h: log.debug("IDs:'" + sIds + "' Names:" + getSelectedNames())]
[h, if(listCount(sIds) == 0), code: { 
	[h: broadcast("Apply Attack; No selected IDs")]
	[h: return(0, "")]
}; {""}]

<!-- Modify each selected token -->
[h, foreach(id, sIds), code: {
	[h: log.debug("ID: " + id + " " + getName(id) + " HP/Max/Temp:" + getProperty("HP", id) + "/"
					+ getProperty("MaxHP", id) + "/" + getProperty("TempHP", id))]

	<!-- Starting state for ID, hit set so that damage is applied if no attack is made. Apply each expression -->
	[h: state = json.set("{}", "hit", -1, "totalDamage", 0, "output", "<br><b>" + getName(id) + "</b> HP/M/T:"
					+ getProperty("HP", id) + "/" + getProperty("MaxHP", id) + "/" + getProperty("TempHP", id))]
	[h, foreach(exp, rolledExpressions): state = dnd5e_SavedAttacks_applyRolledExpression(id, exp, state)]

	<!-- Remove the damage and update the output -->
	[h: dnd5e_removeDamage(json.set("{}", "id", id, "current", getProperty("HP", id), "temporary", getProperty("TempHP", id),
						"damage", json.get(state, "totalDamage")))]
	[h: allOutput = allOutput + json.get(state, "output") + " new HP/M/T:" + getProperty("HP", id) + "/" 
									+ getProperty("MaxHP", id) + "/" + getProperty("TempHp", id)]
}]
[h: broadcast(allOutput, "gm")]